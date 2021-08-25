///
/// [Author] Alex (https://github.com/AlexV525)
/// [Date] 2020/11/4 14:55
///
// ignore_for_file: avoid_renaming_method_parameters
import 'package:flutter/foundation.dart';
import 'package:loading_more_list/loading_more_list.dart';

import '../extensions/object_extension.dart';
import '../utils/log_util.dart';
import 'data_model.dart';
import 'response_model.dart';

class LoadingBase<T extends DataModel> extends LoadingMoreBase<T> {
  LoadingBase({
    required this.request,
    this.onRefresh,
    this.onLoadSucceed,
    this.onLoadFailed,
  });

  Future<ResponseModel<T>> Function(int page) request;
  final VoidCallback? onRefresh;
  final Function(LoadingBase<T> lb, bool isMore)? onLoadSucceed;
  final Function(LoadingBase<T> lb, bool isMore, Object e)? onLoadFailed;

  int total = 0;
  int page = 1;
  bool canRequestMore = true;
  bool forceRefresh = false;

  @override
  bool get hasMore => canRequestMore;

  @override
  Future<bool> refresh([bool clearBeforeRequest = false]) async {
    canRequestMore = true;
    page = 1;
    forceRefresh = !clearBeforeRequest;
    onRefresh?.call();
    final bool result = await super.refresh(clearBeforeRequest);
    forceRefresh = false;
    return result;
  }

  @override
  Future<bool> loadData([bool isLoadMoreAction = false]) async {
    try {
      final ResponseModel<T> response = await request(
        isLoadMoreAction ? page + 1 : page,
      );
      if (response.isSucceed) {
        if (!isLoadMoreAction) {
          clear();
        }
        addAll(response.models!);
        total = response.total!;
        page = response.pageNum!;
        canRequestMore = response.canRequestMore;
      }
      setState();
      onLoadSucceed?.call(this, isLoadMoreAction);
      return response.isSucceed;
    } catch (e) {
      LogUtil.e(
        'Error when loading `$T` list: $e',
        stackTrace: e.nullableStackTrace,
      );
      onLoadFailed?.call(this, isLoadMoreAction, e);
      return false;
    }
  }

  bool get isOnlyFirstPage => page == 1 && !hasMore;
}
