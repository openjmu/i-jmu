// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BannerConfigAdapter extends TypeAdapter<BannerConfig> {
  @override
  final int typeId = 2;

  @override
  BannerConfig read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BannerConfig(
      id: fields[0] as String,
      typeId: fields[1] as String,
      picCount: fields[2] as int,
      picSource: fields[3] as String,
      quoteTarget: fields[4] as Object?,
      quoteLevel: fields[5] as Object?,
      quoteTime: fields[6] as String?,
      createUserId: fields[7] as String,
      createUserCode: fields[8] as String?,
      createTime: fields[9] as String,
      updateUserId: fields[10] as Object?,
      updateUserCode: fields[11] as String?,
      updateTime: fields[12] as String?,
      addLink: fields[13] as Object?,
      title: fields[14] as String,
      enableStatus: fields[15] as bool,
      exhibitType: fields[16] as Object?,
      exhibitStartDate: fields[17] as String?,
      putOffEndDate: fields[18] as String?,
      marqueePics: (fields[19] as List).cast<BannerModel>(),
      marqueeTypeCode: fields[20] as String?,
      marqueeTypeName: fields[21] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, BannerConfig obj) {
    writer
      ..writeByte(22)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.typeId)
      ..writeByte(2)
      ..write(obj.picCount)
      ..writeByte(3)
      ..write(obj.picSource)
      ..writeByte(4)
      ..write(obj.quoteTarget)
      ..writeByte(5)
      ..write(obj.quoteLevel)
      ..writeByte(6)
      ..write(obj.quoteTime)
      ..writeByte(7)
      ..write(obj.createUserId)
      ..writeByte(8)
      ..write(obj.createUserCode)
      ..writeByte(9)
      ..write(obj.createTime)
      ..writeByte(10)
      ..write(obj.updateUserId)
      ..writeByte(11)
      ..write(obj.updateUserCode)
      ..writeByte(12)
      ..write(obj.updateTime)
      ..writeByte(13)
      ..write(obj.addLink)
      ..writeByte(14)
      ..write(obj.title)
      ..writeByte(15)
      ..write(obj.enableStatus)
      ..writeByte(16)
      ..write(obj.exhibitType)
      ..writeByte(17)
      ..write(obj.exhibitStartDate)
      ..writeByte(18)
      ..write(obj.putOffEndDate)
      ..writeByte(19)
      ..write(obj.marqueePics)
      ..writeByte(20)
      ..write(obj.marqueeTypeCode)
      ..writeByte(21)
      ..write(obj.marqueeTypeName);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BannerConfigAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class BannerModelAdapter extends TypeAdapter<BannerModel> {
  @override
  final int typeId = 3;

  @override
  BannerModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BannerModel(
      id: fields[0] as String,
      marqueeId: fields[1] as String,
      url: fields[7] as String?,
      picDesc: fields[8] as String?,
      urlName: fields[9] as String?,
      picUrl: fields[2] as String,
      createUserId: fields[3] as String,
      createUserCode: fields[10] as String?,
      createTime: fields[4] as String,
      updateUserId: fields[11] as String?,
      updateUserCode: fields[12] as String?,
      updateTime: fields[13] as String?,
      color: fields[5] as String,
      title: fields[6] as String,
      contentId: fields[14] as String?,
      sort: fields[15] as Object?,
    );
  }

  @override
  void write(BinaryWriter writer, BannerModel obj) {
    writer
      ..writeByte(16)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.marqueeId)
      ..writeByte(2)
      ..write(obj.picUrl)
      ..writeByte(3)
      ..write(obj.createUserId)
      ..writeByte(4)
      ..write(obj.createTime)
      ..writeByte(5)
      ..write(obj.color)
      ..writeByte(6)
      ..write(obj.title)
      ..writeByte(7)
      ..write(obj.url)
      ..writeByte(8)
      ..write(obj.picDesc)
      ..writeByte(9)
      ..write(obj.urlName)
      ..writeByte(10)
      ..write(obj.createUserCode)
      ..writeByte(11)
      ..write(obj.updateUserId)
      ..writeByte(12)
      ..write(obj.updateUserCode)
      ..writeByte(13)
      ..write(obj.updateTime)
      ..writeByte(14)
      ..write(obj.contentId)
      ..writeByte(15)
      ..write(obj.sort);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BannerModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CourseModelAdapter extends TypeAdapter<CourseModel> {
  @override
  final int typeId = 5;

  @override
  CourseModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CourseModel(
      name: fields[0] as String,
      time: fields[1] as String,
      day: fields[2] as int,
      $allWeek: fields[3] as String,
      teacher: fields[4] as String?,
      location: fields[5] as String?,
      classTogether: (fields[6] as List).cast<String>(),
      isEleven: fields[7] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, CourseModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.time)
      ..writeByte(2)
      ..write(obj.day)
      ..writeByte(3)
      ..write(obj.$allWeek)
      ..writeByte(4)
      ..write(obj.teacher)
      ..writeByte(5)
      ..write(obj.location)
      ..writeByte(6)
      ..write(obj.classTogether)
      ..writeByte(7)
      ..write(obj.isEleven);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CourseModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ServiceModelAdapter extends TypeAdapter<ServiceModel> {
  @override
  final int typeId = 4;

  @override
  ServiceModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ServiceModel(
      id: fields[0] as String,
      ownerApplication: fields[1] as String?,
      serviceName: fields[2] as String,
      servicePicUrl: fields[3] as String,
      serviceProfile: fields[4] as Object?,
      status: fields[5] as String,
      createTime: fields[6] as String,
      updateTime: fields[7] as String?,
      serviceDesc: fields[8] as String,
      servicePinYin: fields[9] as String,
      collectNum: fields[10] as int?,
      serviceNo: fields[11] as String,
      contactInformation: fields[12] as String?,
      serviceSource: fields[13] as String,
      serviceType: fields[14] as String,
      clickNum: fields[15] as int,
      createUserCode: fields[16] as String,
      updateUserCode: fields[17] as String?,
      serviceDepartmentCode: fields[18] as String,
      haveGuide: fields[19] as bool,
      flowId: fields[20] as Object?,
      sortNum: fields[21] as double,
      publicAccess: fields[22] as bool,
      recommend: fields[23] as bool,
      recommendMonths: (fields[24] as List).cast<String>(),
      serviceDepartmentName: fields[25] as String,
      checkUrl: fields[26] as String?,
      formId: fields[27] as Object?,
      printId: fields[28] as Object?,
      yyId: fields[29] as Object?,
      forceRecommend: fields[30] as bool,
      sourceType: fields[31] as String,
      unlineHand: fields[32] as Object?,
      runTime: fields[33] as String?,
      serviceUrl: fields[34] as String,
      iconUrl: fields[35] as String,
      terminalName: fields[36] as String?,
      tokenAccept: fields[37] as String?,
      techType: fields[38] as String,
      labelNames: (fields[39] as List).cast<String>(),
      collect: fields[40] as bool,
      terminals: fields[41] as Object?,
      labelId: fields[42] as Object?,
      releaseTime: fields[43] as String?,
      needLocalNetWork: fields[44] as Object?,
      serviceCas: fields[45] as Object?,
    );
  }

  @override
  void write(BinaryWriter writer, ServiceModel obj) {
    writer
      ..writeByte(46)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.ownerApplication)
      ..writeByte(2)
      ..write(obj.serviceName)
      ..writeByte(3)
      ..write(obj.servicePicUrl)
      ..writeByte(4)
      ..write(obj.serviceProfile)
      ..writeByte(5)
      ..write(obj.status)
      ..writeByte(6)
      ..write(obj.createTime)
      ..writeByte(7)
      ..write(obj.updateTime)
      ..writeByte(8)
      ..write(obj.serviceDesc)
      ..writeByte(9)
      ..write(obj.servicePinYin)
      ..writeByte(10)
      ..write(obj.collectNum)
      ..writeByte(11)
      ..write(obj.serviceNo)
      ..writeByte(12)
      ..write(obj.contactInformation)
      ..writeByte(13)
      ..write(obj.serviceSource)
      ..writeByte(14)
      ..write(obj.serviceType)
      ..writeByte(15)
      ..write(obj.clickNum)
      ..writeByte(16)
      ..write(obj.createUserCode)
      ..writeByte(17)
      ..write(obj.updateUserCode)
      ..writeByte(18)
      ..write(obj.serviceDepartmentCode)
      ..writeByte(19)
      ..write(obj.haveGuide)
      ..writeByte(20)
      ..write(obj.flowId)
      ..writeByte(21)
      ..write(obj.sortNum)
      ..writeByte(22)
      ..write(obj.publicAccess)
      ..writeByte(23)
      ..write(obj.recommend)
      ..writeByte(24)
      ..write(obj.recommendMonths)
      ..writeByte(25)
      ..write(obj.serviceDepartmentName)
      ..writeByte(26)
      ..write(obj.checkUrl)
      ..writeByte(27)
      ..write(obj.formId)
      ..writeByte(28)
      ..write(obj.printId)
      ..writeByte(29)
      ..write(obj.yyId)
      ..writeByte(30)
      ..write(obj.forceRecommend)
      ..writeByte(31)
      ..write(obj.sourceType)
      ..writeByte(32)
      ..write(obj.unlineHand)
      ..writeByte(33)
      ..write(obj.runTime)
      ..writeByte(34)
      ..write(obj.serviceUrl)
      ..writeByte(35)
      ..write(obj.iconUrl)
      ..writeByte(36)
      ..write(obj.terminalName)
      ..writeByte(37)
      ..write(obj.tokenAccept)
      ..writeByte(38)
      ..write(obj.techType)
      ..writeByte(39)
      ..write(obj.labelNames)
      ..writeByte(40)
      ..write(obj.collect)
      ..writeByte(41)
      ..write(obj.terminals)
      ..writeByte(42)
      ..write(obj.labelId)
      ..writeByte(43)
      ..write(obj.releaseTime)
      ..writeByte(44)
      ..write(obj.needLocalNetWork)
      ..writeByte(45)
      ..write(obj.serviceCas);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ServiceModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SystemConfigAdapter extends TypeAdapter<SystemConfig> {
  @override
  final int typeId = 0;

  @override
  SystemConfig read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SystemConfig(
      protocol: fields[0] as String,
      schoolName: fields[1] as String,
      favIcon: fields[2] as String?,
      descIcon: fields[3] as String?,
      introduction: fields[4] as String,
      whiteIcon: fields[5] as String?,
      enabled: fields[6] as bool,
      appTopLog: fields[7] as String,
      appAboutLog: fields[8] as String,
      appTaskLog: fields[9] as String,
      privacy: fields[10] as String,
      eCardSets: (fields[11] as List).cast<SystemConfigECard>(),
    );
  }

  @override
  void write(BinaryWriter writer, SystemConfig obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.protocol)
      ..writeByte(1)
      ..write(obj.schoolName)
      ..writeByte(2)
      ..write(obj.favIcon)
      ..writeByte(3)
      ..write(obj.descIcon)
      ..writeByte(4)
      ..write(obj.introduction)
      ..writeByte(5)
      ..write(obj.whiteIcon)
      ..writeByte(6)
      ..write(obj.enabled)
      ..writeByte(7)
      ..write(obj.appTopLog)
      ..writeByte(8)
      ..write(obj.appAboutLog)
      ..writeByte(9)
      ..write(obj.appTaskLog)
      ..writeByte(10)
      ..write(obj.privacy)
      ..writeByte(11)
      ..write(obj.eCardSets);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SystemConfigAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SystemConfigECardAdapter extends TypeAdapter<SystemConfigECard> {
  @override
  final int typeId = 1;

  @override
  SystemConfigECard read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SystemConfigECard(
      imageUrl: fields[0] as String,
      name: fields[1] as String,
      isScan: fields[2] as bool,
      html: fields[3] as bool,
      smallImage: fields[4] as String,
      requestUrl: fields[5] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, SystemConfigECard obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.imageUrl)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.isScan)
      ..writeByte(3)
      ..write(obj.html)
      ..writeByte(4)
      ..write(obj.smallImage)
      ..writeByte(5)
      ..write(obj.requestUrl);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SystemConfigECardAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

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

CourseModel _$CourseModelFromJson(Map<String, dynamic> json) {
  return CourseModel(
    name: json['couName'] as String? ?? '(空)',
    time: CourseModel._dTimeFromDynamic(json['couTime']),
    day: CourseModel._dDayFromDynamic(json['couDayTime']),
    $allWeek: json['allWeek'] as String,
    teacher: json['couTeaName'] as String?,
    location: json['couRom'] as String?,
    classTogether: CourseModel._dClassesFromDynamic(json['comboClassName']),
    isEleven: CourseModel._dIsElevenFromString(json['three'] as String),
  );
}

Map<String, dynamic> _$CourseModelToJson(CourseModel instance) =>
    <String, dynamic>{
      'couName': instance.name,
      'couTime': instance.time,
      'couDayTime': instance.day,
      'allWeek': instance.$allWeek,
      'couTeaName': instance.teacher,
      'couRom': instance.location,
      'comboClassName': instance.classTogether,
      'three': instance.isEleven,
    };

SearchResult _$SearchResultFromJson(Map<String, dynamic> json) {
  return SearchResult(
    total: json['totalHits'] as int? ?? 0,
    relationType: json['totalHitsRelation'] as String?,
    maxScore: dTryParseDouble(json['maxScore'] as Object),
    scrollId: json['scrollId'] as String?,
    items: (json['searchHits'] as List<dynamic>?)
            ?.map((e) => SearchResultItem.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [],
    aggregations: json['aggregations'],
    empty: json['empty'] as bool? ?? false,
  );
}

Map<String, dynamic> _$SearchResultToJson(SearchResult instance) =>
    <String, dynamic>{
      'totalHits': instance.total,
      'totalHitsRelation': instance.relationType,
      'maxScore': instance.maxScore,
      'scrollId': instance.scrollId,
      'searchHits': instance.items,
      'aggregations': instance.aggregations,
      'empty': instance.empty,
    };

SearchResultItem _$SearchResultItemFromJson(Map<String, dynamic> json) {
  return SearchResultItem(
    id: json['id'] as String,
    score: dTryParseDouble(json['score'] as Object),
    sortValues: json['sortValues'] as List<dynamic>,
    content: SearchResultItemContent.fromJson(
        json['content'] as Map<String, dynamic>),
    highlightFields: SearchResultItemHighlightFields.fromJson(
        json['highlightFields'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$SearchResultItemToJson(SearchResultItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'score': instance.score,
      'sortValues': instance.sortValues,
      'content': instance.content,
      'highlightFields': instance.highlightFields,
    };

SearchResultItemContent _$SearchResultItemContentFromJson(
    Map<String, dynamic> json) {
  return SearchResultItemContent(
    serviceType: json['serviceType'] as String,
    serveImageUrl: json['serveImageUrl'] as String,
    serveNum: json['serveNum'] as String,
    serveId: json['serveId'] as String,
    permission: (json['permission'] as List<dynamic>?)
            ?.map((e) => e as String)
            .toList() ??
        [],
    type: json['type'] as String,
    serveSource: json['serveSource'] as String,
    serveLabel: (json['serveLable'] as List<dynamic>?)
            ?.map((e) => e as String)
            .toList() ??
        [],
    serveName: json['serveName'] as String,
    serveUrl: json['serveUrl'] as String,
    hiddenClass: json['_class'] as String,
    startDate: json['startDate'] as int,
    serveTerminal: (json['serveTerminal'] as List<dynamic>?)
            ?.map((e) => e as String)
            .toList() ??
        [],
  );
}

Map<String, dynamic> _$SearchResultItemContentToJson(
        SearchResultItemContent instance) =>
    <String, dynamic>{
      'serviceType': instance.serviceType,
      'serveImageUrl': instance.serveImageUrl,
      'serveNum': instance.serveNum,
      'serveId': instance.serveId,
      'permission': instance.permission,
      'type': instance.type,
      'serveSource': instance.serveSource,
      'serveLable': instance.serveLabel,
      'serveName': instance.serveName,
      'serveUrl': instance.serveUrl,
      '_class': instance.hiddenClass,
      'startDate': instance.startDate,
      'serveTerminal': instance.serveTerminal,
    };

SearchResultItemHighlightFields _$SearchResultItemHighlightFieldsFromJson(
    Map<String, dynamic> json) {
  return SearchResultItemHighlightFields(
    serviceType: (json['serviceType'] as List<dynamic>?)
            ?.map((e) => e as String)
            .toList() ??
        [],
    serveName: (json['serveName'] as List<dynamic>?)
            ?.map((e) => e as String)
            .toList() ??
        [],
    serviceKeyword: (json['service.keyword'] as List<dynamic>?)
            ?.map((e) => e as String)
            .toList() ??
        [],
    permission: (json['permission'] as List<dynamic>?)
            ?.map((e) => e as String)
            .toList() ??
        [],
    serveTerminal: (json['serveTerminal'] as List<dynamic>?)
            ?.map((e) => e as String)
            .toList() ??
        [],
  );
}

Map<String, dynamic> _$SearchResultItemHighlightFieldsToJson(
        SearchResultItemHighlightFields instance) =>
    <String, dynamic>{
      'serviceType': instance.serviceType,
      'serveName': instance.serveName,
      'service.keyword': instance.serviceKeyword,
      'permission': instance.permission,
      'serveTerminal': instance.serveTerminal,
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
    sortNum: (json['sortNum'] as num?)?.toDouble() ?? 0,
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
    html: json['html'] as bool? ?? true,
    smallImage: json['smallImage'] as String,
    requestUrl: json['reqUrl'] as String?,
  );
}

Map<String, dynamic> _$SystemConfigECardToJson(SystemConfigECard instance) =>
    <String, dynamic>{
      'imageUrl': instance.imageUrl,
      'name': instance.name,
      'scan': instance.isScan,
      'html': instance.html,
      'smallImage': instance.smallImage,
      'reqUrl': instance.requestUrl,
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
