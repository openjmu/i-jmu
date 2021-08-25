///
/// [Author] Alex (https://github.com/AlexV525)
/// [Date] 2021/8/24 13:11
///
part of 'data_model.dart';

bool dBoolFromInt(int v) => v > 0;

bool dBoolFromString(String? v) =>
    v != null && v.trim().isNotEmpty && v.trim() != '0';

List<String> dListFromString(String? v, {String splitter = ','}) =>
    v?.split(splitter) ?? <String>[];

double dTryParseDouble(Object v) {
  if (v is double) {
    return v;
  }
  if (v == 'NaN') {
    return 0;
  }
  return double.tryParse(v.toString()) ?? 0;
}
