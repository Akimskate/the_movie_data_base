import 'package:moviedb/domain/api_client/api_client_account.dart';
import 'package:moviedb/domain/api_client/api_client_auth.dart';
import 'package:moviedb/domain/data_providers/session_data_provider.dart';

class AuthService {
  final _apiClientAccount = AccountApiClient();
  final _apiClietAuth = ApiClientAuth();
  final _sessionDataProvider = SessionDataProvider();
  
  Future<bool> isAuth() async {
    final sessionId = await _sessionDataProvider.getSessionId();
    final isAuth = sessionId != null;
    return isAuth;
  }

  Future<void> login(String login, String password) async {
    final sessionId = await _apiClietAuth.auth(
        username: login,
        password: password,
      );
    final accountId = await _apiClientAccount.getAccountInfo(sessionId);
    await _sessionDataProvider.setSessionId(sessionId);
    await _sessionDataProvider.setAccountId(accountId);
  }
}