///
/// [Author] Alex (https://github.com/AlexV525)
/// [Date] 11/26/20 4:33 PM
///
import 'dart:core';

import 'package:flutter/foundation.dart';
import 'package:i_jmu/constants/constants.dart'
    show GlobalJsonEncoder, currentTimeStamp;

import 'data_model.dart';

@immutable
class ResponseModel<T extends DataModel> {
  const ResponseModel({
    required this.code,
    required this.message,
    required this.timestamp,
    this.rawData,
    this.data,
    this.pageNum,
    this.pageSize,
    this.total,
    this.models,
  });

  factory ResponseModel.fromJson(
    Map<String, dynamic> json, {
    bool isModels = false,
  }) {
    return ResponseModel<T>(
      code: json['code'] as int? ?? 0,
      message: json['message'] as String? ??
          json['detail'] as String? ??
          '_Succeed (0)',
      timestamp: json['timestamp'] as int? ?? currentTimeStamp,
      data: !isModels && json['data'] != null
          ? makeModel<T>(json['data'] as Map<String, dynamic>)
          : null,
      rawData: json['data'],
      pageNum: json['page_num'] as int?,
      pageSize: json['page_size'] as int?,
      total: json['total'] as int?,
      models: isModels && json['data'] != null && json['data'] is List
          ? (json['data'] as List<dynamic>)
              .cast<Map<String, dynamic>>()
              .map((Map<String, dynamic> item) => makeModel<T>(item))
              .toList()
          : null,
    );
  }

  factory ResponseModel.replaceWith({
    required ResponseModel<dynamic> model,
    List<T>? models,
  }) {
    return ResponseModel<T>(
      code: model.code,
      message: model.message,
      timestamp: model.timestamp,
      data: model.data as T?,
      rawData: model.rawData,
      pageNum: model.pageNum,
      pageSize: model.pageSize,
      total: model.total,
      models: models,
    );
  }

  final int code;
  final String message;
  final int timestamp;
  final T? data;

  /// This is the raw data for the model.
  final Object? rawData;

  /// Below fields only works when requesting a list of data.
  final int? pageNum;
  final int? pageSize;
  final int? total;
  final List<T>? models;

  bool get isSucceed => code == 0;

  bool get isRequestError => message.contains('_InternalRequestError') == true;

  bool get canRequestMore => (pageNum! * pageSize!) < total!;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'code': code,
      'message': message,
      'timestamp': timestamp,
      if (data != null) 'data': data!.toJson(),
      if (pageNum != null) 'page_num': pageNum,
      if (pageSize != null) 'page_size': pageSize,
      if (total != null) 'count': total,
      if (models != null)
        'models': models!.map((T model) => model.toJson()).toList(),
    };
  }

  @override
  String toString() => GlobalJsonEncoder.convert(toJson());
}
