///
/// [Author] Alex (https://github.com/AlexV525)
/// [Date] 2021/8/25 15:10
///
part of 'data_model.dart';

@JsonSerializable()
class SearchResult extends DataModel {
  const SearchResult({
    required this.total,
    this.relationType,
    required this.maxScore,
    this.scrollId,
    required this.items,
    this.aggregations,
    required this.empty,
  });

  factory SearchResult.fromJson(Map<String, dynamic> json) =>
      _$SearchResultFromJson(json);

  @JsonKey(name: 'totalHits', defaultValue: 0)
  final int total;
  @JsonKey(name: 'totalHitsRelation')
  final String? relationType;
  @JsonKey(fromJson: dTryParseDouble)
  final double maxScore;
  final String? scrollId;
  @JsonKey(name: 'searchHits', defaultValue: <SearchResultItem>[])
  final List<SearchResultItem> items;
  final Object? aggregations;
  @JsonKey(defaultValue: false)
  final bool empty;

  bool get isEmpty => empty || total == 0 || items.isEmpty;

  @override
  Map<String, dynamic> toJson() => _$SearchResultToJson(this);

  @override
  List<Object?> get props => <Object?>[
        total,
        relationType,
        maxScore,
        scrollId,
        items,
        aggregations,
        empty,
      ];
}

@JsonSerializable()
class SearchResultItem extends DataModel {
  const SearchResultItem({
    required this.id,
    required this.score,
    required this.sortValues,
    required this.content,
    required this.highlightFields,
  });

  factory SearchResultItem.fromJson(Map<String, dynamic> json) =>
      _$SearchResultItemFromJson(json);

  final String id;
  @JsonKey(fromJson: dTryParseDouble)
  final double score;
  final List<Object?> sortValues;
  final SearchResultItemContent content;
  final SearchResultItemHighlightFields highlightFields;

  ValueKey<String> valueKey([String method = 'search']) =>
      ValueKey<String>('$id-$method');

  @override
  Map<String, dynamic> toJson() => _$SearchResultItemToJson(this);

  @override
  List<Object?> get props => <Object?>[
        id,
        score,
        sortValues,
        content,
        highlightFields,
      ];
}

@JsonSerializable()
class SearchResultItemContent extends DataModel {
  const SearchResultItemContent({
    required this.serviceType,
    required this.serveImageUrl,
    required this.serveNum,
    required this.serveId,
    required this.permission,
    required this.type,
    required this.serveSource,
    required this.serveLabel,
    required this.serveName,
    required this.serveUrl,
    required this.hiddenClass,
    required this.startDate,
    required this.serveTerminal,
  });

  factory SearchResultItemContent.fromJson(Map<String, dynamic> json) =>
      _$SearchResultItemContentFromJson(json);

  final String serviceType;
  final String serveImageUrl;
  final String serveNum;
  final String serveId;
  @JsonKey(defaultValue: <String>[])
  final List<String> permission;
  final String type;
  final String serveSource;
  @JsonKey(name: 'serveLable', defaultValue: <String>[])
  final List<String> serveLabel;
  final String serveName;
  final String serveUrl;
  @JsonKey(name: '_class')
  final String hiddenClass;
  final int startDate;
  @JsonKey(defaultValue: <String>[])
  final List<String> serveTerminal;

  @override
  Map<String, dynamic> toJson() => _$SearchResultItemContentToJson(this);

  @override
  List<Object?> get props => <Object?>[
        serviceType,
        serveImageUrl,
        serveNum,
        serveId,
        permission,
        type,
        serveSource,
        serveLabel,
        serveName,
        serveUrl,
        hiddenClass,
        startDate,
        serveTerminal,
      ];
}

@JsonSerializable()
class SearchResultItemHighlightFields extends DataModel {
  const SearchResultItemHighlightFields({
    required this.serviceType,
    required this.serveName,
    required this.serviceKeyword,
    required this.permission,
    required this.serveTerminal,
  });

  factory SearchResultItemHighlightFields.fromJson(Map<String, dynamic> json) =>
      _$SearchResultItemHighlightFieldsFromJson(json);

  @JsonKey(defaultValue: <String>[])
  final List<String> serviceType;
  @JsonKey(defaultValue: <String>[])
  final List<String> serveName;
  @JsonKey(name: 'service.keyword', defaultValue: <String>[])
  final List<String> serviceKeyword;
  @JsonKey(defaultValue: <String>[])
  final List<String> permission;
  @JsonKey(defaultValue: <String>[])
  final List<String> serveTerminal;

  @override
  Map<String, dynamic> toJson() =>
      _$SearchResultItemHighlightFieldsToJson(this);

  @override
  List<Object?> get props => <Object?>[
        serviceType,
        serveName,
        serviceKeyword,
        permission,
        serveTerminal,
      ];
}
