import 'package:moviedb/configuration/configuratioin.dart';
import 'package:moviedb/domain/api_client/network_client.dart';
import 'package:moviedb/domain/entity/popular_tv_show_response.dart';
import 'package:moviedb/domain/entity/tv_show_details.dart';

class ShowApiClient {
  final _networkClient = NetworkClient();

  Future<PopularTvShowResponse> popularTvShow(
      int page, String locale, String apiKey) async {
    PopularTvShowResponse parser(dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final response = PopularTvShowResponse.fromJson(jsonMap);
      return response;
    }

    final result = _networkClient.get(
      '/tv/popular',
      parser,
      <String, dynamic>{
        'api_key': apiKey,
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
    String apiKey,
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
        'api_key': apiKey,
        'page': page.toString(),
        'language': locale,
        'query': query,
        'include_adult': true.toString(),
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
