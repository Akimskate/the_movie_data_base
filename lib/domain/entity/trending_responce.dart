import 'package:json_annotation/json_annotation.dart';
import 'package:moviedb/domain/entity/trending.dart';

part 'trending_responce.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class TrendingResponce {
  int page;
  List<Trending> results;
  int totalPages;
  int totalResults;

  TrendingResponce({
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  factory TrendingResponce.fromJson(Map<String, dynamic> json) =>
      _$TrendingResponceFromJson(json);

  Map<String, dynamic> toJson() => _$TrendingResponceToJson(this);
}
