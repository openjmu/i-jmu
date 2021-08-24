///
/// [Author] Alex (https://github.com/AlexV525)
/// [Date] 2021/8/24 13:05
///
part of 'data_model.dart';

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

  final String id;
  final String typeId;
  final int picCount;
  final String picSource;
  final Object? quoteTarget;
  final Object? quoteLevel;
  final String? quoteTime;
  final String createUserId;
  final String? createUserCode;
  final String createTime;
  final Object? updateUserId;
  final String? updateUserCode;
  final String? updateTime;
  final Object? addLink;
  final String title;
  @JsonKey(fromJson: dBoolFromInt)
  final bool enableStatus;
  final Object? exhibitType;
  final String? exhibitStartDate;
  final String? putOffEndDate;
  @JsonKey(defaultValue: <BannerModel>[])
  final List<BannerModel> marqueePics;
  final String? marqueeTypeCode;
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

  final String id;
  final String marqueeId;
  final String picUrl;
  final String createUserId;
  final String createTime;
  final String color;
  final String title;
  final String? url;
  final String? picDesc;
  final String? urlName;
  final String? createUserCode;
  final String? updateUserId;
  final String? updateUserCode;
  final String? updateTime;
  final String? contentId;
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
