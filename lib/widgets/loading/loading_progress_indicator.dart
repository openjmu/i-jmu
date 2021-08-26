///
/// [Author] Alex (https://github.com/AlexV525)
/// [Date] 2021-04-21 20:45
///
import 'package:flutter/material.dart';

class LoadingProgressIndicator extends StatelessWidget {
  const LoadingProgressIndicator({
    Key? key,
    this.width = 30,
    this.thickness = 4,
    this.value,
  }) : super(key: key);

  final double width;
  final double thickness;
  final double? value;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints.tightFor(width: width, height: thickness),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(999),
        child: LinearProgressIndicator(
          backgroundColor: Theme.of(context).dividerColor,
          valueColor: AlwaysStoppedAnimation<Color?>(
            Theme.of(context).textTheme.bodyText2?.color,
          ),
          minHeight: thickness,
          value: value,
        ),
      ),
    );
  }
}
