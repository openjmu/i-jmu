part of 'data_model.dart';

final Map<Type, DataFactory> dataModelFactories = <Type, DataFactory>{
  EmptyDataModel: (Map<String, dynamic> json) => EmptyDataModel.fromJson(json),
  SystemConfigModel: (Map<String, dynamic> json) => SystemConfigModel.fromJson(json),
  SystemConfigECard: (Map<String, dynamic> json) => SystemConfigECard.fromJson(json),
  TokenModel: (Map<String, dynamic> json) => TokenModel.fromJson(json),
};
