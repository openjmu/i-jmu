///
/// [Author] Alex (https://github.com/AlexV525)
/// [Date] 2021/8/30 11:31
///
part of 'providers.dart';

class CoursesProvider extends ChangeNotifier {
  factory CoursesProvider() => _instance;

  CoursesProvider._();

  static late final CoursesProvider _instance = CoursesProvider._();

  Box<LabsCourseModel> get _courseBox => Boxes.coursesBox;

  final int maxCoursesPerDay = 12;

  /// {
  ///   1: {1: [a, b], 3: [c, d, e, f]...},
  ///   2: {1: [g, h, i], 3: [j, k]...},
  ///   ...
  /// }
  Map<int, Map<int, List<LabsCourseModel>>> get courses => _courses;
  late Map<int, Map<int, List<LabsCourseModel>>> _courses;

  set courses(Map<int, Map<int, List<LabsCourseModel>>> value) {
    _courses = <int, Map<int, List<LabsCourseModel>>>{...value};
    _courses = Map<int, Map<int, List<LabsCourseModel>>>.from(courses);
    final Iterable<LabsCourseModel> _courseList = _courses.values.expand(
      (Map<int, List<LabsCourseModel>> pair) => pair.values.expand(
        (List<LabsCourseModel> list) => list,
      ),
    );
    _courseBox
      ..clear()
      ..addAll(_courseList);
    notifyListeners();
  }

  String? get remark => _remark;
  String? _remark;

  set remark(String? value) {
    _remark = value;
    if (value == null) {
      Boxes.containerBox.delete(BoxFields.nCourseRemark);
    } else {
      Boxes.containerBox.put(BoxFields.nCourseRemark, value);
    }
    notifyListeners();
  }

  /// 获取今日的课程
  List<LabsCourseModel> get coursesToday {
    if (_courses == null) {
      return <LabsCourseModel>[];
    }
    final Iterable<LabsCourseModel> _cs =
        _courses[currentTime.weekday]!.values.expand(
              (List<LabsCourseModel> list) => list,
            );
    return _cs
        .where((LabsCourseModel c) => c.inCurrentDay() && c.inCurrentWeek())
        .toList();
  }

  /// 获取明日的课程
  List<LabsCourseModel> get coursesTomorrow {
    if (_courses == null) {
      return <LabsCourseModel>[];
    }
    final DateTime tomorrow = currentTime.add(const Duration(days: 1));
    int? currentWeek;
    if (tomorrow.weekday == 1) {
      currentWeek = DateProvider().currentWeek + 1;
    }
    final Iterable<LabsCourseModel> _cs = _courses[tomorrow.weekday]!.values.expand(
          (List<LabsCourseModel> list) => list,
        );
    return _cs
        .where((LabsCourseModel c) =>
            c.inCurrentDay(tomorrow.weekday) && c.inCurrentWeek(currentWeek))
        .toList();
  }

  bool get firstLoaded => _firstLoaded;
  bool _firstLoaded = false;

  set firstLoaded(bool value) {
    _firstLoaded = value;
    notifyListeners();
  }

  bool get hasCourses => _hasCourses;
  bool _hasCourses = false;

  set hasCourses(bool value) {
    _hasCourses = value;
    notifyListeners();
  }

  bool get showError => _showError;
  bool _showError = false;

  set showError(bool value) {
    _showError = value;
    notifyListeners();
  }

  /// 当前的错误是否为外网访问
  bool get isOuterError => _isOuterError;
  bool _isOuterError = false;

  set isOuterError(bool value) {
    if (value == _isOuterError) {
      return;
    }
    _isOuterError = value;
    notifyListeners();
  }

  void initCourses() {
    _courses = resetCourses();
    for (final LabsCourseModel course in _courseBox.values) {
      _courses[course.day]![course.time]!.add(course);
    }
    _hasCourses = _courses.values
        .expand<List<LabsCourseModel>>(
            (Map<int, List<LabsCourseModel>> map) => map.values)
        .expand<LabsCourseModel>((List<LabsCourseModel> list) => list)
        .isNotEmpty;
    _remark = Boxes.containerBox.get(BoxFields.nCourseRemark) as String?;
    if (_hasCourses) {
      firstLoaded = true;
    } else {
      _courses = resetCourses();
    }
    updateCourses();
  }

  void unloadCourses() {
    _courses.clear();
    _remark = null;
    _firstLoaded = false;
    _hasCourses = true;
    _showError = false;
  }

  Map<int, Map<int, List<LabsCourseModel>>> resetCourses() {
    final Map<int, Map<int, List<LabsCourseModel>>> courses =
        <int, Map<int, List<LabsCourseModel>>>{
      for (int i = 1; i < 7 + 1; i++)
        i: <int, List<LabsCourseModel>>{
          for (int i = 1; i < maxCoursesPerDay + 1; i++) i: <LabsCourseModel>[],
        },
    };
    return courses;
  }

  Future<void> updateCourses() async {
    final DateProvider dateProvider = DateProvider();
    try {
      final List<Map<String, dynamic>> responses = await Future.wait(
        <Future<Map<String, dynamic>>>[
          CourseAPI.getCourse(useVPN: HttpUtil.shouldUseWebVPN),
          CourseAPI.getRemark(useVPN: HttpUtil.shouldUseWebVPN),
        ],
      );
      final Map<String, dynamic> courseData = responses[0];
      if ((courseData['courses'] as List<dynamic>).isEmpty &&
          courseData['othCase'] == null) {
        LogUtil.w('Courses may return invalid value, retry...');
        updateCourses();
        return;
      }
      await Future.wait(
        <Future<void>>[
          courseResponseHandler(courseData),
          remarkResponseHandler(responses[1]),
        ],
      );
      if (!_firstLoaded) {
        if (dateProvider.currentWeek != 0) {
          _firstLoaded = true;
        }
      }
      if (_showError) {
        _showError = false;
      }
      notifyListeners();
    } catch (e) {
      _showError = !_hasCourses; // 有课则不显示错误
      if (e is FormatException) {
        LogUtil.d('Displaying courses from cache...');
        _isOuterError = true;
      } else {
        LogUtil.e('Error when updating course: $e');
        _isOuterError = false;
      }
      if (!firstLoaded && dateProvider.currentWeek != 0) {
        _firstLoaded = true;
      }
      notifyListeners();
    }
  }

  Future<void> courseResponseHandler(Map<String, dynamic> data) async {
    final List<dynamic> _courseList = data['courses'] as List<dynamic>;
    final Map<int, Map<int, List<LabsCourseModel>>> _s = resetCourses();
    _hasCourses = _courseList.isNotEmpty;
    for (final dynamic course in _courseList) {
      final LabsCourseModel _c = LabsCourseModel.fromJson(
        course as Map<String, dynamic>,
      );
      addCourse(_c, _s);
    }
    courses = _s;
  }

  Future<void> remarkResponseHandler(Map<String, dynamic> data) async {
    final String? _r = data['classScheduleRemark'] as String?;
    if (_r.isNotNullOrEmpty) {
      _remark = _r;
      await Boxes.containerBox.put(BoxFields.nCourseRemark, _r);
    }
  }

  void addCourse(
    LabsCourseModel course,
    Map<int, Map<int, List<LabsCourseModel>>> courses,
  ) {
    final int courseDay = course.day;
    final int courseTime = course.time.toInt();
    try {
      if (!courses.containsKey(courseDay)) {
        courses[courseDay] = <int, List<LabsCourseModel>>{};
      }
      if (!courses[courseDay]!.containsKey(courseTime)) {
        courses[courseDay]![courseTime] = <LabsCourseModel>[];
      }
      courses[courseDay]![courseTime]!.add(course);
    } catch (e) {
      LogUtil.e(
        'Failed when trying to add course at '
        'day($courseDay) time($courseTime): $e',
        stackTrace: e.nullableStackTrace,
      );
    }
  }
}
