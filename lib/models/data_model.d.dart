part of 'data_model.dart';

final Map<Type, DataFactory> dataModelFactories = <Type, DataFactory>{
  EmptyDataModel: (Map<String, dynamic> json) => EmptyDataModel.fromJson(json),
  BannerConfig: (Map<String, dynamic> json) => BannerConfig.fromJson(json),
  BannerModel: (Map<String, dynamic> json) => BannerModel.fromJson(json),
  ServiceModel: (Map<String, dynamic> json) => ServiceModel.fromJson(json),
  SystemConfig: (Map<String, dynamic> json) => SystemConfig.fromJson(json),
  SystemConfigECard: (Map<String, dynamic> json) => SystemConfigECard.fromJson(json),
  TokenModel: (Map<String, dynamic> json) => TokenModel.fromJson(json),
};
