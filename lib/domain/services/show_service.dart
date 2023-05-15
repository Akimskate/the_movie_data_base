import 'package:moviedb/configuration/configuratioin.dart';
import 'package:moviedb/domain/api_client/show_api_client.dart';
import 'package:moviedb/domain/entity/popular_tv_show_response.dart';

class ShowService {
  final _showApiClient = ShowApiClient();
  
  Future<PopularTvShowResponse> popularTvShow(int page, String locale) async =>
  _showApiClient.popularTvShow(page, locale, Configuration.apiKey);

  Future<PopularTvShowResponse> searchMovie(
    int page,
    String locale,
    String query,
  ) async => 
  _showApiClient.searchShow(page, locale, query, Configuration.apiKey); 

}