part of 'auth_bloc.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated }

class AuthState extends Equatable {
  final AuthStatus status;
  final String? token;
  final String? errorMessage;

  const AuthState({
    this.status = AuthStatus.initial,
    this.token,
    this.errorMessage,
  });

  AuthState copyWith({
    AuthStatus? status,
    String? token,
    String? errorMessage,
  }) {
    return AuthState(
      status: status ?? this.status,
      token: token ?? this.token,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, token, errorMessage];
}
