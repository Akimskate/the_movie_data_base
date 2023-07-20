// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'top_rated_tv_responce.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TopRatedTVResponce _$TopRatedTVResponceFromJson(Map<String, dynamic> json) =>
    TopRatedTVResponce(
      page: json['page'] as int?,
      tvShows: (json['results'] as List<dynamic>)
          .map((e) => TvShow.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalPages: json['total_pages'] as int?,
      totalResults: json['total_results'] as int?,
    );

Map<String, dynamic> _$TopRatedTVResponceToJson(TopRatedTVResponce instance) =>
    <String, dynamic>{
      'page': instance.page,
      'results': instance.tvShows.map((e) => e.toJson()).toList(),
      'total_pages': instance.totalPages,
      'total_results': instance.totalResults,
    };
