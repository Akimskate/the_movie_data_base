import 'package:moviedb/configuration/configuratioin.dart';
import 'package:moviedb/domain/api_client/news_api_client.dart';
import 'package:moviedb/domain/entity/top_rated_movies.dart';
import 'package:moviedb/domain/entity/top_rated_tv_responce.dart';
import 'package:moviedb/domain/entity/trending_responce.dart';

class NewsService {
  final _newsApiClient = NewsApiClient();

  Future<TrendingResponce> trendingAll(
    String timeWindow,
  ) async =>
      _newsApiClient.trendingAll(Configuration.apiKey, timeWindow);

  Future<TopRatedMovieResponce> topRatedMovies() async =>
      _newsApiClient.topRatedMovies(
        Configuration.apiKey,
      );

  Future<TopRatedTVResponce> topRatedTVShow() async =>
      _newsApiClient.topRatedTVShow(
        Configuration.apiKey,
      );
}
