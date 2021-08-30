///
/// [Author] Alex (https://github.com/AlexV525)
/// [Date] 11/26/20 4:31 PM
///
import 'dart:math' as math;

import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

import '../constants/constants.dart';
import '../extensions/date_time_extension.dart';
import '../extensions/object_extension.dart';
import '../internal/boxes.dart';
import '../internal/manager.dart';
import '../providers/providers.dart';
import '../utils/log_util.dart';

part 'banner_config_model.dart';

part 'course_model.dart';

part 'data_model.d.dart';

part 'data_model.g.dart';

part 'search_result.dart';

part 'service_model.dart';

part 'static_handler.dart';

part 'system_config_model.dart';

part 'token_model.dart';

abstract class DataModel extends Equatable {
  const DataModel();

  Map<String, dynamic> toJson();

  @override
  String toString() => GlobalJsonEncoder.convert(toJson());
}

typedef DataFactory<T extends DataModel> = T Function(
  Map<String, dynamic> json,
);

T makeModel<T extends DataModel>(Map<String, dynamic> json) {
  if (!dataModelFactories.containsKey(T)) {
    LogUtil.w(
      'You are inflecting an unregistered DataModel type: $T.\n'
      'Please check whether the type is registered in `dataModelFactories`.',
    );
    throw TypeError();
  }
  try {
    return dataModelFactories[T]!(json) as T;
  } catch (e) {
    LogUtil.e(
      'Error when making model with $T type: $e\n'
      '${json.containsKey('id') ? 'Model contains id: ${json['id']}\n' : ''}'
      'The raw data which make this error is:\n'
      '${GlobalJsonEncoder.convert(json)}',
      stackTrace: e.nullableStackTrace,
    );
    rethrow;
  }
}

@JsonSerializable()
class EmptyDataModel extends DataModel {
  const EmptyDataModel();

  factory EmptyDataModel.fromJson(Map<String, dynamic> json) =>
      _$EmptyDataModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$EmptyDataModelToJson(this);

  @override
  List<Object?> get props => <Object?>[null];
}

final math.Random _random = math.Random();

int next(int min, int max) => min + _random.nextInt(max - min);
