///
/// [Author] Alex (https://github.com/AlexV525)
/// [Date] 2021/8/23 14:47
///
part of 'data_model.dart';

@JsonSerializable()
class TokenModel extends DataModel {
  const TokenModel({
    required this.idToken,
    required this.userNonActivated,
    required this.userNonCompleted,
  });

  factory TokenModel.fromJson(Map<String, dynamic> json) =>
      _$TokenModelFromJson(json);

  final bool userNonActivated;
  final bool userNonCompleted;
  final String idToken;

  @override
  List<Object?> get props => <Object?>[
        idToken,
        userNonActivated,
        userNonCompleted,
      ];

  @override
  Map<String, dynamic> toJson() => _$TokenModelToJson(this);
}
