///
/// [Author] Alex (https://github.com/AlexV525)
/// [Date] 2021/8/24 13:45
///
part of 'data_model.dart';

@HiveType(typeId: BoxTypeIds.serviceModel)
@JsonSerializable()
class ServiceModel extends DataModel {
  const ServiceModel({
    required this.id,
    this.ownerApplication,
    required this.serviceName,
    required this.servicePicUrl,
    this.serviceProfile,
    required this.status,
    required this.createTime,
    this.updateTime,
    required this.serviceDesc,
    required this.servicePinYin,
    this.collectNum,
    required this.serviceNo,
    this.contactInformation,
    required this.serviceSource,
    required this.serviceType,
    required this.clickNum,
    required this.createUserCode,
    this.updateUserCode,
    required this.serviceDepartmentCode,
    required this.haveGuide,
    this.flowId,
    required this.sortNum,
    required this.publicAccess,
    required this.recommend,
    required this.recommendMonths,
    required this.serviceDepartmentName,
    this.checkUrl,
    this.formId,
    this.printId,
    this.yyId,
    required this.forceRecommend,
    required this.sourceType,
    this.unlineHand,
    this.runTime,
    required this.serviceUrl,
    required this.iconUrl,
    this.terminalName,
    this.tokenAccept,
    required this.techType,
    required this.labelNames,
    required this.collect,
    this.terminals,
    this.labelId,
    this.releaseTime,
    this.needLocalNetWork,
    this.serviceCas,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) =>
      _$ServiceModelFromJson(json);

  @HiveField(0)
  final String id;
  @HiveField(1)
  final String? ownerApplication;
  @HiveField(2)
  final String serviceName;
  @HiveField(3)
  final String servicePicUrl;
  @HiveField(4)
  final Object? serviceProfile;
  @HiveField(5)
  final String status;
  @HiveField(6)
  final String createTime;
  @HiveField(7)
  final String? updateTime;
  @HiveField(8)
  final String serviceDesc;
  @HiveField(9)
  final String servicePinYin;
  @HiveField(10)
  final int? collectNum;
  @HiveField(11)
  final String serviceNo;
  @HiveField(12)
  final String? contactInformation;
  @HiveField(13)
  final String serviceSource;
  @HiveField(14)
  final String serviceType;
  @HiveField(15)
  @JsonKey(defaultValue: 0)
  final int clickNum;
  @HiveField(16)
  final String createUserCode;
  @HiveField(17)
  final String? updateUserCode;
  @HiveField(18)
  final String serviceDepartmentCode;
  @HiveField(19)
  @JsonKey(fromJson: dBoolFromString)
  final bool haveGuide;
  @HiveField(20)
  final Object? flowId;
  @HiveField(21)
  @JsonKey(defaultValue: 0)
  final double sortNum;
  @HiveField(22)
  @JsonKey(fromJson: dBoolFromString)
  final bool publicAccess;
  @HiveField(23)
  @JsonKey(fromJson: dBoolFromString)
  final bool recommend;
  @HiveField(24)
  @JsonKey(fromJson: dListFromString)
  final List<String> recommendMonths;
  @HiveField(25)
  final String serviceDepartmentName;
  @HiveField(26)
  final String? checkUrl;
  @HiveField(27)
  final Object? formId;
  @HiveField(28)
  final Object? printId;
  @HiveField(29)
  final Object? yyId;
  @HiveField(30)
  final bool forceRecommend;
  @HiveField(31)
  final String sourceType;
  @HiveField(32)
  final Object? unlineHand;
  @HiveField(33)
  final String? runTime;
  @HiveField(34)
  final String serviceUrl;
  @HiveField(35)
  final String iconUrl;
  @HiveField(36)
  final String? terminalName;
  @HiveField(37)
  final String? tokenAccept;
  @HiveField(38)
  final String techType;
  @HiveField(39)
  @JsonKey(defaultValue: <String>[])
  final List<String> labelNames;
  @HiveField(40)
  @JsonKey(fromJson: dBoolFromString)
  final bool collect;
  @HiveField(41)
  final Object? terminals;
  @HiveField(42)
  final Object? labelId;
  @HiveField(43)
  final String? releaseTime;
  @HiveField(44)
  final Object? needLocalNetWork;
  @HiveField(45)
  final Object? serviceCas;

  @override
  Map<String, dynamic> toJson() => _$ServiceModelToJson(this);

  @override
  List<Object?> get props => <Object?>[
        id,
        ownerApplication,
        serviceName,
        servicePicUrl,
        status,
        createTime,
        updateTime,
        serviceDesc,
        servicePinYin,
        collectNum,
        serviceNo,
        contactInformation,
        serviceSource,
        serviceType,
        clickNum,
        createUserCode,
        updateUserCode,
        serviceDepartmentCode,
        haveGuide,
        flowId,
        publicAccess,
        recommend,
        recommendMonths,
        serviceDepartmentName,
        forceRecommend,
        techType,
        labelNames,
        collect,
        releaseTime,
      ];
}
