import 'package:json_annotation/json_annotation.dart';
import 'package:moviedb/domain/entity/movie_date_parser.dart';
import 'package:moviedb/domain/entity/tv_show_details_credits.dart';
import 'package:moviedb/domain/entity/tv_show_details_videos.dart';

part 'tv_show_details.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class TvShowDetails {
  final bool? adult;
  final String? backdropPath;
  final List<CreatedBy> createdBy;
  final List<int>? episodeRunTime;
  @JsonKey(fromJson: parseMovieDateFromString)
  final DateTime? firstAirDate;
  final List<Genre> genres;
  final String homepage;
  final int id;
  final String name;
  final List<String> originCountry;
  final String originalLanguage;
  final String overview;
  final String? posterPath;
  final List<ProductionCountrie> productionCountries;
  final double voteAverage;
  final int voteCount;
  final TvShowDetailsVideo? videos;
  final TvShowDetailsCredits credits;
  TvShowDetails({
    required this.adult,
    required this.backdropPath,
    required this.createdBy,
    required this.episodeRunTime,
    required this.firstAirDate,
    required this.genres,
    required this.homepage,
    required this.id,
    required this.name,
    required this.originCountry,
    required this.originalLanguage,
    required this.overview,
    required this.posterPath,
    required this.productionCountries,
    required this.voteAverage,
    required this.voteCount,
    required this.credits,
    required this.videos,
  });
  factory TvShowDetails.fromJson(Map<String, dynamic> json) =>
      _$TvShowDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$TvShowDetailsToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class CreatedBy {
  final int id;
  final String creditId;
  final String name;
  final int gender;
  final String? profilePath;
  CreatedBy({
    required this.id,
    required this.creditId,
    required this.name,
    required this.gender,
    required this.profilePath,
  });
  factory CreatedBy.fromJson(Map<String, dynamic> json) =>
      _$CreatedByFromJson(json);

  Map<String, dynamic> toJson() => _$CreatedByToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class Genre {
  final int id;
  final String name;
  Genre({
    required this.id,
    required this.name,
  });
  factory Genre.fromJson(Map<String, dynamic> json) => _$GenreFromJson(json);

  Map<String, dynamic> toJson() => _$GenreToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class ProductionCountrie {
  @JsonKey(name: 'iso_3166_1')
  final String iso31661;
  final String name;
  ProductionCountrie({
    required this.iso31661,
    required this.name,
  });
  factory ProductionCountrie.fromJson(Map<String, dynamic> json) =>
      _$ProductionCountrieFromJson(json);

  Map<String, dynamic> toJson() => _$ProductionCountrieToJson(this);
}
