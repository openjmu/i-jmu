///
/// [Author] Alex (https://github.com/AlexV525)
/// [Date] 2021/8/30 11:30
///
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../constants/constants.dart';
import '../extensions/date_time_extension.dart';
import '../extensions/object_extension.dart';
import '../extensions/string_extension.dart';
import '../internal/api.dart';
import '../internal/boxes.dart';
import '../internal/urls.dart';
import '../models/data_model.dart';
import '../utils/http_util.dart';
import '../utils/log_util.dart';

part 'courses_provider.dart';
part 'date_provider.dart';
