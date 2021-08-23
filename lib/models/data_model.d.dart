part of 'data_model.dart';

final Map<Type, DataFactory> dataModelFactories = <Type, DataFactory>{
  EmptyDataModel: (Map<String, dynamic> json) => EmptyDataModel.fromJson(json),
  TokenModel: (Map<String, dynamic> json) => TokenModel.fromJson(json),
};
