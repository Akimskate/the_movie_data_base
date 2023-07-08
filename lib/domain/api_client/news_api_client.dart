import 'package:moviedb/domain/api_client/network_client.dart';
import 'package:moviedb/domain/entity/trending_responce.dart';

class NewsApiClient {
  final _netWorkCliet = NetworkClient();

  Future<TrendingResponce> trendingAll(
    // String timeWindow, String locale,
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
        // 'page': page.toString(),
        //'language': locale,
        'time_window': timeWindow,
        'api_key': apiKey,
      },
    );
    return result;
  }
}
