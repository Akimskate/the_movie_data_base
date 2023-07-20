// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';

import 'package:moviedb/domain/entity/tv_show.dart';

part 'top_rated_tv_responce.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class TopRatedTVResponce {
  int? page;
  @JsonKey(name: 'results')
  final List<TvShow> tvShows;
  int? totalPages;
  int? totalResults;

  TopRatedTVResponce({
    required this.page,
    required this.tvShows,
    required this.totalPages,
    required this.totalResults,
  });

  factory TopRatedTVResponce.fromJson(Map<String, dynamic> json) =>
      _$TopRatedTVResponceFromJson(json);

  Map<String, dynamic> toJson() => _$TopRatedTVResponceToJson(this);
}
