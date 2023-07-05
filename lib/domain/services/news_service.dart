import 'package:moviedb/configuration/configuratioin.dart';
import 'package:moviedb/domain/api_client/account_api_client.dart';
import 'package:moviedb/domain/api_client/news_api_client.dart';
import 'package:moviedb/domain/data_providers/session_data_provider.dart';
import 'package:moviedb/domain/entity/trending_responce.dart';

class NewsService {
  final _newsApiClient = NewsApiClient();
  final _apiClientAccount = AccountApiClient();
  final _sessionDataProvider = SessionDataProvider();

  Future<TrendingResponce> trendingAll(
          // String timeWindow, String locale,
          ) async =>
      _newsApiClient.trendingAll(Configuration.apiKey);
}

//   Future<TrendingResponce> searchMovie(
//     String timeWidnow,
//     String locale,
//     String query,
//   ) async =>
//       _newsApiClient.searchMovie(page, locale, query, Configuration.apiKey);
// }
