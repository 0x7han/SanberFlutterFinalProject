
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sanber_flutter_final_project/repositories/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc({AuthRepository? authRepository})
      : _authRepository = authRepository ?? AuthRepository(),
        super(AuthInitial()) {

    on<SignInRequest>((event, emit) async {
      emit(AuthLoading());
      try {
        User? user = await _authRepository.signInWithEmailPassword(
            event.email, event.password);

        emit(AuthAuthenticated(user: user!));
      } catch (e) {
        emit(AuthError(message: e.toString()));
      }
    });

    on<SignUpRequest>((event, emit) async {
      emit(AuthLoading());
      try {
        await _authRepository.signUpWithEmailPassword(
            event.email, event.password, event.fullname, event.noHp);
      } catch (e) {
        emit(AuthError(message: e.toString()));
      }
    });

    on<SignOutRequest>((event, emit) async {
      emit(AuthLoading());
      try {
        await _authRepository.signOut();
        emit(AuthUnauthenticated());
      } catch (e) {
        emit(AuthError(message: e.toString()));
      }
    });

    on<AuthAuthenticate>((event, emit) async {
      emit(AuthAuthenticated(user: event.user));
    });

    on<AuthUnauthenticate>((event, emit) async {
      emit(AuthUnauthenticated());
    });

    _authRepository.user.listen((user) {
      if (user != null) {
        add(AuthAuthenticate(user: user));
      } else {
        add(AuthUnauthenticate());
      }
    });

  }
}

