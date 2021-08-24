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

BannerConfig _$BannerConfigFromJson(Map<String, dynamic> json) {
  return BannerConfig(
    id: json['id'] as String,
    typeId: json['typeId'] as String,
    picCount: json['picCount'] as int,
    picSource: json['picSource'] as String,
    quoteTarget: json['quoteTarget'],
    quoteLevel: json['quoteLevel'],
    quoteTime: json['quoteTime'] as String?,
    createUserId: json['createUserId'] as String,
    createUserCode: json['createUserCode'] as String?,
    createTime: json['createTime'] as String,
    updateUserId: json['updateUserId'],
    updateUserCode: json['updateUserCode'] as String?,
    updateTime: json['updateTime'] as String?,
    addLink: json['addLink'],
    title: json['title'] as String,
    enableStatus: dBoolFromInt(json['enableStatus'] as int),
    exhibitType: json['exhibitType'],
    exhibitStartDate: json['exhibitStartDate'] as String?,
    putOffEndDate: json['putOffEndDate'] as String?,
    marqueePics: (json['marqueePics'] as List<dynamic>?)
            ?.map((e) => BannerModel.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [],
    marqueeTypeCode: json['marqueeTypeCode'] as String?,
    marqueeTypeName: json['marqueeTypeName'] as String?,
  );
}

Map<String, dynamic> _$BannerConfigToJson(BannerConfig instance) =>
    <String, dynamic>{
      'id': instance.id,
      'typeId': instance.typeId,
      'picCount': instance.picCount,
      'picSource': instance.picSource,
      'quoteTarget': instance.quoteTarget,
      'quoteLevel': instance.quoteLevel,
      'quoteTime': instance.quoteTime,
      'createUserId': instance.createUserId,
      'createUserCode': instance.createUserCode,
      'createTime': instance.createTime,
      'updateUserId': instance.updateUserId,
      'updateUserCode': instance.updateUserCode,
      'updateTime': instance.updateTime,
      'addLink': instance.addLink,
      'title': instance.title,
      'enableStatus': instance.enableStatus,
      'exhibitType': instance.exhibitType,
      'exhibitStartDate': instance.exhibitStartDate,
      'putOffEndDate': instance.putOffEndDate,
      'marqueePics': instance.marqueePics,
      'marqueeTypeCode': instance.marqueeTypeCode,
      'marqueeTypeName': instance.marqueeTypeName,
    };

BannerModel _$BannerModelFromJson(Map<String, dynamic> json) {
  return BannerModel(
    id: json['id'] as String,
    marqueeId: json['marqueeId'] as String,
    url: json['url'] as String?,
    picDesc: json['picDesc'] as String?,
    urlName: json['urlName'] as String?,
    picUrl: json['picUrl'] as String,
    createUserId: json['createUserId'] as String,
    createUserCode: json['createUserCode'] as String?,
    createTime: json['createTime'] as String,
    updateUserId: json['updateUserId'] as String?,
    updateUserCode: json['updateUserCode'] as String?,
    updateTime: json['updateTime'] as String?,
    color: json['color'] as String,
    title: json['title'] as String,
    contentId: json['contentId'] as String?,
    sort: json['sort'],
  );
}

Map<String, dynamic> _$BannerModelToJson(BannerModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'marqueeId': instance.marqueeId,
      'picUrl': instance.picUrl,
      'createUserId': instance.createUserId,
      'createTime': instance.createTime,
      'color': instance.color,
      'title': instance.title,
      'url': instance.url,
      'picDesc': instance.picDesc,
      'urlName': instance.urlName,
      'createUserCode': instance.createUserCode,
      'updateUserId': instance.updateUserId,
      'updateUserCode': instance.updateUserCode,
      'updateTime': instance.updateTime,
      'contentId': instance.contentId,
      'sort': instance.sort,
    };

ServiceModel _$ServiceModelFromJson(Map<String, dynamic> json) {
  return ServiceModel(
    id: json['id'] as String,
    ownerApplication: json['ownerApplication'] as String?,
    serviceName: json['serviceName'] as String,
    servicePicUrl: json['servicePicUrl'] as String,
    serviceProfile: json['serviceProfile'],
    status: json['status'] as String,
    createTime: json['createTime'] as String,
    updateTime: json['updateTime'] as String?,
    serviceDesc: json['serviceDesc'] as String,
    servicePinYin: json['servicePinYin'] as String,
    collectNum: json['collectNum'] as int?,
    serviceNo: json['serviceNo'] as String,
    contactInformation: json['contactInformation'] as String?,
    serviceSource: json['serviceSource'] as String,
    serviceType: json['serviceType'] as String,
    clickNum: json['clickNum'] as int? ?? 0,
    createUserCode: json['createUserCode'] as String,
    updateUserCode: json['updateUserCode'] as String?,
    serviceDepartmentCode: json['serviceDepartmentCode'] as String,
    haveGuide: dBoolFromString(json['haveGuide'] as String?),
    flowId: json['flowId'],
    sortNum: (json['sortNum'] as num? ?? 0).toDouble(),
    publicAccess: dBoolFromString(json['publicAccess'] as String?),
    recommend: dBoolFromString(json['recommend'] as String?),
    recommendMonths: dListFromString(json['recommendMonths'] as String?),
    serviceDepartmentName: json['serviceDepartmentName'] as String,
    checkUrl: json['checkUrl'] as String?,
    formId: json['formId'],
    printId: json['printId'],
    yyId: json['yyId'],
    forceRecommend: json['forceRecommend'] as bool,
    sourceType: json['sourceType'] as String,
    unlineHand: json['unlineHand'],
    runTime: json['runTime'] as String?,
    serviceUrl: json['serviceUrl'] as String,
    iconUrl: json['iconUrl'] as String,
    terminalName: json['terminalName'] as String?,
    tokenAccept: json['tokenAccept'] as String?,
    techType: json['techType'] as String,
    labelNames: (json['labelNames'] as List<dynamic>?)
            ?.map((e) => e as String)
            .toList() ??
        [],
    collect: dBoolFromString(json['collect'] as String?),
    terminals: json['terminals'],
    labelId: json['labelId'],
    releaseTime: json['releaseTime'] as String?,
    needLocalNetWork: json['needLocalNetWork'],
    serviceCas: json['serviceCas'],
  );
}

Map<String, dynamic> _$ServiceModelToJson(ServiceModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'ownerApplication': instance.ownerApplication,
      'serviceName': instance.serviceName,
      'servicePicUrl': instance.servicePicUrl,
      'serviceProfile': instance.serviceProfile,
      'status': instance.status,
      'createTime': instance.createTime,
      'updateTime': instance.updateTime,
      'serviceDesc': instance.serviceDesc,
      'servicePinYin': instance.servicePinYin,
      'collectNum': instance.collectNum,
      'serviceNo': instance.serviceNo,
      'contactInformation': instance.contactInformation,
      'serviceSource': instance.serviceSource,
      'serviceType': instance.serviceType,
      'clickNum': instance.clickNum,
      'createUserCode': instance.createUserCode,
      'updateUserCode': instance.updateUserCode,
      'serviceDepartmentCode': instance.serviceDepartmentCode,
      'haveGuide': instance.haveGuide,
      'flowId': instance.flowId,
      'sortNum': instance.sortNum,
      'publicAccess': instance.publicAccess,
      'recommend': instance.recommend,
      'recommendMonths': instance.recommendMonths,
      'serviceDepartmentName': instance.serviceDepartmentName,
      'checkUrl': instance.checkUrl,
      'formId': instance.formId,
      'printId': instance.printId,
      'yyId': instance.yyId,
      'forceRecommend': instance.forceRecommend,
      'sourceType': instance.sourceType,
      'unlineHand': instance.unlineHand,
      'runTime': instance.runTime,
      'serviceUrl': instance.serviceUrl,
      'iconUrl': instance.iconUrl,
      'terminalName': instance.terminalName,
      'tokenAccept': instance.tokenAccept,
      'techType': instance.techType,
      'labelNames': instance.labelNames,
      'collect': instance.collect,
      'terminals': instance.terminals,
      'labelId': instance.labelId,
      'releaseTime': instance.releaseTime,
      'needLocalNetWork': instance.needLocalNetWork,
      'serviceCas': instance.serviceCas,
    };

SystemConfig _$SystemConfigFromJson(Map<String, dynamic> json) {
  return SystemConfig(
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

Map<String, dynamic> _$SystemConfigToJson(SystemConfig instance) =>
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
    requestUrl: json['reqUrl'] as String?,
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
