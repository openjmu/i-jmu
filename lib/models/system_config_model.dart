///
/// [Author] Alex (https://github.com/AlexV525)
/// [Date] 2021/8/23 18:17
///
part of 'data_model.dart';

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

  @JsonKey(defaultValue: '')
  final String protocol;
  final String schoolName;
  final String? favIcon;
  final String? descIcon;
  @JsonKey(defaultValue: '')
  final String introduction;
  final String? whiteIcon;
  @JsonKey(defaultValue: false)
  final bool enabled;
  @JsonKey(defaultValue: '')
  final String appTopLog;
  @JsonKey(defaultValue: '')
  final String appAboutLog;
  @JsonKey(defaultValue: '')
  final String appTaskLog;
  @JsonKey(defaultValue: '')
  final String privacy;
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

  final String imageUrl;
  final String name;
  @JsonKey(name: 'scan', defaultValue: false)
  final bool isScan;
  @JsonKey(defaultValue: true)
  final bool html;
  final String smallImage;
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
