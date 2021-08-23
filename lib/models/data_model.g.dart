// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EmptyDataModel _$EmptyDataModelFromJson(Map<String, dynamic> json) {
  return EmptyDataModel();
}

Map<String, dynamic> _$EmptyDataModelToJson(EmptyDataModel instance) =>
    <String, dynamic>{};

TokenModel _$TokenModelFromJson(Map<String, dynamic> json) {
  return TokenModel(
    idToken: json['idToken'] as String,
    userNonActivated: json['userNonActivated'] as bool,
    userNonCompleted: json['userNonCompleted'] as bool,
  );
}

Map<String, dynamic> _$TokenModelToJson(TokenModel instance) =>
    <String, dynamic>{
      'userNonActivated': instance.userNonActivated,
      'userNonCompleted': instance.userNonCompleted,
      'idToken': instance.idToken,
    };
