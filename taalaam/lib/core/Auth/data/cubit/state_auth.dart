abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {}

class AuthError extends AuthState {
  final int? errorCode;
  final String? message;

  AuthError({this.message, this.errorCode});
}
