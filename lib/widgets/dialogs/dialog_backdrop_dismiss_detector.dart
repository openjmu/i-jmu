///
/// [Author] Alex (https://github.com/AlexV525)
/// [Date] 12/7/20 5:14 PM
///
import 'package:flutter/widgets.dart';

class DialogBackdropDismissDetector extends StatelessWidget {
  const DialogBackdropDismissDetector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
          Navigator.of(context).maybePop();
        },
      ),
    );
  }
}
