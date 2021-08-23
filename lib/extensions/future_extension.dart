///
/// [Author] Alex (https://github.com/AlexV525)
/// [Date] 2021/7/7 10:24
///
extension FutureExtension<T> on Future<T> {
  Future<T> atLeast(Duration duration) async {
    final List<dynamic> _futures = await Future.wait<dynamic>(
      <Future<dynamic>>[this, Future<void>.delayed(duration)],
    );
    return _futures.first as T;
  }

  Future<List<T>> plus(Future<T> b, {bool eagerError = false}) {
    return Future.wait(<Future<T>>[this, b], eagerError: eagerError);
  }
}
