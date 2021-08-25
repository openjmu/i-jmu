///
/// [Author] Alex (https://github.com/AlexV525)
/// [Date] 2021/4/22 13:33
///
extension IterableExtension on Iterable<dynamic> {}

extension NullableIterableExtension on Iterable<dynamic>? {
  bool get isNullOrEmpty => this == null || this!.isEmpty;

  bool get isNotNullOrEmpty => this != null && this!.isNotEmpty;
}

extension MapExtension on Map<dynamic, dynamic> {
  void removeAllEmptyEntry() => removeWhere(
        (dynamic k, dynamic v) =>
            k == null || v == null || v == '' || v == 'null',
      );
}
