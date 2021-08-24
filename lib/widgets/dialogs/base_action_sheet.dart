///
/// [Author] Alex (https://github.com/AlexV525)
/// [Date] 2/2/21 3:47 PM
///
import 'dart:ui' show ImageFilter;

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

const TextStyle _kActionSheetActionStyle = TextStyle(
  fontFamily: '.SF UI Text',
  inherit: false,
  fontSize: 20.0,
  fontWeight: FontWeight.w400,
  textBaseline: TextBaseline.alphabetic,
);

const TextStyle _kActionSheetContentStyle = TextStyle(
  fontFamily: '.SF UI Text',
  inherit: false,
  fontSize: 13.0,
  fontWeight: FontWeight.w400,
  color: _kContentTextColor,
  textBaseline: TextBaseline.alphabetic,
);

const Color _kBackgroundColor = CupertinoDynamicColor.withBrightness(
  color: Colors.white,
  darkColor: Color(0xC7252525),
);

const Color _kPressedColor = CupertinoDynamicColor.withBrightness(
  color: Color(0xFFE1E1E1),
  darkColor: Color(0xFF2E2E2E),
);

const Color _kCancelPressedColor = CupertinoDynamicColor.withBrightness(
  color: Color(0xFFECECEC),
  darkColor: Color(0xFF49494B),
);

const Color _kContentTextColor = Color(0xFF8F8F8F);

const Color _kButtonDividerColor = _kContentTextColor;

const double _kBlurAmount = 20.0;
const double _kEdgeHorizontalPadding = 8.0;
const double _kCancelButtonPadding = 8.0;
const double _kEdgeVerticalPadding = 10.0;
const double _kContentHorizontalPadding = 40.0;
const double _kContentVerticalPadding = 14.0;
const double _kButtonHeight = 56.0;
const double _kCornerRadius = 14.0;
const double _kDividerThickness = 1.0;

class BaseActionSheet extends StatelessWidget {
  const BaseActionSheet({
    Key? key,
    this.title,
    this.message,
    this.actions,
    this.messageScrollController,
    this.actionScrollController,
    this.cancelButton,
  })  : assert(
          actions != null ||
              title != null ||
              message != null ||
              cancelButton != null,
          'An action sheet must have a non-null value for at least one of '
          'the following arguments: actions, title, message, or cancelButton',
        ),
        super(key: key);

  final Widget? title;
  final Widget? message;
  final List<BaseActionSheetAction>? actions;
  final ScrollController? messageScrollController;
  final ScrollController? actionScrollController;
  final BaseActionSheetAction? cancelButton;

  static Future<T?> show<T>({
    required BuildContext context,
    Widget? title,
    Widget? message,
    List<BaseActionSheetAction>? actions,
    ScrollController? messageScrollController,
    ScrollController? actionScrollController,
    BaseActionSheetAction? cancelButton,
  }) {
    return showCupertinoModalPopup<T>(
      context: context,
      builder: (_) => BaseActionSheet(
        title: title,
        message: message,
        actions: actions,
        messageScrollController: messageScrollController,
        actionScrollController: actionScrollController,
        cancelButton: cancelButton,
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final List<Widget> content = <Widget>[];
    if (title != null || message != null) {
      final Widget titleSection = _BaseAlertContentSection(
        title: title,
        message: message,
        scrollController: messageScrollController,
      );
      content.add(Flexible(child: titleSection));
    }

    return Container(
      color: CupertinoDynamicColor.resolve(_kBackgroundColor, context),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: content,
      ),
    );
  }

  Widget _buildActions() {
    if (actions == null || actions!.isEmpty) {
      return const SizedBox(height: 0.0);
    }
    return _BaseAlertActionSection(
      children: actions!,
      scrollController: actionScrollController,
      hasCancelButton: cancelButton != null,
    );
  }

  Widget _buildCancelButton() {
    final double cancelPadding =
        (actions != null || message != null || title != null)
            ? _kCancelButtonPadding
            : 0.0;
    return Padding(
      padding: EdgeInsets.only(top: cancelPadding),
      child: _BaseActionSheetCancelButton(
        child: cancelButton,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = <Widget>[
      Flexible(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12.0),
          child: BackdropFilter(
            filter:
                ImageFilter.blur(sigmaX: _kBlurAmount, sigmaY: _kBlurAmount),
            child: _BaseAlertRenderWidget(
              contentSection: Builder(builder: _buildContent),
              actionsSection: _buildActions(),
            ),
          ),
        ),
      ),
      if (cancelButton != null) _buildCancelButton(),
    ];

    final Orientation orientation = MediaQuery.of(context).orientation;
    double actionSheetWidth;
    if (orientation == Orientation.portrait) {
      actionSheetWidth =
          MediaQuery.of(context).size.width - (_kEdgeHorizontalPadding * 2);
    } else {
      actionSheetWidth =
          MediaQuery.of(context).size.height - (_kEdgeHorizontalPadding * 2);
    }

    return SafeArea(
      child: Semantics(
        namesRoute: true,
        scopesRoute: true,
        explicitChildNodes: true,
        label: 'Alert',
        child: CupertinoUserInterfaceLevel(
          data: CupertinoUserInterfaceLevelData.elevated,
          child: Container(
            width: actionSheetWidth,
            margin: const EdgeInsets.symmetric(
              horizontal: _kEdgeHorizontalPadding,
              vertical: _kEdgeVerticalPadding,
            ),
            child: Column(
              children: children,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
            ),
          ),
        ),
      ),
    );
  }
}

class BaseActionSheetAction extends StatelessWidget {
  const BaseActionSheetAction({
    Key? key,
    required this.onPressed,
    this.isDefaultAction = false,
    this.isDestructiveAction = false,
    required this.child,
  }) : super(key: key);

  final VoidCallback onPressed;
  final bool isDefaultAction;
  final bool isDestructiveAction;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    TextStyle style = _kActionSheetActionStyle.copyWith(
      color: isDestructiveAction
          ? CupertinoDynamicColor.resolve(CupertinoColors.systemRed, context)
          : CupertinoTheme.of(context).primaryColor,
    );

    if (isDefaultAction) {
      style = style.copyWith(fontWeight: FontWeight.w600);
    }

    return GestureDetector(
      onTap: onPressed,
      behavior: HitTestBehavior.opaque,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minHeight: _kButtonHeight,
        ),
        child: Semantics(
          button: true,
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(
              vertical: 16.0,
              horizontal: 10.0,
            ),
            child: DefaultTextStyle(
              style: style,
              child: child,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}

class _BaseActionSheetCancelButton extends StatefulWidget {
  const _BaseActionSheetCancelButton({
    Key? key,
    this.child,
  }) : super(key: key);

  final Widget? child;

  @override
  _BaseActionSheetCancelButtonState createState() =>
      _BaseActionSheetCancelButtonState();
}

class _BaseActionSheetCancelButtonState
    extends State<_BaseActionSheetCancelButton> {
  bool isBeingPressed = false;

  void _onTapDown(TapDownDetails event) {
    setState(() {
      isBeingPressed = true;
    });
  }

  void _onTapUp(TapUpDetails event) {
    setState(() {
      isBeingPressed = false;
    });
  }

  void _onTapCancel() {
    setState(() {
      isBeingPressed = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = isBeingPressed
        ? _kCancelPressedColor
        : CupertinoColors.secondarySystemGroupedBackground;
    return GestureDetector(
      excludeFromSemantics: true,
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: Container(
        decoration: BoxDecoration(
          color: CupertinoDynamicColor.resolve(backgroundColor, context),
          borderRadius: BorderRadius.circular(_kCornerRadius),
        ),
        child: widget.child,
      ),
    );
  }
}

class _BaseAlertRenderWidget extends RenderObjectWidget {
  const _BaseAlertRenderWidget({
    Key? key,
    required this.contentSection,
    required this.actionsSection,
  }) : super(key: key);

  final Widget contentSection;
  final Widget actionsSection;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderBaseAlert(
      dividerThickness:
          _kDividerThickness / MediaQuery.of(context).devicePixelRatio,
      dividerColor:
          CupertinoDynamicColor.resolve(_kButtonDividerColor, context),
    );
  }

  @override
  void updateRenderObject(BuildContext context, _RenderBaseAlert renderObject) {
    super.updateRenderObject(context, renderObject);
    renderObject.dividerColor =
        CupertinoDynamicColor.resolve(_kButtonDividerColor, context);
  }

  @override
  RenderObjectElement createElement() {
    return _BaseAlertRenderElement(this);
  }
}

class _BaseAlertRenderElement extends RenderObjectElement {
  _BaseAlertRenderElement(_BaseAlertRenderWidget widget) : super(widget);

  Element? _contentElement;
  Element? _actionsElement;

  @override
  _BaseAlertRenderWidget get widget => super.widget as _BaseAlertRenderWidget;

  @override
  _RenderBaseAlert get renderObject => super.renderObject as _RenderBaseAlert;

  @override
  void visitChildren(ElementVisitor visitor) {
    if (_contentElement != null) {
      visitor(_contentElement!);
    }
    if (_actionsElement != null) {
      visitor(_actionsElement!);
    }
  }

  @override
  void mount(Element? parent, dynamic newSlot) {
    super.mount(parent, newSlot);
    _contentElement = updateChild(
        _contentElement, widget.contentSection, _AlertSections.contentSection);
    _actionsElement = updateChild(
        _actionsElement, widget.actionsSection, _AlertSections.actionsSection);
  }

  @override
  void insertRenderObjectChild(RenderObject child, _AlertSections slot) {
    _placeChildInSlot(child, slot);
  }

  @override
  void moveRenderObjectChild(
      RenderObject child, _AlertSections oldSlot, _AlertSections newSlot) {
    _placeChildInSlot(child, newSlot);
  }

  @override
  void update(RenderObjectWidget newWidget) {
    super.update(newWidget);
    _contentElement = updateChild(
        _contentElement, widget.contentSection, _AlertSections.contentSection);
    _actionsElement = updateChild(
        _actionsElement, widget.actionsSection, _AlertSections.actionsSection);
  }

  @override
  void forgetChild(Element child) {
    assert(child == _contentElement || child == _actionsElement);
    if (_contentElement == child) {
      _contentElement = null;
    } else if (_actionsElement == child) {
      _actionsElement = null;
    }
    super.forgetChild(child);
  }

  @override
  void removeRenderObjectChild(RenderObject child, _AlertSections slot) {
    assert(child == renderObject.contentSection ||
        child == renderObject.actionsSection);
    if (renderObject.contentSection == child) {
      renderObject.contentSection = null;
    } else if (renderObject.actionsSection == child) {
      renderObject.actionsSection = null;
    }
  }

  void _placeChildInSlot(RenderObject child, _AlertSections slot) {
    switch (slot) {
      case _AlertSections.contentSection:
        renderObject.contentSection = child as RenderBox;
        break;
      case _AlertSections.actionsSection:
        renderObject.actionsSection = child as RenderBox;
        break;
    }
  }
}

class _RenderBaseAlert extends RenderBox {
  _RenderBaseAlert({
    RenderBox? contentSection,
    RenderBox? actionsSection,
    double dividerThickness = 0.0,
    required Color dividerColor,
  })  : _contentSection = contentSection,
        _actionsSection = actionsSection,
        _dividerThickness = dividerThickness,
        _dividerPaint = Paint()
          ..color = dividerColor
          ..style = PaintingStyle.fill;

  RenderBox? get contentSection => _contentSection;
  RenderBox? _contentSection;

  set contentSection(RenderBox? newContentSection) {
    if (newContentSection != _contentSection) {
      if (null != _contentSection) {
        dropChild(_contentSection!);
      }
      _contentSection = newContentSection;
      if (null != _contentSection) {
        adoptChild(_contentSection!);
      }
    }
  }

  RenderBox? get actionsSection => _actionsSection;
  RenderBox? _actionsSection;

  set actionsSection(RenderBox? newActionsSection) {
    if (newActionsSection != _actionsSection) {
      if (null != _actionsSection) {
        dropChild(_actionsSection!);
      }
      _actionsSection = newActionsSection;
      if (null != _actionsSection) {
        adoptChild(_actionsSection!);
      }
    }
  }

  Color get dividerColor => _dividerPaint.color;

  set dividerColor(Color value) {
    if (value == _dividerPaint.color) {
      return;
    }
    _dividerPaint.color = value;
    markNeedsPaint();
  }

  final double _dividerThickness;

  final Paint _dividerPaint;

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    if (null != contentSection) {
      contentSection!.attach(owner);
    }
    if (null != actionsSection) {
      actionsSection!.attach(owner);
    }
  }

  @override
  void detach() {
    super.detach();
    if (null != contentSection) {
      contentSection!.detach();
    }
    if (null != actionsSection) {
      actionsSection!.detach();
    }
  }

  @override
  void redepthChildren() {
    if (null != contentSection) {
      redepthChild(contentSection!);
    }
    if (null != actionsSection) {
      redepthChild(actionsSection!);
    }
  }

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! MultiChildLayoutParentData) {
      child.parentData = MultiChildLayoutParentData();
    }
  }

  @override
  void visitChildren(RenderObjectVisitor visitor) {
    if (contentSection != null) {
      visitor(contentSection!);
    }
    if (actionsSection != null) {
      visitor(actionsSection!);
    }
  }

  @override
  List<DiagnosticsNode> debugDescribeChildren() {
    final List<DiagnosticsNode> value = <DiagnosticsNode>[];
    if (contentSection != null) {
      value.add(contentSection!.toDiagnosticsNode(name: 'content'));
    }
    if (actionsSection != null) {
      value.add(actionsSection!.toDiagnosticsNode(name: 'actions'));
    }
    return value;
  }

  @override
  double computeMinIntrinsicWidth(double height) {
    return constraints.minWidth;
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    return constraints.maxWidth;
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    final double contentHeight = contentSection!.getMaxIntrinsicHeight(width);
    final double actionsHeight = actionsSection!.getMaxIntrinsicHeight(width);
    final bool hasDivider = contentHeight > 0.0 && actionsHeight > 0.0;
    double height =
        contentHeight + (hasDivider ? _dividerThickness : 0.0) + actionsHeight;

    if (actionsHeight > 0 || contentHeight > 0)
      height -= 2 * _kEdgeVerticalPadding;
    if (height.isFinite) {
      return height;
    }
    return 0.0;
  }

  double _computeDividerThickness(BoxConstraints constraints) {
    final bool hasDivider =
        contentSection!.getMaxIntrinsicHeight(constraints.maxWidth) > 0.0 &&
            actionsSection!.getMaxIntrinsicHeight(constraints.maxWidth) > 0.0;
    return hasDivider ? _dividerThickness : 0.0;
  }

  _AlertSizes _computeSizes(
      {required BoxConstraints constraints,
      required ChildLayouter layoutChild,
      required double dividerThickness}) {
    final double minActionsHeight =
        actionsSection!.getMinIntrinsicHeight(constraints.maxWidth);

    final Size contentSize = layoutChild(
      contentSection!,
      constraints.deflate(
          EdgeInsets.only(bottom: minActionsHeight + dividerThickness)),
    );

    final Size actionsSize = layoutChild(
      actionsSection!,
      constraints
          .deflate(EdgeInsets.only(top: contentSize.height + dividerThickness)),
    );

    final double actionSheetHeight =
        contentSize.height + dividerThickness + actionsSize.height;
    return _AlertSizes(
      size: Size(constraints.maxWidth, actionSheetHeight),
      contentHeight: contentSize.height,
    );
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    return _computeSizes(
      constraints: constraints,
      layoutChild: ChildLayoutHelper.dryLayoutChild,
      dividerThickness: _computeDividerThickness(constraints),
    ).size;
  }

  @override
  void performLayout() {
    final BoxConstraints constraints = this.constraints;
    final double dividerThickness = _computeDividerThickness(constraints);
    final _AlertSizes alertSizes = _computeSizes(
      constraints: constraints,
      layoutChild: ChildLayoutHelper.layoutChild,
      dividerThickness: dividerThickness,
    );

    size = alertSizes.size;

    // Set the position of the actions box to sit at the bottom of the alert.
    // The content box defaults to the top left, which is where we want it.
    assert(actionsSection!.parentData is MultiChildLayoutParentData);
    final MultiChildLayoutParentData actionParentData =
        actionsSection!.parentData! as MultiChildLayoutParentData;
    actionParentData.offset =
        Offset(0.0, alertSizes.contentHeight + dividerThickness);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final MultiChildLayoutParentData contentParentData =
        contentSection!.parentData! as MultiChildLayoutParentData;
    contentSection!.paint(context, offset + contentParentData.offset);

    final bool hasDivider =
        contentSection!.size.height > 0.0 && actionsSection!.size.height > 0.0;
    if (hasDivider) {
      _paintDividerBetweenContentAndActions(context.canvas, offset);
    }

    final MultiChildLayoutParentData actionsParentData =
        actionsSection!.parentData! as MultiChildLayoutParentData;
    actionsSection!.paint(context, offset + actionsParentData.offset);
  }

  void _paintDividerBetweenContentAndActions(Canvas canvas, Offset offset) {
    canvas.drawRect(
      Rect.fromLTWH(
        offset.dx,
        offset.dy + contentSection!.size.height,
        size.width,
        _dividerThickness,
      ),
      _dividerPaint,
    );
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    final MultiChildLayoutParentData contentSectionParentData =
        contentSection!.parentData! as MultiChildLayoutParentData;
    final MultiChildLayoutParentData actionsSectionParentData =
        actionsSection!.parentData! as MultiChildLayoutParentData;
    return result.addWithPaintOffset(
          offset: contentSectionParentData.offset,
          position: position,
          hitTest: (BoxHitTestResult result, Offset transformed) {
            assert(transformed == position - contentSectionParentData.offset);
            return contentSection!.hitTest(result, position: transformed);
          },
        ) ||
        result.addWithPaintOffset(
          offset: actionsSectionParentData.offset,
          position: position,
          hitTest: (BoxHitTestResult result, Offset transformed) {
            assert(transformed == position - actionsSectionParentData.offset);
            return actionsSection!.hitTest(result, position: transformed);
          },
        );
  }
}

class _AlertSizes {
  const _AlertSizes({required this.size, required this.contentHeight});

  final Size size;
  final double contentHeight;
}

enum _AlertSections { contentSection, actionsSection }

class _BaseAlertContentSection extends StatelessWidget {
  const _BaseAlertContentSection({
    Key? key,
    this.title,
    this.message,
    this.scrollController,
  }) : super(key: key);

  final Widget? title;
  final Widget? message;
  final ScrollController? scrollController;

  @override
  Widget build(BuildContext context) {
    final List<Widget> titleContentGroup = <Widget>[];

    if (title != null) {
      titleContentGroup.add(Padding(
        padding: const EdgeInsets.only(
          left: _kContentHorizontalPadding,
          right: _kContentHorizontalPadding,
          bottom: _kContentVerticalPadding,
          top: _kContentVerticalPadding,
        ),
        child: DefaultTextStyle(
          style: message == null
              ? _kActionSheetContentStyle
              : _kActionSheetContentStyle.copyWith(fontWeight: FontWeight.w600),
          textAlign: TextAlign.center,
          child: title!,
        ),
      ));
    }

    if (message != null) {
      titleContentGroup.add(
        Padding(
          padding: EdgeInsets.only(
            left: _kContentHorizontalPadding,
            right: _kContentHorizontalPadding,
            bottom: title == null ? _kContentVerticalPadding : 22.0,
            top: title == null ? _kContentVerticalPadding : 0.0,
          ),
          child: DefaultTextStyle(
            style: title == null
                ? _kActionSheetContentStyle.copyWith(
                    fontWeight: FontWeight.w600)
                : _kActionSheetContentStyle,
            textAlign: TextAlign.center,
            child: message!,
          ),
        ),
      );
    }

    if (titleContentGroup.isEmpty) {
      return SingleChildScrollView(
        controller: scrollController,
        child: const SizedBox(
          width: 0.0,
          height: 0.0,
        ),
      );
    }

    if (titleContentGroup.length > 1) {
      titleContentGroup.insert(
          1, const Padding(padding: EdgeInsets.only(top: 8.0)));
    }

    return CupertinoScrollbar(
      child: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: titleContentGroup,
        ),
      ),
    );
  }
}

class _BaseAlertActionSection extends StatefulWidget {
  const _BaseAlertActionSection({
    Key? key,
    required this.children,
    this.scrollController,
    this.hasCancelButton,
  }) : super(key: key);

  final List<Widget> children;
  final ScrollController? scrollController;
  final bool? hasCancelButton;

  @override
  _BaseAlertActionSectionState createState() => _BaseAlertActionSectionState();
}

class _BaseAlertActionSectionState extends State<_BaseAlertActionSection> {
  @override
  Widget build(BuildContext context) {
    final double devicePixelRatio = MediaQuery.of(context).devicePixelRatio;

    final List<Widget> interactiveButtons = <Widget>[];
    for (int i = 0; i < widget.children.length; i += 1) {
      interactiveButtons.add(
        _PressableActionButton(
          child: widget.children[i],
        ),
      );
    }

    return CupertinoScrollbar(
      child: SingleChildScrollView(
        controller: widget.scrollController,
        child: _BaseAlertActionsRenderWidget(
          actionButtons: interactiveButtons,
          dividerThickness: _kDividerThickness / devicePixelRatio,
          hasCancelButton: widget.hasCancelButton ?? false,
        ),
      ),
    );
  }
}

class _PressableActionButton extends StatefulWidget {
  const _PressableActionButton({
    required this.child,
  });

  final Widget child;

  @override
  _PressableActionButtonState createState() => _PressableActionButtonState();
}

class _PressableActionButtonState extends State<_PressableActionButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return _ActionButtonParentDataWidget(
      isPressed: _isPressed,
      child: GestureDetector(
        excludeFromSemantics: true,
        behavior: HitTestBehavior.opaque,
        onTapDown: (TapDownDetails details) =>
            setState(() => _isPressed = true),
        onTapUp: (TapUpDetails details) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        child: widget.child,
      ),
    );
  }
}

class _ActionButtonParentDataWidget
    extends ParentDataWidget<_ActionButtonParentData> {
  const _ActionButtonParentDataWidget({
    Key? key,
    required this.isPressed,
    required Widget child,
  }) : super(key: key, child: child);

  final bool isPressed;

  @override
  void applyParentData(RenderObject renderObject) {
    assert(renderObject.parentData is _ActionButtonParentData);
    final _ActionButtonParentData parentData =
        renderObject.parentData! as _ActionButtonParentData;
    if (parentData.isPressed != isPressed) {
      parentData.isPressed = isPressed;

      // Force a repaint.
      final AbstractNode? targetParent = renderObject.parent;
      if (targetParent is RenderObject) {
        targetParent.markNeedsPaint();
      }
    }
  }

  @override
  Type get debugTypicalAncestorWidgetClass => _BaseAlertActionsRenderWidget;
}

class _ActionButtonParentData extends MultiChildLayoutParentData {
  _ActionButtonParentData({
    this.isPressed = false,
  });

  bool isPressed;
}

class _BaseAlertActionsRenderWidget extends MultiChildRenderObjectWidget {
  _BaseAlertActionsRenderWidget({
    Key? key,
    required List<Widget> actionButtons,
    double dividerThickness = 0.0,
    bool hasCancelButton = false,
  })  : _dividerThickness = dividerThickness,
        _hasCancelButton = hasCancelButton,
        super(key: key, children: actionButtons);

  final double _dividerThickness;
  final bool _hasCancelButton;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderBaseAlertActions(
      dividerThickness: _dividerThickness,
      dividerColor:
          CupertinoDynamicColor.resolve(_kButtonDividerColor, context),
      hasCancelButton: _hasCancelButton,
      backgroundColor:
          CupertinoDynamicColor.resolve(_kBackgroundColor, context),
      pressedColor: CupertinoDynamicColor.resolve(_kPressedColor, context),
    );
  }

  @override
  void updateRenderObject(
      BuildContext context, _RenderBaseAlertActions renderObject) {
    renderObject
      ..dividerThickness = _dividerThickness
      ..dividerColor =
          CupertinoDynamicColor.resolve(_kButtonDividerColor, context)
      ..hasCancelButton = _hasCancelButton
      ..backgroundColor =
          CupertinoDynamicColor.resolve(_kBackgroundColor, context)
      ..pressedColor = CupertinoDynamicColor.resolve(_kPressedColor, context);
  }
}

// An iOS-style layout policy for sizing and positioning an action sheet's
// buttons.
//
// The policy is as follows:
//
// Action sheet buttons are always stacked vertically. In the case where the
// content section and the action section combined can not fit on the screen
// without scrolling, the height of the action section is determined as
// follows.
//
// If the user has included a separate cancel button, the height of the action
// section can be up to the height of 3 action buttons (i.e., the user can
// include 1, 2, or 3 action buttons and they will appear without needing to
// be scrolled). If 4+ action buttons are provided, the height of the action
// section shrinks to 1.5 buttons tall, and is scrollable.
//
// If the user has not included a separate cancel button, the height of the
// action section is at most 1.5 buttons tall.
class _RenderBaseAlertActions extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, MultiChildLayoutParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, MultiChildLayoutParentData> {
  _RenderBaseAlertActions({
    List<RenderBox>? children,
    double dividerThickness = 0.0,
    required Color dividerColor,
    bool hasCancelButton = false,
    required Color backgroundColor,
    required Color pressedColor,
  })  : _dividerThickness = dividerThickness,
        _hasCancelButton = hasCancelButton,
        _buttonBackgroundPaint = Paint()
          ..style = PaintingStyle.fill
          ..color = backgroundColor,
        _pressedButtonBackgroundPaint = Paint()
          ..style = PaintingStyle.fill
          ..color = pressedColor,
        _dividerPaint = Paint()
          ..color = dividerColor
          ..style = PaintingStyle.fill {
    addAll(children);
  }

  // The thickness of the divider between buttons.
  double get dividerThickness => _dividerThickness;
  double _dividerThickness;

  set dividerThickness(double newValue) {
    if (newValue == _dividerThickness) {
      return;
    }

    _dividerThickness = newValue;
    markNeedsLayout();
  }

  Color get backgroundColor => _buttonBackgroundPaint.color;

  set backgroundColor(Color newValue) {
    if (newValue == _buttonBackgroundPaint.color) {
      return;
    }

    _buttonBackgroundPaint.color = newValue;
    markNeedsPaint();
  }

  Color get pressedColor => _pressedButtonBackgroundPaint.color;

  set pressedColor(Color newValue) {
    if (newValue == _pressedButtonBackgroundPaint.color) {
      return;
    }

    _pressedButtonBackgroundPaint.color = newValue;
    markNeedsPaint();
  }

  Color get dividerColor => _dividerPaint.color;

  set dividerColor(Color value) {
    if (value == _dividerPaint.color) {
      return;
    }
    _dividerPaint.color = value;
    markNeedsPaint();
  }

  bool _hasCancelButton;

  bool get hasCancelButton => _hasCancelButton;

  set hasCancelButton(bool newValue) {
    if (newValue == _hasCancelButton) {
      return;
    }

    _hasCancelButton = newValue;
    markNeedsLayout();
  }

  final Paint _buttonBackgroundPaint;
  final Paint _pressedButtonBackgroundPaint;

  final Paint _dividerPaint;

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! _ActionButtonParentData)
      child.parentData = _ActionButtonParentData();
  }

  @override
  double computeMinIntrinsicWidth(double height) {
    return constraints.minWidth;
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    return constraints.maxWidth;
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    if (childCount == 0) {
      return 0.0;
    }
    if (childCount == 1)
      return firstChild!.computeMaxIntrinsicHeight(width) + dividerThickness;
    if (hasCancelButton && childCount < 4)
      return _computeMinIntrinsicHeightWithCancel(width);
    return _computeMinIntrinsicHeightWithoutCancel(width);
  }

  // The minimum height for more than 2-3 buttons when a cancel button is
  // included is the full height of button stack.
  double _computeMinIntrinsicHeightWithCancel(double width) {
    assert(childCount == 2 || childCount == 3);
    if (childCount == 2) {
      return firstChild!.getMinIntrinsicHeight(width) +
          childAfter(firstChild!)!.getMinIntrinsicHeight(width) +
          dividerThickness;
    }
    return firstChild!.getMinIntrinsicHeight(width) +
        childAfter(firstChild!)!.getMinIntrinsicHeight(width) +
        childAfter(childAfter(firstChild!)!)!.getMinIntrinsicHeight(width) +
        (dividerThickness * 2);
  }

  // The minimum height for more than 2 buttons when no cancel button or 4+
  // buttons when a cancel button is included is the height of the 1st button
  // + 50% the height of the 2nd button + 2 dividers.
  double _computeMinIntrinsicHeightWithoutCancel(double width) {
    assert(childCount >= 2);
    return firstChild!.getMinIntrinsicHeight(width) +
        dividerThickness +
        (0.5 * childAfter(firstChild!)!.getMinIntrinsicHeight(width));
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    if (childCount == 0) {
      return 0.0;
    }
    if (childCount == 1) {
      return firstChild!.computeMaxIntrinsicHeight(width) + dividerThickness;
    }
    return _computeMaxIntrinsicHeightStacked(width);
  }

  // Max height of a stack of buttons is the sum of all button heights + a
  // divider for each button.
  double _computeMaxIntrinsicHeightStacked(double width) {
    assert(childCount >= 2);

    final double allDividersHeight = (childCount - 1) * dividerThickness;
    double heightAccumulation = allDividersHeight;
    RenderBox? button = firstChild;
    while (button != null) {
      heightAccumulation += button.getMaxIntrinsicHeight(width);
      button = childAfter(button);
    }
    return heightAccumulation;
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    return _performLayout(constraints, dry: true);
  }

  @override
  void performLayout() {
    size = _performLayout(constraints, dry: false);
  }

  Size _performLayout(BoxConstraints constraints, {bool dry = false}) {
    final BoxConstraints perButtonConstraints = constraints.copyWith(
      minHeight: 0.0,
      maxHeight: double.infinity,
    );

    RenderBox? child = firstChild;
    int index = 0;
    double verticalOffset = 0.0;
    while (child != null) {
      final Size childSize;
      if (!dry) {
        child.layout(
          perButtonConstraints,
          parentUsesSize: true,
        );
        childSize = child.size;
        assert(child.parentData is MultiChildLayoutParentData);
        final MultiChildLayoutParentData parentData =
            child.parentData! as MultiChildLayoutParentData;
        parentData.offset = Offset(0.0, verticalOffset);
      } else {
        childSize = child.getDryLayout(constraints);
      }

      verticalOffset += childSize.height;
      if (index < childCount - 1) {
        // Add a gap for the next divider.
        verticalOffset += dividerThickness;
      }

      index += 1;
      child = childAfter(child);
    }

    return constraints.constrain(Size(constraints.maxWidth, verticalOffset));
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final Canvas canvas = context.canvas;
    _drawButtonBackgroundsAndDividersStacked(canvas, offset);
    _drawButtons(context, offset);
  }

  void _drawButtonBackgroundsAndDividersStacked(Canvas canvas, Offset offset) {
    final Offset dividerOffset = Offset(0.0, dividerThickness);

    final Path backgroundFillPath = Path()
      ..fillType = PathFillType.evenOdd
      ..addRect(Rect.fromLTWH(0.0, 0.0, size.width, size.height));

    final Path pressedBackgroundFillPath = Path();

    final Path dividersPath = Path();

    Offset accumulatingOffset = offset;

    RenderBox? child = firstChild;
    RenderBox? prevChild;
    while (child != null) {
      assert(child.parentData is _ActionButtonParentData);
      final _ActionButtonParentData currentButtonParentData =
          child.parentData! as _ActionButtonParentData;
      final bool isButtonPressed = currentButtonParentData.isPressed;

      bool isPrevButtonPressed = false;
      if (prevChild != null) {
        assert(prevChild.parentData is _ActionButtonParentData);
        final _ActionButtonParentData previousButtonParentData =
            prevChild.parentData! as _ActionButtonParentData;
        isPrevButtonPressed = previousButtonParentData.isPressed;
      }

      final bool isDividerPresent = child != firstChild;
      final bool isDividerPainted =
          isDividerPresent && !(isButtonPressed || isPrevButtonPressed);
      final Rect dividerRect = Rect.fromLTWH(
        accumulatingOffset.dx,
        accumulatingOffset.dy,
        size.width,
        _dividerThickness,
      );

      final Rect buttonBackgroundRect = Rect.fromLTWH(
        accumulatingOffset.dx,
        accumulatingOffset.dy + (isDividerPresent ? dividerThickness : 0.0),
        size.width,
        child.size.height,
      );

      // If this button is pressed, then we don't want a white background to be
      // painted, so we erase this button from the background path.
      if (isButtonPressed) {
        backgroundFillPath.addRect(buttonBackgroundRect);
        pressedBackgroundFillPath.addRect(buttonBackgroundRect);
      }

      // If this divider is needed, then we erase the divider area from the
      // background path, and on top of that we paint a translucent gray to
      // darken the divider area.
      if (isDividerPainted) {
        backgroundFillPath.addRect(dividerRect);
        dividersPath.addRect(dividerRect);
      }

      accumulatingOffset += (isDividerPresent ? dividerOffset : Offset.zero) +
          Offset(0.0, child.size.height);

      prevChild = child;
      child = childAfter(child);
    }

    canvas.drawPath(backgroundFillPath, _buttonBackgroundPaint);
    canvas.drawPath(pressedBackgroundFillPath, _pressedButtonBackgroundPaint);
    canvas.drawPath(dividersPath, _dividerPaint);
  }

  void _drawButtons(PaintingContext context, Offset offset) {
    RenderBox? child = firstChild;
    while (child != null) {
      final MultiChildLayoutParentData childParentData =
          child.parentData! as MultiChildLayoutParentData;
      context.paintChild(child, childParentData.offset + offset);
      child = childAfter(child);
    }
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    return defaultHitTestChildren(result, position: position);
  }
}
