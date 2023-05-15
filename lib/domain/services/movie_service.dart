import 'package:moviedb/configuration/configuratioin.dart';
import 'package:moviedb/domain/api_client/movie_api_client.dart';
import 'package:moviedb/domain/entity/popular_movie_response.dart';

class MovieService {
  final _movieApiClient = MovieApiClient();
  
  Future<PopularMovieResponse> popularMovie(int page, String locale) async =>
  _movieApiClient.popularMovie(page, locale, Configuration.apiKey);

  Future<PopularMovieResponse> searchMovie(
    int page,
    String locale,
    String query,
  ) async => 
  _movieApiClient.searchMovie(page, locale, query, Configuration.apiKey); 

}