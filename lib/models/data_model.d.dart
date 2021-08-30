part of 'data_model.dart';

final Map<Type, DataFactory> dataModelFactories = <Type, DataFactory>{
  EmptyDataModel: (Map<String, dynamic> json) => EmptyDataModel.fromJson(json),
  BannerConfig: (Map<String, dynamic> json) => BannerConfig.fromJson(json),
  BannerModel: (Map<String, dynamic> json) => BannerModel.fromJson(json),
  CourseModel: (Map<String, dynamic> json) => CourseModel.fromJson(json),
  SearchResult: (Map<String, dynamic> json) => SearchResult.fromJson(json),
  SearchResultItem: (Map<String, dynamic> json) => SearchResultItem.fromJson(json),
  SearchResultItemContent: (Map<String, dynamic> json) => SearchResultItemContent.fromJson(json),
  SearchResultItemHighlightFields: (Map<String, dynamic> json) => SearchResultItemHighlightFields.fromJson(json),
  ServiceModel: (Map<String, dynamic> json) => ServiceModel.fromJson(json),
  SystemConfig: (Map<String, dynamic> json) => SystemConfig.fromJson(json),
  SystemConfigECard: (Map<String, dynamic> json) => SystemConfigECard.fromJson(json),
  TokenModel: (Map<String, dynamic> json) => TokenModel.fromJson(json),
};
