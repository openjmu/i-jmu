///
/// [Author] Alex (https://github.com/AlexV525)
/// [Date] 2021/8/24 13:45
///
part of 'data_model.dart';

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

  final String id;
  final String? ownerApplication;
  final String serviceName;
  final String servicePicUrl;
  final Object? serviceProfile;
  final String status;
  final String createTime;
  final String? updateTime;
  final String serviceDesc;
  final String servicePinYin;
  final int? collectNum;
  final String serviceNo;
  final String? contactInformation;
  final String serviceSource;
  final String serviceType;
  @JsonKey(defaultValue: 0)
  final int clickNum;
  final String createUserCode;
  final String? updateUserCode;
  final String serviceDepartmentCode;
  @JsonKey(fromJson: dBoolFromString)
  final bool haveGuide;
  final Object? flowId;
  @JsonKey(defaultValue: 0)
  final double sortNum;
  @JsonKey(fromJson: dBoolFromString)
  final bool publicAccess;
  @JsonKey(fromJson: dBoolFromString)
  final bool recommend;
  @JsonKey(fromJson: dListFromString)
  final List<String> recommendMonths;
  final String serviceDepartmentName;
  final String? checkUrl;
  final Object? formId;
  final Object? printId;
  final Object? yyId;
  final bool forceRecommend;
  final String sourceType;
  final Object? unlineHand;
  final String? runTime;
  final String serviceUrl;
  final String iconUrl;
  final String? terminalName;
  final String? tokenAccept;
  final String techType;
  @JsonKey(defaultValue: <String>[])
  final List<String> labelNames;
  @JsonKey(fromJson: dBoolFromString)
  final bool collect;
  final Object? terminals;
  final Object? labelId;
  final String? releaseTime;
  final Object? needLocalNetWork;
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
