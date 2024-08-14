part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SignInRequest extends AuthEvent {
  final String email;
  final String password;

  SignInRequest({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class SignUpRequest extends AuthEvent {
  final String email;
  final String password;
  final String fullname;
  final String noHp;

  SignUpRequest({required this.email, required this.password, required this.fullname, required this.noHp});

  @override
  List<Object?> get props => [email, password, fullname, noHp];
}

class SignOutRequest extends AuthEvent {}

class AuthAuthenticate extends AuthEvent {
  final User user;

  AuthAuthenticate({required this.user});

  @override
  List<Object?> get props => [user];
}

class AuthUnauthenticate extends AuthEvent {}