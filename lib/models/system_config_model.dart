///
/// [Author] Alex (https://github.com/AlexV525)
/// [Date] 2021/8/23 18:17
///
part of 'data_model.dart';

@HiveType(typeId: BoxTypeIds.systemConfig)
@JsonSerializable()
class SystemConfig extends DataModel {
  const SystemConfig({
    required this.protocol,
    required this.schoolName,
    this.favIcon,
    this.descIcon,
    required this.introduction,
    this.whiteIcon,
    required this.enabled,
    required this.appTopLog,
    required this.appAboutLog,
    required this.appTaskLog,
    required this.privacy,
    required this.eCardSets,
  });

  factory SystemConfig.fromJson(Map<String, dynamic> json) =>
      _$SystemConfigFromJson(json);

  @HiveField(0)
  @JsonKey(defaultValue: '')
  final String protocol;
  @HiveField(1)
  final String schoolName;
  @HiveField(2)
  final String? favIcon;
  @HiveField(3)
  final String? descIcon;
  @HiveField(4)
  @JsonKey(defaultValue: '')
  final String introduction;
  @HiveField(5)
  final String? whiteIcon;
  @HiveField(6)
  @JsonKey(defaultValue: false)
  final bool enabled;
  @HiveField(7)
  @JsonKey(defaultValue: '')
  final String appTopLog;
  @HiveField(8)
  @JsonKey(defaultValue: '')
  final String appAboutLog;
  @HiveField(9)
  @JsonKey(defaultValue: '')
  final String appTaskLog;
  @HiveField(10)
  @JsonKey(defaultValue: '')
  final String privacy;
  @HiveField(11)
  @JsonKey(defaultValue: <SystemConfigECard>[])
  final List<SystemConfigECard> eCardSets;

  @override
  List<Object?> get props => <Object?>[
        protocol,
        schoolName,
        favIcon,
        descIcon,
        introduction,
        whiteIcon,
        enabled,
        appTopLog,
        appAboutLog,
        appTaskLog,
        privacy,
        eCardSets,
      ];

  @override
  Map<String, dynamic> toJson() => _$SystemConfigToJson(this);
}

@HiveType(typeId: BoxTypeIds.systemConfigECard)
@JsonSerializable()
class SystemConfigECard extends DataModel {
  const SystemConfigECard({
    required this.imageUrl,
    required this.name,
    required this.isScan,
    required this.html,
    required this.smallImage,
    this.requestUrl,
  });

  factory SystemConfigECard.fromJson(Map<String, dynamic> json) =>
      _$SystemConfigECardFromJson(json);

  @HiveField(0)
  final String imageUrl;
  @HiveField(1)
  final String name;
  @HiveField(2)
  @JsonKey(name: 'scan', defaultValue: false)
  final bool isScan;
  @HiveField(3)
  @JsonKey(defaultValue: true)
  final bool html;
  @HiveField(4)
  final String smallImage;
  @HiveField(5)
  @JsonKey(name: 'reqUrl', defaultValue: null)
  final String? requestUrl;

  String? get composedUrl {
    if (requestUrl == null) {
      return null;
    }
    return requestUrl!.replaceAll('{idToken}', UserAPI.token!);
  }

  @override
  List<Object?> get props =>
      <Object?>[imageUrl, name, isScan, requestUrl, html, smallImage];

  @override
  Map<String, dynamic> toJson() => _$SystemConfigECardToJson(this);
}
