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

SystemConfigModel _$SystemConfigModelFromJson(Map<String, dynamic> json) {
  return SystemConfigModel(
    protocol: json['protocol'] as String? ?? '',
    schoolName: json['schoolName'] as String,
    favIcon: json['favIcon'] as String?,
    descIcon: json['descIcon'] as String?,
    introduction: json['introduction'] as String? ?? '',
    whiteIcon: json['whiteIcon'] as String?,
    enabled: json['enabled'] as bool? ?? false,
    appTopLog: json['appTopLog'] as String? ?? '',
    appAboutLog: json['appAboutLog'] as String? ?? '',
    appTaskLog: json['appTaskLog'] as String? ?? '',
    privacy: json['privacy'] as String? ?? '',
    eCardSets: (json['eCardSets'] as List<dynamic>?)
            ?.map((e) => SystemConfigECard.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [],
  );
}

Map<String, dynamic> _$SystemConfigModelToJson(SystemConfigModel instance) =>
    <String, dynamic>{
      'protocol': instance.protocol,
      'schoolName': instance.schoolName,
      'favIcon': instance.favIcon,
      'descIcon': instance.descIcon,
      'introduction': instance.introduction,
      'whiteIcon': instance.whiteIcon,
      'enabled': instance.enabled,
      'appTopLog': instance.appTopLog,
      'appAboutLog': instance.appAboutLog,
      'appTaskLog': instance.appTaskLog,
      'privacy': instance.privacy,
      'eCardSets': instance.eCardSets,
    };

SystemConfigECard _$SystemConfigECardFromJson(Map<String, dynamic> json) {
  return SystemConfigECard(
    imageUrl: json['imageUrl'] as String,
    name: json['name'] as String,
    isScan: json['scan'] as bool? ?? false,
    requestUrl: json['reqUrl'] as String? ?? '',
    html: json['html'] as bool? ?? true,
    smallImage: json['smallImage'] as String,
  );
}

Map<String, dynamic> _$SystemConfigECardToJson(SystemConfigECard instance) =>
    <String, dynamic>{
      'imageUrl': instance.imageUrl,
      'name': instance.name,
      'scan': instance.isScan,
      'reqUrl': instance.requestUrl,
      'html': instance.html,
      'smallImage': instance.smallImage,
    };

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
