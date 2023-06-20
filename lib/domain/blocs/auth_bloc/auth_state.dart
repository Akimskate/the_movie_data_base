abstract class AuthState {}

class AuthUnautorizedState extends AuthState {
  @override
  bool operator ==(Object other) =>
      other is AuthUnautorizedState && runtimeType == other.runtimeType;

  @override
  int get hashCode => 0;
}

class AuthAutirizedState extends AuthState {
  @override
  bool operator ==(Object other) =>
      other is AuthAutirizedState && runtimeType == other.runtimeType;

  @override
  int get hashCode => 0;
}

class AuthFailureState extends AuthState {
  final Object error;
  AuthFailureState(this.error);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthFailureState &&
          runtimeType == other.runtimeType &&
          error == other.error;

  @override
  int get hashCode => error.hashCode;
}

class AuthInProgressState extends AuthState {
  @override
  bool operator ==(Object other) =>
      other is AuthInProgressState && runtimeType == other.runtimeType;

  @override
  int get hashCode => 0;
}

class AuthCheckStatusInProgressState extends AuthState {
  @override
  bool operator ==(Object other) =>
      other is AuthCheckStatusInProgressState &&
      runtimeType == other.runtimeType;

  @override
  int get hashCode => 0;
}
