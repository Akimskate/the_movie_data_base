// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';

import 'package:moviedb/domain/entity/tv_show.dart';

part 'popular_tv_show_response.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class PopularTvShowResponse {
  final int page;
  @JsonKey(name: 'results')
  final List<TvShow> tvShows;
  final int totalResults;
  final int totalPages;
  PopularTvShowResponse({
    required this.page,
    required this.tvShows,
    required this.totalResults,
    required this.totalPages,
  });

  factory PopularTvShowResponse.fromJson(Map<String, dynamic> json) =>
      _$PopularTvShowResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PopularTvShowResponseToJson(this);

  PopularTvShowResponse copyWith({
    int? page,
    List<TvShow>? tvShows,
    int? totalResults,
    int? totalPages,
  }) {
    return PopularTvShowResponse(
      page: page ?? this.page,
      tvShows: tvShows ?? this.tvShows,
      totalResults: totalResults ?? this.totalResults,
      totalPages: totalPages ?? this.totalPages,
    );
  }
}
