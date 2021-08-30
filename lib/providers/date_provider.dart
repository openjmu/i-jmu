///
/// [Author] Alex (https://github.com/AlexV525)
/// [Date] 2021/8/30 12:53
///
part of 'providers.dart';

class DateProvider extends ChangeNotifier {
  factory DateProvider() => _instance;

  DateProvider._() {
    initCurrentWeek();
  }

  static late final DateProvider _instance = DateProvider._();

  Timer? _fetchCurrentWeekTimer;

  DateTime? get startDate => _startDate;
  DateTime? _startDate;

  set startDate(DateTime? value) {
    _startDate = value;
    notifyListeners();
  }

  int get currentWeek => _currentWeek;
  int _currentWeek = 0;

  set currentWeek(int value) {
    _currentWeek = value;
    notifyListeners();
  }

  int get difference => _difference!;
  int? _difference;

  set difference(int value) {
    _difference = value;
    notifyListeners();
  }

  String get dateString {
    final DateTime now = currentTime;
    return '${now.mDddd}，第$_currentWeek周';
  }

  Future<void> initCurrentWeek() async {
    final DateTime? _dateInCache =
        Boxes.containerBox.get(BoxFields.nStartDate) as DateTime?;
    if (_dateInCache != null) {
      _startDate = _dateInCache;
      _handleCurrentWeek();
    }
    await getCurrentWeek();
  }

  Future<void> updateStartDate(DateTime date) async {
    _startDate = date;
    await Boxes.containerBox.put(BoxFields.nStartDate, date);
  }

  void _handleCurrentWeek() {
    final int _d = _startDate!.difference(currentTime).inDays;
    if (_difference != _d) {
      _difference = _d;
    }

    final int _w = -((difference - 1) / 7).floor();
    if (_currentWeek != _w) {
      _currentWeek = _w;
      notifyListeners();
    }
  }

  Future<void> getCurrentWeek() async {
    try {
      DateTime? _day = Boxes.containerBox.get('startDate') as DateTime?;
      final Map<String, dynamic> data = await HttpUtil.fetch(
        FetchType.get,
        url: Urls.firstDayOfTerm,
      );
      final DateTime onlineDate = DateTime.parse(data['start'] as String);
      if (_day != onlineDate) {
        _day = onlineDate;
      }
      if (_startDate == null || _startDate != _day) {
        updateStartDate(_day!);
      }

      _handleCurrentWeek();
      _fetchCurrentWeekTimer?.cancel();
    } catch (e) {
      LogUtil.e('Failed when fetching current week: $e');
      startFetchCurrentWeekTimer();
    }
  }

  void startFetchCurrentWeekTimer() {
    _fetchCurrentWeekTimer?.cancel();
    _fetchCurrentWeekTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      getCurrentWeek();
    });
  }
}
