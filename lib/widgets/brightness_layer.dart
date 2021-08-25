///
/// [Author] Alex (https://github.com/AlexV525)
/// [Date] 12/15/20 3:38 PM
///
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BrightnessLayer extends StatelessWidget {
  const BrightnessLayer({
    Key? key,
    required this.brightness,
    required this.child,
    this.forceTransparentNavigationBar = true,
  }) : super(key: key);

  final Brightness? brightness;
  final Widget child;
  final bool forceTransparentNavigationBar;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: (brightness == Brightness.dark
              ? SystemUiOverlayStyle.dark
              : SystemUiOverlayStyle.light)
          .copyWith(
        systemNavigationBarColor:
            forceTransparentNavigationBar ? Colors.transparent : null,
      ),
      child: child,
    );
  }
}
