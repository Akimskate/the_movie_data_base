import 'package:moviedb/configuration/configuratioin.dart';
import 'package:moviedb/domain/api_client/account_api_client.dart';
import 'package:moviedb/domain/api_client/show_api_client.dart';
import 'package:moviedb/domain/data_providers/session_data_provider.dart';
import 'package:moviedb/domain/entity/local_entities/tv_show_details_local.dart';
import 'package:moviedb/domain/entity/popular_tv_show_response.dart';

class ShowService {
  final _showApiClient = ShowApiClient();
  final _apiClientAccount = AccountApiClient();
  final _sessionDataProvider = SessionDataProvider();

  Future<PopularTvShowResponse> popularTvShow(int page, String locale) async =>
      _showApiClient.popularTvShow(page, locale, Configuration.apiKey);

  Future<PopularTvShowResponse> searchTvShow(
    int page,
    String locale,
    String query,
  ) async =>
      _showApiClient.searchShow(page, locale, query, Configuration.apiKey);

  Future<TvShowDetailsLocal> loadDetailsShow({
    required int showId,
    required String locale,
  }) async {
    final showDetails = await _showApiClient.showDetails(showId, locale);
    final sessionId = await _sessionDataProvider.getSessionId();
    var isFavoriteShow = false;
    if (sessionId != null) {
      isFavoriteShow = await _showApiClient.isFavoriteShow(showId, sessionId);
    }
    return TvShowDetailsLocal(
        details: showDetails, isFavoriteShow: isFavoriteShow);
  }

  Future<void> updateFavoriteShow({
    required int showId,
    required bool isFavoriteShow,
  }) async {
    final sessionId = await _sessionDataProvider.getSessionId();
    final accountId = await _sessionDataProvider.getAccountId();

    if (accountId == null || sessionId == null) return;
    await _apiClientAccount.markAsFavoriteShow(
      accountId: accountId,
      sessionId: sessionId,
      mediaType: MediaType.tv,
      mediaId: showId,
      isFavoriteShow: isFavoriteShow,
    );
  }
}
