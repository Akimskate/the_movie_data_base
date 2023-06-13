import 'package:moviedb/configuration/configuratioin.dart';
import 'package:moviedb/domain/api_client/account_api_client.dart';
import 'package:moviedb/domain/api_client/show_api_client.dart';
import 'package:moviedb/domain/data_providers/session_data_provider.dart';
import 'package:moviedb/domain/entity/local_entities/tv_show_details_local.dart';

import 'package:moviedb/domain/entity/popular_tv_show_response.dart';

class TvShowService {
  final _showApiClient = ShowApiClient();
  final _apiClientAccount = AccountApiClient();
  final _sessionDataProvider = SessionDataProvider();

  Future<PopularTvShowResponse> popularMovie(int page, String locale) async =>
      _showApiClient.popularTvShow(page, locale, Configuration.apiKey);

  Future<PopularTvShowResponse> searchMovie(
    int page,
    String locale,
    String query,
  ) async =>
      _showApiClient.searchShow(page, locale, query, Configuration.apiKey);

  Future<TvShowDetailsLocal> loadDetails({
    required int movieId,
    required String locale,
  }) async {
    final movieDetails = await _showApiClient.showDetails(movieId, locale);
    final sessionId = await _sessionDataProvider.getSessionId();
    var isFavorite = false;
    if (sessionId != null) {
      isFavorite = await _showApiClient.isFavoriteShow(movieId, sessionId);
    }
    return TvShowDetailsLocal(details: movieDetails, isFavorite: isFavorite);
  }

  Future<void> updateFavorite({
    required int mediaId,
    required bool isFavorite,
  }) async {
    final sessionId = await _sessionDataProvider.getSessionId();
    final accountId = await _sessionDataProvider.getAccountId();

    if (accountId == null || sessionId == null) return;
    await _apiClientAccount.markAsFavorite(
      accountId: accountId,
      sessionId: sessionId,
      mediaType: MediaType.tv,
      mediaId: mediaId,
      isFavorite: isFavorite,
    );
  }
}
