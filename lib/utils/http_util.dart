///
/// [Author] Alex (https://github.com/AlexV525)
/// [Date] 2020/4/23 13:30
///
import 'dart:convert';
import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../apis/api.dart';
import '../constants/constants.dart';
import '../extensions/object_extension.dart';
import '../models/data_model.dart';
import '../models/response_model.dart';

import 'device_util.dart';
import 'log_util.dart';
import 'other_utils.dart';
import 'package_util.dart';
import 'toast_util.dart';

enum FetchType { head, get, post, put, patch, delete }

class HttpUtil {
  const HttpUtil._();

  static final Dio dio = Dio()
    ..options = BaseOptions(
      connectTimeout: kReleaseMode ? 15000 : null,
      sendTimeout: kReleaseMode ? 30000 : null,
      receiveTimeout: kReleaseMode ? 15000 : null,
      receiveDataWhenStatusError: true,
    )
    ..interceptors.add(_interceptor);

  static ResponseModel<T> _successModel<T extends DataModel>() =>
      ResponseModel<T>(code: 1, message: '', timestamp: currentTimeStamp);

  static ResponseModel<T> _failModel<T extends DataModel>(String message) =>
      ResponseModel<T>(
        code: 0,
        message: '_InternalRequestError: $message',
        timestamp: currentTimeStamp,
      );

  static Future<T> fetch<T>(
    FetchType fetchType, {
    required String url,
    Map<String, String>? queryParameters,
    dynamic body,
    Map<String, dynamic>? headers,
    ResponseType? responseType,
  }) async {
    final Response<T> response = await getResponse(
      fetchType,
      url: url,
      queryParameters: queryParameters,
      body: body,
      headers: headers,
      responseType: responseType,
    );
    return response.data!;
  }

  static Future<ResponseModel<T>> fetchModel<T extends DataModel>(
    FetchType fetchType, {
    required String url,
    Map<String, String>? queryParameters,
    dynamic body,
    Map<String, dynamic>? headers,
    ResponseType responseType = ResponseType.json,
  }) async {
    final Response<Map<String, dynamic>> response = await getResponse(
      fetchType,
      url: url,
      queryParameters: queryParameters,
      body: body,
      headers: headers,
      responseType: responseType,
    );

    final Map<String, dynamic>? resBody = response.data;
    if (resBody?.isNotEmpty ?? false) {
      final ResponseModel<T> model = ResponseModel<T>.fromJson(resBody!);
      LogUtil.d('Response model: $model');
      if (!model.isSucceed) {
        LogUtil.d('Response is not succeed: ${model.message}');
      }
      return model;
    } else {
      return _handleStatusCode(response);
    }
  }

  static Future<ResponseModel<T>> fetchModels<T extends DataModel>(
    FetchType fetchType, {
    required String url,
    Map<String, String?>? queryParameters,
    dynamic body,
    Map<String, dynamic>? headers,
    ResponseType responseType = ResponseType.json,
  }) async {
    final Response<Map<String, dynamic>> response = await getResponse(
      fetchType,
      url: url,
      queryParameters: queryParameters,
      body: body,
      headers: headers,
      responseType: responseType,
    );

    final Map<String, dynamic>? resBody = response.data;
    if (resBody?.isNotEmpty ?? false) {
      final ResponseModel<T> model = ResponseModel<T>.fromJson(
        resBody!,
        isModels: true,
      );
      LogUtil.d('Response model: $model');
      if (!model.isSucceed) {
        LogUtil.d('Response is not succeed: ${model.message}');
      }
      return model;
    } else {
      return _handleStatusCode(response);
    }
  }

  static Future<String> getFilenameFromResponse(
    Response<dynamic> res,
    String url,
  ) async {
    String? filename = res.headers
        .value('content-disposition')
        ?.split('; ')
        .where((String element) => element.contains('filename'))
        .first;
    if (filename != null) {
      final RegExp filenameReg = RegExp(r'filename=\"(.+)\"');
      filename = filenameReg.allMatches(filename).first.group(1);
      filename = Uri.decodeComponent(filename!);
    } else {
      filename = url.split('/').last.split('?').first;
    }
    return filename;
  }

  /// For download progress, here we don't simply use the [dio.download],
  /// because there's no file name provided. So in here we take two steps:
  ///  * Using [HEAD] to get the 'content-disposition' in headers to determine
  ///   the real file name of the attachment.
  ///  * Call [dio.download] to download the file with the real name.
  ///
  /// Return save path if succeed.
  static Future<String?> download(
    String url,
    String filename, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? headers,
    ProgressCallback? progressCallback,
    CancelToken? cancelToken,
    Options? options,
  }) async {
    String path;
    if (await checkPermissions(<Permission>[Permission.storage])) {
      showToast('开始下载...');
      LogUtil.d('File start download: $url');
      path = '${(await getExternalStorageDirectory())!.path}/$filename';
      try {
        if (File(path).existsSync()) {
          _openFile(path);
          return path;
        }
        await dio.download(
          url,
          path,
          data: data,
          options: Options(headers: headers),
          onReceiveProgress: progressCallback,
        );
        LogUtil.d('File downloaded: $path');
        showToast('下载完成 $path');
        _openFile(path);
        return path;
      } catch (e) {
        LogUtil.e(
          'File download failed: $e',
          stackTrace: e.nullableStackTrace,
        );
        return null;
      }
    } else {
      LogUtil.e('No permission to download file: $url');
      showToast('未获得存储权限');
      return null;
    }
  }

  static Future<OpenResult?> _openFile(String path) async {
    try {
      final OpenResult result = await OpenFile.open(path);
      return result;
    } catch (e) {
      LogUtil.e('Error when opening file [$path]: $e');
      return null;
    }
  }

  static ResponseModel<T> _handleStatusCode<T extends DataModel>(
    Response<dynamic> response,
  ) {
    final int statusCode = response.statusCode ?? 0;
    LogUtil.d('Response status code: ${response.statusCode}');
    if (statusCode >= 200 && statusCode < 300) {
      LogUtil.d('Response code success: $statusCode');
      return _successModel();
    }
    if (statusCode >= 300 && statusCode < 400) {
      LogUtil.d('Response code moved: $statusCode');
      return _successModel();
    }
    if (statusCode >= 400 && statusCode < 500) {
      final String message = 'Response code client error: $statusCode';
      LogUtil.d(message);
      return _failModel(message);
    }
    if (statusCode >= 500) {
      final String message = 'Response code server error: $statusCode';
      LogUtil.d(message);
      return _failModel(message);
    }
    final String message = 'Response code unknown status: $statusCode';
    LogUtil.d(message);
    return _failModel(message);
  }

  static Future<Response<T>> getResponse<T>(
    FetchType fetchType, {
    required String url,
    Map<String, String?>? queryParameters,
    dynamic body,
    Map<String, dynamic>? headers,
    ResponseType? responseType = ResponseType.json,
  }) async {
    final Response<T> response;
    headers ??= <String, String?>{};
    if (UserAPI.token != null) {
      headers['X-Id-Token'] = UserAPI.token;
    }
    String? _userAgent;
    if (Platform.isAndroid) {
      _userAgent = (DeviceUtil.deviceInfo as AndroidDeviceInfo).forUserAgent;
    } else if (Platform.isIOS) {
      _userAgent = (DeviceUtil.deviceInfo as IosDeviceInfo).forUserAgent;
    }
    headers['X-Device-Info'] = _userAgent;
    headers['X-Terminal-Info'] =
        Platform.isAndroid || Platform.isIOS ? 'mobile' : 'desktop';
    headers['user-agent'] = '$_userAgent '
        '(${PackageUtil.packageInfo.packageName})';

    // Recreate <String, String> headers and queryParameters.
    final Map<String, dynamic> _headers = headers.map<String, dynamic>(
      (String key, dynamic value) =>
          MapEntry<String, dynamic>(key, value.toString()),
    );
    if (_headers.isNotEmpty) {
      LogUtil.d('$fetchType headers: $_headers');
    }
    final Map<String, String>? _queryParameters =
        queryParameters?.map<String, String>(
      (String key, dynamic value) =>
          MapEntry<String, String>(key, value.toString()),
    );
    final Uri replacedUri = Uri.parse(url).replace(
      queryParameters: _queryParameters,
    );
    LogUtil.d('$fetchType url: ${dio.options.baseUrl}$replacedUri');
    if (_queryParameters != null) {
      LogUtil.d('Fetch with queries: $_queryParameters');
    }
    if (body != null) {
      LogUtil.d('Raw request body: $body');
    }

    switch (fetchType) {
      case FetchType.head:
        response = await dio.head(
          replacedUri.toString(),
          options: Options(
            followRedirects: true,
            headers: _headers,
            receiveDataWhenStatusError: true,
            responseType: responseType,
          ),
        );
        break;
      case FetchType.get:
        response = await dio.get(
          replacedUri.toString(),
          options: Options(
            followRedirects: true,
            headers: _headers,
            receiveDataWhenStatusError: true,
            responseType: responseType,
          ),
        );
        break;
      case FetchType.post:
        response = await dio.post(
          replacedUri.toString(),
          data: body,
          options: Options(
            followRedirects: true,
            headers: _headers,
            receiveDataWhenStatusError: true,
            responseType: responseType,
          ),
        );
        break;
      case FetchType.put:
        response = await dio.put(
          replacedUri.toString(),
          data: body,
          options: Options(
            followRedirects: true,
            headers: _headers,
            receiveDataWhenStatusError: true,
            responseType: responseType,
          ),
        );
        break;
      case FetchType.patch:
        response = await dio.patch(
          replacedUri.toString(),
          data: body,
          options: Options(
            followRedirects: true,
            headers: _headers,
            receiveDataWhenStatusError: true,
            responseType: responseType,
          ),
        );
        break;
      case FetchType.delete:
        response = await dio.delete(
          replacedUri.toString(),
          data: body,
          options: Options(
            followRedirects: true,
            headers: _headers,
            receiveDataWhenStatusError: true,
            responseType: responseType,
          ),
        );
        break;
    }
    LogUtil.d(
      'Got response from: ${dio.options.baseUrl}$replacedUri '
      '${response.statusCode}',
    );
    LogUtil.d('Raw response body: ${response.data}');
    return response;
  }

  static InterceptorsWrapper get _interceptor {
    return InterceptorsWrapper(
      onResponse: (
        Response<dynamic> res,
        ResponseInterceptorHandler handler,
      ) {
        dynamic _resolvedData;
        if (res.statusCode == HttpStatus.noContent) {
          const Map<String, dynamic>? _data = null;
          _resolvedData = _data;
        }
        final dynamic data = res.data;
        if (data is String) {
          try {
            // If we do want a JSON all the time, DO try to decode the data.
            _resolvedData = jsonDecode(data) as Map<String, dynamic>?;
          } catch (e) {
            _resolvedData = data;
          }
        } else {
          _resolvedData = data;
        }
        res.data = _resolvedData;
        handler.resolve(res);
      },
      onError: (
        DioError e,
        ErrorInterceptorHandler handler,
      ) async {
        if (e.response?.statusCode == HttpStatus.unauthorized) {
          // Lock & Clear all queries with the dio instance.
          dio
            ..lock()
            ..clear();
          dio.interceptors.requestLock
            ..lock()
            ..clear();
          dio.interceptors.responseLock
            ..lock()
            ..clear();
          dio.interceptors.errorLock
            ..lock()
            ..clear();
          // Unlock all instances after token has removed.
          dio.unlock();
          dio.interceptors.requestLock.unlock();
          dio.interceptors.responseLock.unlock();
          dio.interceptors.errorLock.unlock();
          // Then start from the splash page.
          // Eject the response eventually.
          handler.reject(e);
          return;
        }
        LogUtil.e(
          'Error when requesting: $e\n'
          'Raw response data: ${e.response?.data}',
        );
        e.response ??= Response<Map<String, dynamic>>(
          requestOptions: e.requestOptions,
          data: _failModel(e.message).toJson(),
        );
        handler.reject(e);
      },
    );
  }
}
