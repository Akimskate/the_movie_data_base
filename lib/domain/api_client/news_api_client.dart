import 'package:moviedb/domain/api_client/network_client.dart';
import 'package:moviedb/domain/entity/top_rated_movies.dart';
import 'package:moviedb/domain/entity/top_rated_tv_responce.dart';
import 'package:moviedb/domain/entity/trending_responce.dart';

class NewsApiClient {
  final _netWorkCliet = NetworkClient();

  Future<TrendingResponce> trendingAll(
    String apiKey,
    String timeWindow,
  ) async {
    TrendingResponce parser(dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final response = TrendingResponce.fromJson(jsonMap);
      return response;
    }

    final result = await _netWorkCliet.get(
      '/trending/all/$timeWindow',
      parser,
      <String, dynamic>{
        'time_window': timeWindow,
        'api_key': apiKey,
      },
    );
    return result;
  }

  Future<TopRatedMovieResponce> topRatedMovies(String apiKey) async {
    TopRatedMovieResponce parser(dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final response = TopRatedMovieResponce.fromJson(jsonMap);
      return response;
    }

    final result = await _netWorkCliet.get(
      '/movie/top_rated',
      parser,
      <String, dynamic>{
        'api_key': apiKey,
        // 'page': page.toString(),
        // 'language': locale,
      },
    );
    return result;
  }

  Future<TopRatedTVResponce> topRatedTVShow(String apiKey) async {
    TopRatedTVResponce parser(dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final response = TopRatedTVResponce.fromJson(jsonMap);
      return response;
    }

    final result = await _netWorkCliet.get(
      '/tv/top_rated',
      parser,
      <String, dynamic>{
        'api_key': apiKey,
        // 'page': page.toString(),
        // 'language': locale,
      },
    );
    return result;
  }
}
