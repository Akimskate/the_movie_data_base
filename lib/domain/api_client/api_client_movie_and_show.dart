import 'dart:async';

import 'package:moviedb/configuration/configuratioin.dart';
import 'package:moviedb/domain/api_client/network_client.dart';
import 'package:moviedb/domain/entity/movie_details.dart';
import 'package:moviedb/domain/entity/popular_movie_response.dart';
import 'package:moviedb/domain/entity/popular_tv_show_response.dart';
import 'package:moviedb/domain/entity/tv_show_details.dart';



class ApiClient {
  final _networkClient = NetworkClient();

  

  Future<PopularMovieResponse> popularMovie(int page, String locale) async {
    PopularMovieResponse parser(dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final response = PopularMovieResponse.fromJson(jsonMap);
      return response;
    }

    final result = _networkClient.get(
      '/movie/popular',
      parser,
      <String, dynamic>{
        'api_key': Configuration.apiKey,
        'page': page.toString(),
        'language': locale,
      },
    );
    return result;
  }

  Future<PopularTvShowResponse> popularTvShow(int page, String locale) async {
    PopularTvShowResponse parser(dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final response = PopularTvShowResponse.fromJson(jsonMap);
      return response;
    }

    final result = _networkClient.get(
      '/tv/popular',
      parser,
      <String, dynamic>{
        'api_key': Configuration.apiKey,
        'page': page.toString(),
        'language': locale,
      },
    );
    return result;
  }

  Future<PopularTvShowResponse> searchShow(
    int page,
    String locale,
    String query,
  ) async {
    PopularTvShowResponse parser(dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final response = PopularTvShowResponse.fromJson(jsonMap);
      return response;
    }

    final result = _networkClient.get(
      '/search/tv',
      parser,
      <String, dynamic>{
        'api_key': Configuration.apiKey,
        'page': page.toString(),
        'language': locale,
        'query': query,
        'include_adult': true.toString(),
      },
    );
    return result;
  }

  

  Future<PopularMovieResponse> searchMovie(
    int page,
    String locale,
    String query,
  ) async {
    PopularMovieResponse parser(dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final response = PopularMovieResponse.fromJson(jsonMap);
      return response;
    }

    final result = _networkClient.get(
      '/search/movie',
      parser,
      <String, dynamic>{
        'api_key': Configuration.apiKey,
        'page': page.toString(),
        'language': locale,
        'query': query,
        'include_adult': true.toString(),
      },
    );
    return result;
  }

  Future<MovieDetails> movieDetails(
    int movieId,
    String locale,
  ) async {
    MovieDetails parser(dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final response = MovieDetails.fromJson(jsonMap);
      return response;
    }

    final result = _networkClient.get(
      '/movie/$movieId',
      parser,
      <String, dynamic>{
        'append_to_response': 'credits,videos',
        'api_key': Configuration.apiKey,
        'language': locale,
      },
    );
    return result;
  }

  Future<TvShowDetails> showDetails(
    int showId,
    String locale,
  ) async {
    TvShowDetails parser(dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final response = TvShowDetails.fromJson(jsonMap);
      return response;
    }

    final result = _networkClient.get(
      '/tv/$showId',
      parser,
      <String, dynamic>{
        'append_to_response': 'credits,videos',
        'api_key': Configuration.apiKey,
        'language': locale,
      },
    );
    return result;
  }

  Future<bool> isFavorite(
    int movieId,
    String sessionId,
  ) async {
    bool parser(dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final result = jsonMap['favorite'] as bool;
      return result;
    }

    final result = _networkClient.get(
      '/movie/$movieId/account_states',
      parser,
      <String, dynamic>{
        'api_key': Configuration.apiKey,
        'session_id': sessionId,
      },
    );
    return result;
  }

  Future<bool> isFavoriteShow(
    int showId,
    String sessionId,
  ) async {
    bool parser(dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final result = jsonMap['favorite'] as bool;
      return result;
    }

    final result = _networkClient.get(
      '/tv/$showId/account_states',
      parser,
      <String, dynamic>{
        'api_key': Configuration.apiKey,
        'session_id': sessionId,
      },
    );
    return result;
  }

  
  

}
