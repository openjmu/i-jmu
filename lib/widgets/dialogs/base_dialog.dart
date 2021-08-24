///
/// [Author] Alex (https://github.com/AlexV525)
/// [Date] 12/3/20 7:51 PM
///
import 'package:flutter/material.dart';

import 'package:i_jmu/constants/constants.dart';
import 'package:i_jmu/constants/styles.dart';
import 'package:i_jmu/extensions/build_context_extension.dart';

import '../gaps.dart';

class BaseDialog extends StatelessWidget {
  const BaseDialog({
    Key? key,
    required this.title,
    this.description,
    this.backgroundColor = Colors.black38,
    this.showConfirm = true,
    this.showCancel = true,
    this.confirmLabel = '确认',
    this.cancelLabel = '取消',
    this.cancelColor,
    this.confirmColor,
    this.headerImage,
    this.headerImageSize,
    this.headerImagePackage,
    this.boxConstraints = const BoxConstraints(maxWidth: kDialogMaxWidth),
  }) : super(key: key);

  final String title;
  final String? description;
  final Color backgroundColor;
  final bool showConfirm;
  final bool showCancel;
  final String confirmLabel;
  final String cancelLabel;
  final Color? cancelColor;
  final Color? confirmColor;
  final String? headerImage;
  final Size? headerImageSize;
  final String? headerImagePackage;
  final BoxConstraints boxConstraints;

  static Future<bool> show({
    required BuildContext context,
    bool barrierDismissible = false,
    required String title,
    String? description,
    Color backgroundColor = Colors.black38,
    bool showConfirm = true,
    bool showCancel = true,
    String confirmLabel = '确认',
    String cancelLabel = '取消',
    Color? cancelColor,
    Color? confirmColor,
    String? headerImage,
    Size? headerImageSize,
    String? headerImagePackage,
    BoxConstraints boxConstraints = const BoxConstraints(
      maxWidth: kDialogMaxWidth,
    ),
  }) async {
    final bool? _result = await showGeneralDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierLabel: title,
      barrierColor: backgroundColor,
      transitionDuration: const Duration(milliseconds: 250),
      pageBuilder: (_, __, ___) => BaseDialog(
        title: title,
        description: description,
        backgroundColor: backgroundColor,
        showConfirm: showConfirm,
        showCancel: showCancel,
        confirmLabel: confirmLabel,
        cancelLabel: cancelLabel,
        cancelColor: cancelColor,
        confirmColor: confirmColor,
        headerImage: headerImage,
        headerImageSize: headerImageSize,
        headerImagePackage: headerImagePackage,
        boxConstraints: boxConstraints,
      ),
      transitionBuilder: _buildDialogTransitions,
      useRootNavigator: true,
    );
    return _result ?? false;
  }

  Size get _effectiveHeaderImageSize =>
      headerImageSize ?? const Size.square(70);

  Widget _headerImageBuilder(BuildContext context) {
    return Positioned(
      top: -_effectiveHeaderImageSize.height / 2,
      left: 0,
      right: 0,
      child: Image.asset(
        headerImage!,
        package: headerImagePackage,
        width: _effectiveHeaderImageSize.width,
        height: _effectiveHeaderImageSize.height,
      ),
    );
  }

  Widget _contentSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(25).copyWith(bottom: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (headerImage != null)
            Gap.v(_effectiveHeaderImageSize.height / 2 - 10),
          _titleWidget(context),
          if (description != null) ..._descriptionWidget(context),
        ],
      ),
    );
  }

  Widget _titleWidget(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      textAlign: TextAlign.center,
    );
  }

  List<Widget> _descriptionWidget(BuildContext context) {
    return <Widget>[
      const Gap.v(15),
      Text(
        description!,
        style: TextStyle(
          color: context.theme.dividerColor.withOpacity(0.5),
          fontSize: 16,
        ),
        textAlign: TextAlign.center,
      )
    ];
  }

  Widget _actionsSection(BuildContext context) {
    if (!showConfirm && !showCancel) {
      return const SizedBox.shrink();
    }
    return DefaultTextStyle.merge(
      style: const TextStyle(color: Colors.grey, fontSize: 15),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: <Widget>[
            if (showCancel) _cancelButton(context),
            if (showCancel && showConfirm) const Gap.h(10),
            if (showConfirm) _confirmButton(context),
          ],
        ),
      ),
    );
  }

  Widget _cancelButton(BuildContext context) {
    return Expanded(
      child: _Button(
        text: cancelLabel,
        color: cancelColor ?? context.theme.canvasColor,
        onTap: () {
          Navigator.of(context).maybePop(false);
        },
      ),
    );
  }

  Widget _confirmButton(BuildContext context) {
    return Expanded(
      child: _Button(
        text: confirmLabel,
        textColor: Colors.white,
        color: confirmColor ?? defaultLightColor,
        onTap: () {
          Navigator.of(context).maybePop(true);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        type: MaterialType.transparency,
        child: ConstrainedBox(
          constraints: boxConstraints,
          child: Stack(
            clipBehavior: Clip.none,
            children: <Widget>[
              ClipRRect(
                borderRadius: RadiusConstants.r10,
                child: Container(
                  width: 300,
                  color: context.theme.cardColor,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      _contentSection(context),
                      _actionsSection(context),
                    ],
                  ),
                ),
              ),
              if (headerImage != null) _headerImageBuilder(context),
            ],
          ),
        ),
      ),
    );
  }
}

class _Button extends StatelessWidget {
  const _Button({
    Key? key,
    required this.text,
    this.textColor,
    this.color,
    this.onTap,
  }) : super(key: key);

  final String text;
  final Color? textColor;
  final Color? color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        height: 47,
        decoration: BoxDecoration(
          borderRadius: RadiusConstants.r5,
          color: color,
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

final Animatable<double> _dialogScaleTween = Tween<double>(begin: 1.3, end: 1.0)
    .chain(CurveTween(curve: Curves.linearToEaseOut));

Widget _buildDialogTransitions(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child,
) {
  final CurvedAnimation fadeAnimation = CurvedAnimation(
    parent: animation,
    curve: Curves.easeInOut,
  );
  if (animation.status == AnimationStatus.reverse) {
    return FadeTransition(
      opacity: fadeAnimation,
      child: child,
    );
  }
  return FadeTransition(
    opacity: fadeAnimation,
    child: ScaleTransition(
      child: child,
      scale: animation.drive(_dialogScaleTween),
    ),
  );
}
