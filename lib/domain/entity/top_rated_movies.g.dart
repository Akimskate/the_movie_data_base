// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'top_rated_movies.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TopRatedMovieResponce _$TopRatedMovieResponceFromJson(
        Map<String, dynamic> json) =>
    TopRatedMovieResponce(
      page: json['page'] as int?,
      movie: (json['results'] as List<dynamic>)
          .map((e) => Movie.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalPages: json['total_pages'] as int?,
      totalResults: json['total_results'] as int?,
    );

Map<String, dynamic> _$TopRatedMovieResponceToJson(
        TopRatedMovieResponce instance) =>
    <String, dynamic>{
      'page': instance.page,
      'results': instance.movie.map((e) => e.toJson()).toList(),
      'total_pages': instance.totalPages,
      'total_results': instance.totalResults,
    };
