///
/// [Author] Alex (https://github.com/AlexV525)
/// [Date] 2021-08-27 21:06
///
part of 'data_model.dart';

@HiveType(typeId: BoxTypeIds.courseModel)
@JsonSerializable()
class CourseModel extends DataModel {
  const CourseModel({
    required this.name,
    required this.time,
    required this.day,
    required this.$allWeek,
    this.teacher,
    this.location,
    required this.classTogether,
    required this.isEleven,
  });

  factory CourseModel.fromJson(Map<String, dynamic> json) =>
      _$CourseModelFromJson(json);

  @HiveField(0)
  @JsonKey(name: 'couName', defaultValue: '(空)')
  final String name;
  @HiveField(1)
  @JsonKey(name: 'couTime', fromJson: _dTimeFromDynamic)
  final int time;
  @HiveField(2)
  @JsonKey(name: 'couDayTime', fromJson: _dDayFromDynamic)
  final int day;
  @HiveField(3)
  @JsonKey(name: 'allWeek')
  final String $allWeek;
  @HiveField(4)
  @JsonKey(name: 'couTeaName')
  final String? teacher;
  @HiveField(5)
  @JsonKey(name: 'couRom')
  final String? location;
  @HiveField(6)
  @JsonKey(name: 'comboClassName', fromJson: _dClassesFromDynamic)
  final List<String> classTogether;
  @HiveField(7)
  @JsonKey(name: 'three', fromJson: _dIsElevenFromString)
  final bool isEleven;

  Color get color => _dColorFromName(name);

  List<String> get weeks => _dWeeksFromString($allWeek);

  int? get startWeek => int.tryParse(weeks.first);

  int? get endWeek => int.tryParse(weeks.last);

  ClassOddEven get oddEven => _dOddEvenFromString($allWeek);

  String get weekDurationString {
    String _s = '$startWeek-$endWeek';
    switch (oddEven) {
      case ClassOddEven.odd:
        _s += '单';
        break;
      case ClassOddEven.even:
        _s += '双';
        break;
      default:
        break;
    }
    return '$_s周';
  }

  String get timeString {
    String _content = '';
    if (time > 8) {
      _content += '晚上';
    } else if (time > 4) {
      _content += '下午';
    } else {
      _content += '上午';
    }
    _content += _getCourseStartTime(time);
    _content += ' - ';
    _content += _getCourseEndTime(time + 1);
    return _content;
  }

  /// 是否准备上课
  bool get inReadyTime {
    final double timeNow = _timeToDouble(TimeOfDay.now());
    final List<TimeOfDay> times = _coursesTime[time]!;
    final double start = _timeToDouble(times[0]);
    return start - timeNow <= 0.5 && start - timeNow > 0;
  }

  /// 是否正在上课
  bool get inCurrentTime {
    final double timeNow = _timeToDouble(TimeOfDay.now()) - (1 / 60);
    final double start = _timeToDouble(_coursesTime[time]![0]);
    double end = _timeToDouble(_coursesTime[time + 1]![1]) - (1 / 60);
    if (isEleven) {
      end = _timeToDouble(_coursesTime[11]![1]);
    }
    return start <= timeNow && end >= timeNow;
  }

  /// 是否已经下课
  bool get isOver {
    final TimeOfDay overTime = _coursesTime[time + 1]![1];
    return TimeOfDay.now().isAfter(overTime);
  }

  /// 是否为当日课程
  bool inCurrentDay([int? weekday]) => day == (weekday ?? currentTime.weekday);

  /// 课程是否属于当前周
  ///
  /// 自定义课程一定为当前周，因为其没有周数限制。
  bool inCurrentWeek([int? currentWeek]) {
    final DateProvider provider = DateProvider();
    final int week = currentWeek ?? provider.currentWeek;
    bool result = false;
    final bool inRange = week >= startWeek! && week <= endWeek!;
    final bool isOddEven = oddEven != ClassOddEven.all;
    if (isOddEven) {
      if (oddEven == ClassOddEven.odd) {
        result = inRange && week.isOdd;
      } else if (oddEven == ClassOddEven.even) {
        result = inRange && week.isEven;
      }
    } else {
      result = inRange;
    }
    return result;
  }

  static int _dTimeFromDynamic(Object? value) {
    switch (value.toString()) {
      case '1':
      case '2':
      case '12':
      case '23':
        return 1;
      case '3':
      case '4':
      case '34':
      case '45':
        return 3;
      case '5':
      case '6':
      case '56':
      case '67':
        return 5;
      case '7':
      case '8':
      case '78':
      case '89':
        return 7;
      case '90':
      case '911':
      case '9':
      case '10':
        return 9;
      case '11':
        return 11;
      default:
        return 0;
    }
  }

  static int _dDayFromDynamic(Object? value) {
    return int.parse(value.toString().substring(0, 1));
  }

  static List<String> _dWeeksFromString(String value) {
    return value.split(' ').first.split('-');
  }

  static List<String> _dClassesFromDynamic(Object? value) {
    return value?.toString().split(',') ?? <String>[];
  }

  static bool _dIsElevenFromString(String value) {
    return value == 'y';
  }

  static ClassOddEven _dOddEvenFromString(String value) {
    int _oddEven = 0;
    final List<String> _split = value.split(' ');
    if (_split.length > 1) {
      switch (_split[1]) {
        case '单周':
          _oddEven = 1;
          break;
        case '双周':
          _oddEven = 2;
          break;
      }
    }
    return ClassOddEven.values[_oddEven];
  }

  static Color _dColorFromName(String name) {
    final CourseColor? _courseColor = _uniqueCourseColors.firstWhereOrNull(
      (CourseColor c) => c.name == name,
    );
    if (_courseColor != null) {
      return _courseColor.color;
    }
    final Color newColor = randomCourseColor();
    final List<CourseColor> courses = _uniqueCourseColors
        .where((CourseColor c) => c.color == newColor)
        .toList();

    if (courses.isEmpty) {
      _uniqueCourseColors.add(CourseColor(name: name, color: newColor));
      return newColor;
    }
    return _dColorFromName(name);
  }

  @override
  List<Object?> get props => <Object?>[
        name,
        time,
        day,
        weeks,
        teacher,
        location,
        classTogether,
        isEleven,
        oddEven,
        color,
      ];

  @override
  Map<String, dynamic> toJson() => _$CourseModelToJson(this);
}

enum ClassOddEven { all, odd, even }

class CourseColor with EquatableMixin {
  const CourseColor({required this.name, required this.color});

  final String name;
  final Color color;

  @override
  List<Object> get props => <Object>[name, color];
}

final Set<CourseColor> _uniqueCourseColors = <CourseColor>{};

String _getCourseStartTime(int courseIndex) {
  return _getCourseTimeString(_coursesTime[courseIndex]![0]);
}

String _getCourseEndTime(int courseIndex) {
  return _getCourseTimeString(_coursesTime[courseIndex]![1]);
}

String _getCourseTimeString(TimeOfDay time) {
  final String hour = time.hour.toString();
  final String minute = '${time.minute < 10 ? '0' : ''}${time.minute}';
  return '$hour:$minute';
}

double _timeToDouble(TimeOfDay time) => time.hour + time.minute / 60.0;

TimeOfDay _time(int hour, int minute) => TimeOfDay(hour: hour, minute: minute);

Map<int, List<TimeOfDay>> _coursesTime = <int, List<TimeOfDay>>{
  1: <TimeOfDay>[_time(08, 00), _time(08, 45)],
  2: <TimeOfDay>[_time(08, 50), _time(09, 35)],
  3: <TimeOfDay>[_time(10, 05), _time(10, 50)],
  4: <TimeOfDay>[_time(10, 55), _time(11, 40)],
  5: <TimeOfDay>[_time(14, 00), _time(14, 45)],
  6: <TimeOfDay>[_time(14, 50), _time(15, 35)],
  7: <TimeOfDay>[_time(15, 55), _time(16, 40)],
  8: <TimeOfDay>[_time(16, 45), _time(17, 30)],
  9: <TimeOfDay>[_time(19, 00), _time(19, 45)],
  10: <TimeOfDay>[_time(19, 50), _time(20, 35)],
  11: <TimeOfDay>[_time(20, 40), _time(21, 25)],
  12: <TimeOfDay>[_time(21, 30), _time(22, 15)],
};

Map<String, String> _coursesTimeChinese = <String, String>{
  '1': '一二节',
  '12': '一二节',
  '3': '三四节',
  '34': '三四节',
  '5': '五六节',
  '56': '五六节',
  '7': '七八节',
  '78': '七八节',
  '9': '九十节',
  '90': '九十节',
  '11': '十一节',
  '911': '九十十一节',
};

const List<Color> _courseColorsList = <Color>[
  Color(0xffEF9A9A),
  Color(0xffF48FB1),
  Color(0xffCE93D8),
  Color(0xffB39DDB),
  Color(0xff9FA8DA),
  Color(0xff90CAF9),
  Color(0xff81D4FA),
  Color(0xff80DEEA),
  Color(0xff80CBC4),
  Color(0xffA5D6A7),
  Color(0xffC5E1A5),
  Color(0xffE6EE9C),
  Color(0xffFFF59D),
  Color(0xffFFE082),
  Color(0xffFFCC80),
  Color(0xffFFAB91),
  Color(0xffBCAAA4),
  Color(0xffd8b5df),
  Color(0xff68c0ca),
  Color(0xff05bac3),
  Color(0xffe98b81),
  Color(0xffd86f5c),
  Color(0xfffed68e),
  Color(0xfff8b475),
  Color(0xffc16594),
  Color(0xffaccbd0),
  Color(0xffe6e5d1),
  Color(0xffe5f3a6),
  Color(0xfff6af9f),
  Color(0xfffb5320),
  Color(0xff20b1fb),
  Color(0xff3275a9),
];

Color randomCourseColor() =>
    _courseColorsList[next(0, _courseColorsList.length)];
