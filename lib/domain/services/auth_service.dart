// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:moviedb/domain/api_client/account_api_client.dart';
import 'package:moviedb/domain/api_client/auth_api_client.dart';
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

  Future<void> logout() async {
    await _sessionDataProvider.deleteSessionId();
    await _sessionDataProvider.deleteAccountId();
  }
}
