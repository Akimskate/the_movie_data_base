// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trending.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Trending _$TrendingFromJson(Map<String, dynamic> json) => Trending(
      json['original_name'] as String?,
      adult: json['adult'] as bool,
      backdropPath: json['backdrop_path'] as String?,
      id: json['id'] as int,
      name: json['name'] as String?,
      title: json['title'] as String?,
      originalLanguage: json['original_language'] as String,
      originalTitle: json['original_title'] as String?,
      overview: json['overview'] as String,
      posterPath: json['poster_path'] as String?,
      mediaType: json['media_type'] as String,
      genreIds:
          (json['genre_ids'] as List<dynamic>).map((e) => e as int).toList(),
      popularity: (json['popularity'] as num).toDouble(),
      releaseDate: parseMovieDateFromString(json['release_date'] as String?),
      firstAirDate: parseMovieDateFromString(json['first_air_date'] as String?),
      video: json['video'] as bool?,
      voteAverage: (json['vote_average'] as num).toDouble(),
      voteCount: json['vote_count'] as int,
    );

Map<String, dynamic> _$TrendingToJson(Trending instance) {
  final val = <String, dynamic>{
    'adult': instance.adult,
    'backdrop_path': instance.backdropPath,
    'id': instance.id,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('name', instance.name);
  writeNotNull('title', instance.title);
  val['original_language'] = instance.originalLanguage;
  writeNotNull('original_name', instance.originalName);
  writeNotNull('original_title', instance.originalTitle);
  val['overview'] = instance.overview;
  val['poster_path'] = instance.posterPath;
  val['media_type'] = instance.mediaType;
  val['genre_ids'] = instance.genreIds;
  val['popularity'] = instance.popularity;
  val['first_air_date'] = instance.firstAirDate?.toIso8601String();
  val['release_date'] = instance.releaseDate?.toIso8601String();
  writeNotNull('video', instance.video);
  val['vote_average'] = instance.voteAverage;
  val['vote_count'] = instance.voteCount;
  return val;
}
