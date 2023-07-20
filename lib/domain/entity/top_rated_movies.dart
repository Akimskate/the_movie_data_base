// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';
import 'package:moviedb/domain/entity/movie.dart';

part 'top_rated_movies.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class TopRatedMovieResponce {
  int? page;
  @JsonKey(name: 'results')
  final List<Movie> movie;
  int? totalPages;
  int? totalResults;

  TopRatedMovieResponce({
    required this.page,
    required this.movie,
    required this.totalPages,
    required this.totalResults,
  });

  factory TopRatedMovieResponce.fromJson(Map<String, dynamic> json) =>
      _$TopRatedMovieResponceFromJson(json);

  Map<String, dynamic> toJson() => _$TopRatedMovieResponceToJson(this);
}
