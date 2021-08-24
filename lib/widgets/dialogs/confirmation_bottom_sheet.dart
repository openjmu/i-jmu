///
/// [Author] Alex (https://github.com/AlexV525)
/// [Date] 2020-01-26 23:09
///
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../constants/screens.dart';
import '../../constants/styles.dart';
import '../dismiss_wrapper.dart';

class ConfirmationBottomSheet extends StatefulWidget {
  const ConfirmationBottomSheet({
    Key? key,
    this.alignment = Alignment.bottomCenter,
    this.contentPadding = EdgeInsets.zero,
    this.title,
    this.centerTitle = true,
    this.content,
    this.contentStyle,
    this.children,
    this.showConfirm = false,
    this.confirmLabel = '确认',
    this.cancelLabel = '取消',
    this.backgroundColor,
    this.sheetRadius,
    this.buttonRadius,
  })  : assert(
          !(children == null && content == null) &&
              !(children != null && content != null),
          '\'children\' and \'content\' cannot be set or not set at the same time.',
        ),
        super(key: key);

  final AlignmentGeometry alignment;
  final String? title;
  final bool centerTitle;
  final String? content;
  final TextStyle? contentStyle;
  final List<Widget>? children;
  final EdgeInsetsGeometry contentPadding;
  final bool showConfirm;
  final String confirmLabel;
  final String cancelLabel;
  final Color? backgroundColor;
  final BorderRadius? sheetRadius;
  final BorderRadius? buttonRadius;

  static Future<bool> show(
    BuildContext context, {
    AlignmentGeometry alignment = Alignment.bottomCenter,
    EdgeInsetsGeometry contentPadding = EdgeInsets.zero,
    String? title,
    bool centerTitle = true,
    String? content,
    TextStyle? contentStyle,
    List<Widget>? children,
    bool showConfirm = false,
    String confirmLabel = '确认',
    String cancelLabel = '取消',
    Color? backgroundColor,
    BorderRadius? sheetRadius,
    BorderRadius? buttonRadius,
  }) async {
    final bool? result = await showGeneralDialog<bool>(
      context: context,
      barrierDismissible: false,
      pageBuilder: (_, __, ___) => ConfirmationBottomSheet(
        alignment: alignment,
        title: title,
        centerTitle: centerTitle,
        content: content,
        contentStyle: contentStyle,
        children: children,
        contentPadding: contentPadding,
        showConfirm: showConfirm,
        confirmLabel: confirmLabel,
        cancelLabel: cancelLabel,
        backgroundColor: backgroundColor,
        sheetRadius: sheetRadius,
        buttonRadius: buttonRadius,
      ),
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      transitionDuration: const Duration(milliseconds: 100),
    );
    return result ?? false;
  }

  @override
  ConfirmationBottomSheetState createState() => ConfirmationBottomSheetState();
}

class ConfirmationBottomSheetState extends State<ConfirmationBottomSheet> {
  final GlobalKey<DismissWrapperState> _dismissWrapperKey =
      GlobalKey<DismissWrapperState>();
  bool animating = false;

  Widget dragIndicator(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      width: 42,
      height: 6,
      decoration: BoxDecoration(
        borderRadius: RadiusConstants.max,
        color: Theme.of(context).dividerColor,
      ),
    );
  }

  Widget titleWidget(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20).copyWith(bottom: 15),
      child: Row(
        mainAxisAlignment: widget.centerTitle
            ? MainAxisAlignment.center
            : MainAxisAlignment.start,
        children: <Widget>[
          Text(
            widget.title!,
            style: const TextStyle(fontSize: 19),
          ),
        ],
      ),
    );
  }

  Widget confirmButton(BuildContext context) {
    return MaterialButton(
      elevation: 0.0,
      highlightElevation: 0.0,
      minWidth: Screens.width,
      padding: EdgeInsets.zero,
      color: widget.backgroundColor ?? Theme.of(context).cardColor,
      onPressed: () => Navigator.of(context).maybePop(true),
      child: Container(
        width: Screens.width,
        height: 40,
        margin: const EdgeInsets.only(top: 12),
        decoration: BoxDecoration(
          borderRadius: widget.buttonRadius ?? RadiusConstants.max,
          color: Theme.of(context).accentColor.withOpacity(0.9),
        ),
        child: Center(
          child: Text(
            widget.confirmLabel,
            style: Theme.of(context).textTheme.bodyText2!.copyWith(
                  color: Colors.white,
                  fontSize: 15,
                ),
          ),
        ),
      ),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  Widget cancelButton(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).maybePop(false),
      child: Container(
        color: widget.backgroundColor ?? Theme.of(context).cardColor,
        child: Stack(
          clipBehavior: Clip.none,
          children: <Widget>[
            PositionedDirectional(
              top: -1,
              start: 0,
              end: 0,
              height: 2,
              child: ColoredBox(
                color: widget.backgroundColor ?? Theme.of(context).cardColor,
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 15,
              ).copyWith(
                bottom: math.max(15, MediaQuery.of(context).padding.bottom),
              ),
              width: Screens.width,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: widget.buttonRadius ?? RadiusConstants.max,
                color: Theme.of(context).canvasColor,
              ),
              child: Center(
                child: Text(
                  widget.cancelLabel,
                  style: Theme.of(context).textTheme.bodyText2!.copyWith(
                        fontSize: 15,
                      ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (animating) {
          return false;
        }
        animating = true;
        await _dismissWrapperKey.currentState!.animateWrapper(forward: false);
        return true;
      },
      child: Material(
        color: Colors.black38,
        child: GestureDetector(
          onTap: () => Navigator.of(context).maybePop(false),
          child: Align(
            alignment: widget.alignment,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                DismissWrapper(
                  key: _dismissWrapperKey,
                  sheetRadius: widget.sheetRadius,
                  children: <Widget>[
                    dragIndicator(context),
                    if (widget.title != null) titleWidget(context),
                    Padding(
                      padding: widget.contentPadding,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: widget.content != null
                            ? <Widget>[
                                Text(
                                  widget.content!,
                                  style: widget.contentStyle ??
                                      const TextStyle(fontSize: 14),
                                  textAlign: TextAlign.center,
                                ),
                              ]
                            : widget.children!,
                      ),
                    ),
                    if (widget.showConfirm) confirmButton(context),
                  ],
                ),
                cancelButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ConfirmationBottomSheetAction extends StatelessWidget {
  const ConfirmationBottomSheetAction({
    Key? key,
    required this.icon,
    required this.text,
    required this.onTap,
    this.iconTheme,
  }) : super(key: key);

  final Widget icon;
  final String text;
  final GestureTapCallback onTap;
  final IconThemeData? iconTheme;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
        onTap();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: IconTheme(
                data: iconTheme ??
                    Theme.of(context).iconTheme.copyWith(
                          color: Color.lerp(
                            Theme.of(context).dividerColor,
                            Colors.black,
                            0.5,
                          ),
                          size: 24,
                        ),
                child: icon,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  text,
                  style: const TextStyle(fontSize: 15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
