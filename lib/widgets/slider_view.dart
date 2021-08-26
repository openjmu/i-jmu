import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../constants/instances.dart';
import 'loading/loading_progress_indicator.dart';

/// 轮播图组件
class SliderView<T> extends StatefulWidget {
  const SliderView({
    Key? key,
    required this.models,
    required this.imageBuilder,
    required this.onItemTap,
    this.width,
    this.height,
    this.aspectRatio = 345 / 135,
    this.autoScroll = true,
    this.interval = const Duration(seconds: 5),
    this.borderRadius = 0,
    this.showIndicator = true,
    this.indicatorSize = 8,
    this.indicatorColor = Colors.white,
    this.unselectedIndicatorColor = Colors.white38,
    this.onPageChanged,
  })  : assert(
          (width != null && height != null) || aspectRatio != null,
          '至少需要一组大小限制参数',
        ),
        super(key: key);

  /// 任意类型的 Model
  final List<T> models;

  /// 通过 Model 转换出图片路径
  final String Function(T model) imageBuilder;

  /// 点击对应 Model 的回调
  final Function(int index, T model) onItemTap;

  final double? width;
  final double? height;

  /// 直接控制比例
  final double? aspectRatio;

  /// 是否允许自动滚动
  final bool autoScroll;

  /// 滚动的间隔时长
  final Duration interval;

  /// 外部圆角
  final double borderRadius;

  /// 是否展示指示器
  final bool showIndicator;

  /// 指示器的大小
  final double indicatorSize;

  /// 指示器颜色
  final Color indicatorColor;

  /// 未选中的指示器颜色
  final Color unselectedIndicatorColor;

  /// 页面切换时的回调
  final Function(int index)? onPageChanged;

  @override
  SlideViewState<T> createState() => SlideViewState<T>();
}

class SlideViewState<T> extends State<SliderView<T>>
    with WidgetsBindingObserver, RouteAware {
  /// 用于实现「伪·无限滚动」的初始倍率
  ///
  /// 假设需要实现无限滚动，只需要在初始化时设定一个非常大的值，并且在计算时取余反，
  /// 使得 [PageView.builder] 始终根据余数构建内容，并且随时可以向前滚动。
  static const int _A_LARGE_NUMBER = 20000;

  /// 当前页面滚动位置
  final ValueNotifier<double> _pageNotifier = ValueNotifier<double>(0.0);

  /// 轮播图使用的控制器
  late final PageController _pageController = PageController(
    // 初始值是 Model 个数的倍数，即从第一张开始。
    initialPage: _A_LARGE_NUMBER * widget.models.length,
  )..addListener(() {
      if (_pageController.hasClients) {
        _pageNotifier.value = _pageController.page ?? 0;
      }
    });

  /// 定时器自动轮播
  Timer? _timer;
  int _pointers = 0;
  Widget? _body;

  /// 是否仅有一个 Model
  bool get _hasOnlyOneModel => widget.models.length == 1;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!
      // 注册生命周期监听
      ..addObserver(this)
      // 当前页面绘制完第一帧后开始轮播
      ..addPostFrameCallback((_) => startTimer());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Instances.routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      startTimer();
      return;
    }
    stopTimer();
  }

  @override
  void didUpdateWidget(SliderView<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 参数更改时重新构建布局配置。
    if (oldWidget.models != widget.models ||
        oldWidget.imageBuilder != widget.imageBuilder ||
        oldWidget.onItemTap != widget.onItemTap ||
        oldWidget.width != widget.width ||
        oldWidget.height != widget.height ||
        oldWidget.aspectRatio != widget.aspectRatio ||
        oldWidget.autoScroll != widget.autoScroll ||
        oldWidget.interval != widget.interval ||
        oldWidget.borderRadius != widget.borderRadius ||
        oldWidget.showIndicator != widget.showIndicator ||
        oldWidget.indicatorSize != widget.indicatorSize ||
        oldWidget.indicatorColor != widget.indicatorColor ||
        oldWidget.unselectedIndicatorColor != widget.unselectedIndicatorColor ||
        oldWidget.onPageChanged != widget.onPageChanged) {
      setState(() {
        _body = _buildBanner();
      });
    }
  }

  @override
  void didPushNext() {
    stopTimer();
  }

  @override
  void didPopNext() {
    startTimer();
  }

  @override
  void dispose() {
    stopTimer();
    WidgetsBinding.instance?.removeObserver(this);
    Instances.routeObserver.unsubscribe(this);
    super.dispose();
  }

  void startTimer() {
    // 存在上一个 Timer 时，先取消。
    if (_timer != null) {
      stopTimer();
    }
    // 未启用滚动且只有一个 Model 时，不允许滚动。
    if (!widget.autoScroll || _hasOnlyOneModel) {
      return;
    }
    // 触发轮播切换
    _timer = Timer.periodic(
      widget.interval,
      (_) => _pageController.nextPage(
        curve: Curves.easeInOutQuart,
        duration: const Duration(milliseconds: 500),
      ),
    );
  }

  /// 停止 [_timer]
  void stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  /// 计算指示器颜色变化的插值
  double _colorInterpolation(int index, double? page) {
    // 对当前所处的索引取其与总长度的余。
    final double _page = (page ?? 0) % widget.models.length;
    // 如果余数大于最后一页的索引，但仍然在最后一页和第一页的中间，
    // 利用其于向下取整的差值相减，并且取与 1 的互补数。
    if (_page > widget.models.length - 1 && index == 0) {
      return index - (_page - _page.floor() - 1);
    }
    return index - _page;
  }

  Widget _buildBanner() {
    final Widget child = Stack(
      fit: StackFit.expand,
      children: <Widget>[
        // 轮播图片
        Positioned.fill(child: _buildBannerWidget()),
        // 指示器
        if (widget.showIndicator && !_hasOnlyOneModel) _buildIndicators(),
      ],
    );

    // 如果有比例，优先用比例进行控制。
    if (widget.aspectRatio != null) {
      return AspectRatio(aspectRatio: widget.aspectRatio!, child: child);
    }
    return SizedBox(width: widget.width, height: widget.height, child: child);
  }

  Widget _buildBannerWidget() {
    return Listener(
      onPointerDown: (_) {
        ++_pointers;
        stopTimer();
      },
      onPointerUp: (PointerUpEvent e) {
        if (_pointers == 0) {
          startTimer();
          return;
        }
        --_pointers;
        if (_pointers == 0) {
          startTimer();
        }
      },
      // 此处的 PageView 不需要设置数量，会根据取余构建重复的 item，
      // 同时自动通过 builder 机制进行优化。
      child: PageView.builder(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        // 控制器
        controller: _pageController,
        // 构建每一个子布局
        itemBuilder: _buildItem,
        itemCount: _hasOnlyOneModel ? 1 : null,
        // 滑动时回调索引
        onPageChanged: (int i) => widget.onPageChanged?.call(
          i % widget.models.length,
        ),
      ),
    );
  }

  Widget _buildIndicators() {
    final double size = widget.indicatorSize;
    return Positioned.fill(
      top: null,
      bottom: size / 1.5,
      child: Container(
        alignment: Alignment.center,
        height: size,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          // 横向滚动
          physics: const NeverScrollableScrollPhysics(),
          // 不允许滑动
          shrinkWrap: true,
          // 自适应长度
          separatorBuilder: (_, __) => SizedBox(width: size),
          itemCount: widget.models.length,
          itemBuilder: (BuildContext c, int index) =>
              _indicatorItem(c, index, size),
        ),
      ),
    );
  }

  Widget _indicatorItem(BuildContext context, int index, double size) {
    return ValueListenableBuilder<double>(
      valueListenable: _pageNotifier,
      builder: (_, double page, __) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Color.lerp(
            Colors.white,
            Colors.white38,
            math.min(1, math.max(0, _colorInterpolation(index, page).abs())),
          ),
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  /// 轮播显示图片
  Widget _buildItem(BuildContext context, int index) {
    final int _index = index % widget.models.length;
    final T _model = widget.models[_index];
    Widget item = GestureDetector(
      onTap: () => widget.onItemTap(_index, _model),
      child: _buildImage(widget.imageBuilder(_model)),
    );

    // 圆角有效时，针对圆角进行裁剪。
    if (widget.borderRadius > 0) {
      item = ClipRRect(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        child: item,
      );
    }
    return item;
  }

  Widget _buildImage(String url) {
    return Image.network(
      url,
      fit: BoxFit.cover,
      frameBuilder: (BuildContext c, Widget w, int? f, bool l) {
        if (l) {
          return w;
        }
        return AnimatedOpacity(
          opacity: f == null ? 0 : 1,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          child: w,
        );
      },
      loadingBuilder: (BuildContext c, Widget w, ImageChunkEvent? p) {
        if (p == null) {
          return w;
        }
        return Center(
          child: LoadingProgressIndicator(
            value: p.expectedTotalBytes != null
                ? p.cumulativeBytesLoaded / p.expectedTotalBytes!
                : null,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // 缓存布局配置，避免重建时再次进行内容计算。
    _body ??= _buildBanner();
    return _body!;
  }
}
