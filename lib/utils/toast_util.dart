///
/// [Author] Alex (https://github.com/AlexV525)
/// [Date] 12/18/20 1:30 PM
///
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart' as ok;

const Color _color = Color(0xff73706E);
const Color _failedColor = Colors.redAccent;

void showToast(String text) {
  ok.showToast(
    text,
    position: ok.ToastPosition.bottom,
    backgroundColor: _color,
    radius: 5,
  );
}

void showCenterToast(String text) {
  ok.showToast(
    text,
    position: ok.ToastPosition.center,
    backgroundColor: _color,
    radius: 5,
  );
}

void showErrorToast(String text) {
  ok.showToast(
    text,
    backgroundColor: _failedColor,
    radius: 5,
  );
}

void showCenterErrorToast(String text) {
  ok.showToast(
    text,
    position: ok.ToastPosition.center,
    backgroundColor: _failedColor,
    radius: 5,
  );
}

void showTopToast(String text) {
  ok.showToast(
    text,
    position: ok.ToastPosition.top,
    backgroundColor: _color,
    radius: 5,
  );
}

void dismissAllToast({bool showAnim = false}) {
  ok.dismissAllToast(showAnim: showAnim);
}
