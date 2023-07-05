import 'package:json_annotation/json_annotation.dart';
import 'package:moviedb/domain/entity/movie_date_parser.dart';

part 'trending.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class Trending {
  final bool adult;
  final String? backdropPath;
  final int id;
  @JsonKey(name: 'name', includeIfNull: false)
  final String? name;
  @JsonKey(name: 'title', includeIfNull: false)
  final String? title;
  final String originalLanguage;

  @JsonKey(name: 'original_name', includeIfNull: false)
  final String? originalName;
  @JsonKey(name: 'original_title', includeIfNull: false)
  final String? originalTitle;
  final String overview;
  final String? posterPath;
  final String mediaType;
  final List<int> genreIds;
  final double popularity;
  @JsonKey(fromJson: parseMovieDateFromString)
  final DateTime? firstAirDate;
  @JsonKey(fromJson: parseMovieDateFromString)
  final DateTime? releaseDate;
  @JsonKey(name: 'video', includeIfNull: false)
  final bool? video;
  final double voteAverage;
  final int voteCount;

  Trending(
    this.originalName, {
    required this.adult,
    required this.backdropPath,
    required this.id,
    required this.name,
    required this.title,
    required this.originalLanguage,
    required this.originalTitle,
    required this.overview,
    required this.posterPath,
    required this.mediaType,
    required this.genreIds,
    required this.popularity,
    required this.releaseDate,
    required this.firstAirDate,
    required this.video,
    required this.voteAverage,
    required this.voteCount,
  });

  factory Trending.fromJson(Map<String, dynamic> json) =>
      _$TrendingFromJson(json);

  Map<String, dynamic> toJson() => _$TrendingToJson(this);
}
