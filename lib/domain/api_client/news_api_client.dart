import 'package:moviedb/domain/api_client/network_client.dart';
import 'package:moviedb/domain/entity/trending_responce.dart';

class NewsApiClient {
  final _netWorkCliet = NetworkClient();

  Future<TrendingResponce> trendingAll(
      // String timeWindow, String locale,
      String apiKey) async {
    TrendingResponce parser(dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final response = TrendingResponce.fromJson(jsonMap);
      return response;
    }

    final result = await _netWorkCliet.get(
      '/trending/all/day',
      parser,
      <String, dynamic>{
        //'time_window': timeWindow,
        // 'page': page.toString(),
        //'language': locale,
        'api_key': apiKey,
      },
    );
    return result;
  }
}
