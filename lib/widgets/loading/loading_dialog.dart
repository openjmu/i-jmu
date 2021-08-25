///
/// [Author] Alex (https://github.com/AlexV525)
/// [Date] 2020/9/9 10:46
///
import 'dart:async';

import 'package:flutter/material.dart';

import '../../constants/styles.dart';
import '../../extensions/object_extension.dart';
import '../../utils/log_util.dart';
import '../platform_progress_indicator.dart';

enum LoadingDialogStateType { success, failed, loading, dismiss }

typedef LifecycleCallback = void Function(AppLifecycleState state);

class LoadingDialogController {
  LoadingDialogState? dialogState;

  bool get mounted => dialogState != null;

  void cancel() {
    dialogState?.cancel();
  }

  void updateText(String text) {
    dialogState?.updateText(text);
  }

  void updateIcon(Widget icon) {
    dialogState?.updateIcon(icon);
  }

  void updateContent(
    LoadingDialogStateType type,
    Widget icon,
    String text,
    Duration duration,
  ) {
    dialogState?.updateContent(
      type: type,
      icon: icon,
      text: text,
      duration: duration,
    );
  }

  void updateLifecycleCallback(LifecycleCallback callback) {
    if (callback == dialogState?._onLifecycleChange) {
      return;
    }
    dialogState?._onLifecycleChange = callback;
  }

  void changeState(
    LoadingDialogStateType type,
    String text, {
    Duration? duration,
    VoidCallback? customPop,
  }) {
    LogUtil.d('Loading dialog changing state: $type, $text');
    switch (type) {
      case LoadingDialogStateType.success:
        dialogState?.updateContent(
          type: type,
          icon: const Icon(
            Icons.check_circle,
            color: Colors.green,
            size: 60,
          ),
          text: text,
          duration: duration,
          customPop: customPop,
        );
        break;
      case LoadingDialogStateType.failed:
        dialogState?.updateContent(
          type: type,
          icon: const RotationTransition(
            turns: AlwaysStoppedAnimation<double>(45 / 360),
            child: Icon(
              Icons.add_circle,
              color: Colors.redAccent,
              size: 60,
            ),
          ),
          text: text,
          duration: duration,
          customPop: customPop,
        );
        break;
      case LoadingDialogStateType.loading:
        dialogState?.updateContent(
          type: type,
          icon: const PlatformProgressIndicator(),
          text: text,
          duration: duration,
          customPop: customPop,
        );
        break;
      case LoadingDialogStateType.dismiss:
        dialogState?.updateContent(
          type: type,
          icon: const PlatformProgressIndicator(),
          text: text,
          duration: duration,
          customPop: customPop,
        );
        break;
    }
  }
}

class LoadingDialog extends StatefulWidget {
  const LoadingDialog({
    Key? key,
    this.text,
    this.controller,
    this.onLifecycleChange,
  }) : super(key: key);

  final LoadingDialogController? controller;
  final String? text;
  final LifecycleCallback? onLifecycleChange;

  @override
  LoadingDialogState createState() => LoadingDialogState();

  static const Duration defaultDuration = Duration(milliseconds: 1500);

  static LoadingDialogController show(
    BuildContext context, {
    LoadingDialogController? controller,
    String? text,
    LifecycleCallback? onLifecycleChange,
  }) {
    final LoadingDialogController _c = controller ?? LoadingDialogController();
    showDialog<void>(
      context: context,
      builder: (_) => LoadingDialog(
        controller: _c,
        text: text,
        onLifecycleChange: onLifecycleChange,
      ),
    );
    return _c;
  }
}

class LoadingDialogState extends State<LoadingDialog>
    with WidgetsBindingObserver {
  Duration _duration = LoadingDialog.defaultDuration;
  LoadingDialogStateType? _type;
  String? _text;
  VoidCallback? _customPop;
  Widget? _icon = const PlatformProgressIndicator();
  LifecycleCallback? _onLifecycleChange;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    widget.controller?.dialogState = this;
    _text = widget.text;
    _onLifecycleChange = widget.onLifecycleChange;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget.controller?.dialogState = this;
  }

  @override
  void didUpdateWidget(LoadingDialog oldWidget) {
    super.didUpdateWidget(oldWidget);
    widget.controller?.dialogState = this;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _onLifecycleChange?.call(state);
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  void cancel() {
    _customPop = null;
    if (mounted) {
      _pop();
    }
  }

  void updateContent({
    LoadingDialogStateType? type,
    Widget? icon,
    String? text,
    Duration? duration,
    VoidCallback? customPop,
  }) {
    _type = type;
    _icon = icon;
    _text = text;
    if (duration != null) {
      _duration = duration;
    }
    if (customPop != null) {
      _customPop = customPop;
    }
    if (mounted) {
      setState(() {});
    }
  }

  void updateIcon(Widget icon) {
    _icon = icon;
    if (mounted) {
      setState(() {});
    }
  }

  void updateText(String text) {
    _text = text;
    if (mounted) {
      setState(() {});
    }
  }

  void _pop() {
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget child = Center(
      child: Container(
        width: 140,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor.withOpacity(0.9),
          borderRadius: RadiusConstants.r8,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox.fromSize(
              size: const Size.square(60),
              child: Center(child: _icon),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Text(
                _text ?? '正在加载',
                style: const TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );

    if (_type != null && _type != LoadingDialogStateType.loading) {
      Future<void>.delayed(_duration, () {
        try {
          if (_customPop != null) {
            _customPop!();
          } else {
            _pop();
          }
        } catch (e) {
          LogUtil.e(
            'Error when running pop in loading dialog: $e',
            stackTrace: e.nullableStackTrace,
          );
        }
      });
    } else if (_type == LoadingDialogStateType.dismiss) {
      try {
        if (_customPop != null) {
          _customPop!();
        } else {
          _pop();
        }
      } catch (e) {
        LogUtil.e(
          'Error when running pop in loading dialog: $e',
          stackTrace: e.nullableStackTrace,
        );
      }
    }
    child = Material(type: MaterialType.transparency, child: child);

    widget.controller?.dialogState = this;

    return WillPopScope(onWillPop: () async => false, child: child);
  }
}
