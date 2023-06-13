// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:moviedb/domain/api_client/account_api_client.dart';
import 'package:moviedb/domain/api_client/auth_api_client.dart';
import 'package:moviedb/domain/data_providers/session_data_provider.dart';

abstract class AuthEvent {}

class AuthCheckStatusEvent extends AuthEvent {}

class AuthLogoutEvent extends AuthEvent {}

class AuthLoginEvent extends AuthEvent {
  final String login;
  final String password;
  AuthLoginEvent({
    required this.login,
    required this.password,
  });
}

enum AuthStateStatus { autorized, notAutorized, autorization }

abstract class AuthState {}

class AuthUnautorizedState extends AuthState {}

class AuthAutirizedState extends AuthState {}

class AuthFailureState extends AuthState {
  final Object errorMessage;
  AuthFailureState(
    this.errorMessage,
  );
}

class AuthInProgressState extends AuthState {}

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthState initialState) : super(initialState) {
    final _apiClientAccount = AccountApiClient();
    final _apiClietAuth = ApiClientAuth();
    final _sessionDataProvider = SessionDataProvider();

    on<AuthCheckStatusEvent>((event, emit) async {
      final sessionId = await _sessionDataProvider.getSessionId();
      final newState =
          sessionId != null ? AuthAutirizedState() : AuthUnautorizedState();
      emit(newState);
    });
    on<AuthLoginEvent>((event, emit) async {
      try {
        final sessionId = await _apiClietAuth.auth(
          username: event.login,
          password: event.password,
        );
        final accountId = await _apiClientAccount.getAccountInfo(sessionId);
        await _sessionDataProvider.setSessionId(sessionId);
        await _sessionDataProvider.setAccountId(accountId);
        emit(AuthAutirizedState());
      } catch (error) {
        emit(
          AuthFailureState(error),
        );
      }
    });
    on<AuthLogoutEvent>((event, emit) {});
    add(AuthCheckStatusEvent());
  }
}

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
