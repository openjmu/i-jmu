///
/// [Author] Alex (https://github.com/AlexV525)
/// [Date] 2020/9/15 12:35
///
import 'package:flutter/cupertino.dart' show CupertinoActivityIndicator;
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:loading_more_list/loading_more_list.dart';
import 'package:pull_to_refresh_notification/pull_to_refresh_notification.dart'
    hide CupertinoActivityIndicator;

import '../../constants/resources.dart';
import '../../constants/screens.dart';
import '../../extensions/build_context_extension.dart';
import '../../models/data_model.dart';
import '../../models/loading_base.dart';
import '../gaps.dart';
import 'pull_to_refresh_header.dart';

const double maxDragOffset = 60;

class RefreshListWrapper<T extends DataModel> extends StatelessWidget {
  const RefreshListWrapper({
    Key? key,
    required this.loadingBase,
    required this.itemBuilder,
    this.dividerBuilder,
    this.refreshHeaderTextStyle,
    this.indicatorPlaceholder,
    this.indicatorIcon,
    this.indicatorPackage,
    this.indicatorText,
    this.indicatorTextStyle,
    this.padding,
    this.scrollDirection = Axis.vertical,
    this.enableRefresh = true,
  }) : super(key: key);

  final LoadingBase<T> loadingBase;
  final EdgeInsetsGeometry? padding;
  final Axis scrollDirection;
  final Widget Function(T model) itemBuilder;

  final IndexedWidgetBuilder? dividerBuilder;
  final TextStyle? refreshHeaderTextStyle;
  final Widget Function(bool isError)? indicatorPlaceholder;
  final String Function(bool isError)? indicatorIcon;
  final String? Function(bool isError)? indicatorPackage;
  final String Function(bool isError)? indicatorText;
  final TextStyle? indicatorTextStyle;

  /// 是否启用刷新（默认启用）
  ///
  /// 有一些特殊的场景，需要一个不分页的列表，但需要占位和错误提示，可以设置为 false。
  final bool enableRefresh;

  EdgeInsetsGeometry? _buildEffectivePadding(BuildContext context) {
    EdgeInsetsGeometry? _padding = padding;
    if (padding == null) {
      final MediaQueryData mediaQuery = MediaQuery.of(context);
      // Automatically pad sliver with padding from MediaQuery.
      final EdgeInsets mediaQueryHorizontalPadding =
          mediaQuery.padding.copyWith(top: 0.0, bottom: 0.0);
      final EdgeInsets mediaQueryVerticalPadding =
          mediaQuery.padding.copyWith(left: 0.0, right: 0.0);
      // Consume the main axis padding with SliverPadding.
      _padding = scrollDirection == Axis.vertical
          ? mediaQueryVerticalPadding
          : mediaQueryHorizontalPadding;
    }
    return _padding;
  }

  Widget indicatorBuilder(
    BuildContext context,
    IndicatorStatus status,
  ) {
    final Widget indicator;
    switch (status) {
      case IndicatorStatus.none:
        indicator = const SizedBox.shrink();
        break;
      case IndicatorStatus.loadingMoreBusying:
        indicator = ListMoreIndicator(
          isSliver: false,
          isRequesting: true,
          textStyle: indicatorTextStyle,
        );
        break;
      case IndicatorStatus.fullScreenBusying:
        indicator = ListMoreIndicator(
          isRequesting: true,
          textStyle: indicatorTextStyle,
        );
        break;
      case IndicatorStatus.error:
        indicator = ListEmptyIndicator(
          isSliver: false,
          isError: true,
          loadingBase: loadingBase,
          indicator: indicatorPlaceholder,
          indicatorIcon: indicatorIcon,
          indicatorPackage: indicatorPackage,
          indicatorText: indicatorText,
          textStyle: indicatorTextStyle,
        );
        break;
      case IndicatorStatus.fullScreenError:
        indicator = ListEmptyIndicator(
          isError: true,
          loadingBase: loadingBase,
          indicator: indicatorPlaceholder,
          indicatorIcon: indicatorIcon,
          indicatorPackage: indicatorPackage,
          indicatorText: indicatorText,
          textStyle: indicatorTextStyle,
        );
        break;
      case IndicatorStatus.noMoreLoad:
        if (loadingBase.isOnlyFirstPage) {
          indicator = const SizedBox.shrink();
        } else {
          indicator = ListMoreIndicator(
            isSliver: false,
            textStyle: indicatorTextStyle,
          );
        }
        break;
      case IndicatorStatus.empty:
        indicator = ListEmptyIndicator(
          loadingBase: loadingBase,
          indicator: indicatorPlaceholder,
          indicatorIcon: indicatorIcon,
          indicatorPackage: indicatorPackage,
          indicatorText: indicatorText,
          textStyle: indicatorTextStyle,
        );
        break;
    }
    return indicator;
  }

  @override
  Widget build(BuildContext context) {
    Widget child = LoadingMoreCustomScrollView(
      scrollDirection: scrollDirection,
      rebuildCustomScrollView: true,
      slivers: <Widget>[
        PullToRefreshContainer((PullToRefreshScrollNotificationInfo? info) {
          return PullToRefreshHeader.buildRefreshHeader(
            context,
            info,
            textStyle: refreshHeaderTextStyle,
          );
        }),
        LoadingMoreSliverList<T>(
          SliverListConfig<T>(
            sourceList: loadingBase,
            itemBuilder: (BuildContext c, T model, int index) {
              if (dividerBuilder == null) {
                return itemBuilder(model);
              }
              if (index.isEven) {
                return itemBuilder(loadingBase[index ~/ 2]);
              }
              return dividerBuilder!(c, index);
            },
            indicatorBuilder: indicatorBuilder,
            childCountBuilder: dividerBuilder != null
                ? (int length) => length == 0 ? 0 : length * 2 - 1
                : null,
            getActualIndex:
                dividerBuilder != null ? (int index) => index ~/ 2 : null,
            padding: padding ?? _buildEffectivePadding(context),
          ),
        ),
      ],
    );
    if (enableRefresh) {
      child = PullToRefreshNotification(
        onRefresh: loadingBase.refresh,
        maxDragOffset: maxDragOffset,
        pullBackCurve: Curves.linear,
        pullBackDuration: const Duration(milliseconds: 200),
        child: child,
      );
    }
    return child;
  }
}

class ListMoreIndicator extends StatelessWidget {
  const ListMoreIndicator({
    Key? key,
    this.isSliver = true,
    this.isRequesting = false,
    this.textStyle,
  }) : super(key: key);

  final bool isSliver;
  final bool isRequesting;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    Widget child;
    child = SizedBox(
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          AnimatedSwitcher(
            duration: kTabScrollDuration,
            child: isRequesting
                ? const CupertinoActivityIndicator()
                : const SizedBox.shrink(),
          ),
          AnimatedContainer(
            duration: kTabScrollDuration,
            width: isRequesting ? 10 : 0,
          ),
          Text(isRequesting ? '加载中...' : '已经到底啦'),
        ],
      ),
    );
    if (isSliver) {
      child = SliverFillRemaining(child: Center(child: child));
    }
    return DefaultTextStyle(
      style: textStyle ??
          TextStyle(
            color: context.theme.dividerColor.withOpacity(0.375),
            fontSize: 14,
            height: 1.4,
          ),
      child: child,
    );
  }
}

class ListEmptyIndicator extends StatelessWidget {
  const ListEmptyIndicator({
    Key? key,
    this.isSliver = true,
    this.isError = false,
    this.loadingBase,
    this.indicator,
    this.indicatorIcon,
    this.indicatorPackage,
    this.indicatorText,
    this.textStyle,
    this.onTap,
  }) : super(key: key);

  final bool isSliver;
  final bool isError;
  final LoadingBase<dynamic>? loadingBase;
  final Widget Function(bool isError)? indicator;
  final String Function(bool isError)? indicatorIcon;
  final String? Function(bool isError)? indicatorPackage;
  final String Function(bool isError)? indicatorText;
  final TextStyle? textStyle;
  final VoidCallback? onTap;

  static const String EMPTY_TEXT = '空空如也';
  static const String ERROR_TEXT = '网络出错了~点此重试';

  @override
  Widget build(BuildContext context) {
    Widget child;
    String? _text = indicatorText?.call(isError);
    _text ??= isError ? ERROR_TEXT : EMPTY_TEXT;
    child = GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: isError
          ? () {
              if (onTap != null) {
                onTap!();
              } else {
                loadingBase
                  ?..refresh()
                  ..isLoading = true
                  ..setState();
              }
            }
          : null,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          if (indicator != null)
            indicator!(isError)
          else ...<Widget>[
            SvgPicture.asset(
              indicatorIcon?.call(isError) ??
                  (isError
                      ? R.ASSETS_PLACEHOLDER_NO_NETWORK_SVG
                      : R.ASSETS_PLACEHOLDER_SEARCH_NO_RESULT_SVG),
              width: 150,
            ),
            const Gap.v(20),
            Text(_text),
          ],
          Gap.v(Screens.height / 6),
        ],
      ),
    );
    if (isSliver) {
      child = SliverFillRemaining(child: child);
    }
    return DefaultTextStyle(
      style: textStyle ??
          context.textTheme.caption!.copyWith(fontSize: 17, height: 1.4),
      textAlign: TextAlign.center,
      child: child,
    );
  }
}
