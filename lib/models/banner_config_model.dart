///
/// [Author] Alex (https://github.com/AlexV525)
/// [Date] 2021/8/24 13:05
///
part of 'data_model.dart';

@HiveType(typeId: BoxTypeIds.bannerConfig)
@JsonSerializable()
class BannerConfig extends DataModel {
  const BannerConfig({
    required this.id,
    required this.typeId,
    required this.picCount,
    required this.picSource,
    this.quoteTarget,
    this.quoteLevel,
    this.quoteTime,
    required this.createUserId,
    this.createUserCode,
    required this.createTime,
    this.updateUserId,
    this.updateUserCode,
    this.updateTime,
    this.addLink,
    required this.title,
    required this.enableStatus,
    this.exhibitType,
    this.exhibitStartDate,
    this.putOffEndDate,
    required this.marqueePics,
    this.marqueeTypeCode,
    this.marqueeTypeName,
  });

  factory BannerConfig.fromJson(Map<String, dynamic> json) =>
      _$BannerConfigFromJson(json);

  @HiveField(0)
  final String id;
  @HiveField(1)
  final String typeId;
  @HiveField(2)
  final int picCount;
  @HiveField(3)
  final String picSource;
  @HiveField(4)
  final Object? quoteTarget;
  @HiveField(5)
  final Object? quoteLevel;
  @HiveField(6)
  final String? quoteTime;
  @HiveField(7)
  final String createUserId;
  @HiveField(8)
  final String? createUserCode;
  @HiveField(9)
  final String createTime;
  @HiveField(10)
  final Object? updateUserId;
  @HiveField(11)
  final String? updateUserCode;
  @HiveField(12)
  final String? updateTime;
  @HiveField(13)
  final Object? addLink;
  @HiveField(14)
  final String title;
  @HiveField(15)
  @JsonKey(fromJson: dBoolFromInt)
  final bool enableStatus;
  @HiveField(16)
  final Object? exhibitType;
  @HiveField(17)
  final String? exhibitStartDate;
  @HiveField(18)
  final String? putOffEndDate;
  @HiveField(19)
  @JsonKey(defaultValue: <BannerModel>[])
  final List<BannerModel> marqueePics;
  @HiveField(20)
  final String? marqueeTypeCode;
  @HiveField(21)
  final String? marqueeTypeName;

  bool get hasContentToDisplay => picCount > 0 && enableStatus;

  @override
  List<Object?> get props => <Object?>[
        id,
        typeId,
        picCount,
        picSource,
        createUserId,
        createTime,
        title,
        enableStatus,
        marqueePics,
      ];

  @override
  Map<String, dynamic> toJson() => _$BannerConfigToJson(this);
}

@HiveType(typeId: BoxTypeIds.bannerModel)
@JsonSerializable()
class BannerModel extends DataModel {
  const BannerModel({
    required this.id,
    required this.marqueeId,
    this.url,
    this.picDesc,
    this.urlName,
    required this.picUrl,
    required this.createUserId,
    this.createUserCode,
    required this.createTime,
    this.updateUserId,
    this.updateUserCode,
    this.updateTime,
    required this.color,
    required this.title,
    this.contentId,
    this.sort,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) =>
      _$BannerModelFromJson(json);

  @HiveField(0)
  final String id;
  @HiveField(1)
  final String marqueeId;
  @HiveField(2)
  final String picUrl;
  @HiveField(3)
  final String createUserId;
  @HiveField(4)
  final String createTime;
  @HiveField(5)
  final String color;
  @HiveField(6)
  final String title;
  @HiveField(7)
  final String? url;
  @HiveField(8)
  final String? picDesc;
  @HiveField(9)
  final String? urlName;
  @HiveField(10)
  final String? createUserCode;
  @HiveField(11)
  final String? updateUserId;
  @HiveField(12)
  final String? updateUserCode;
  @HiveField(13)
  final String? updateTime;
  @HiveField(14)
  final String? contentId;
  @HiveField(15)
  final Object? sort;

  @override
  List<Object?> get props => <Object?>[
        id,
        marqueeId,
        picUrl,
        createUserId,
        createTime,
        color,
        title,
        url,
        picDesc,
        urlName,
        createUserCode,
        updateUserId,
        updateTime,
        contentId,
        sort,
      ];

  @override
  Map<String, dynamic> toJson() => _$BannerModelToJson(this);
}
