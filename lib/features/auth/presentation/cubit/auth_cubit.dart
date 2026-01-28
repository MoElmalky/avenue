import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repo/auth_repository.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository repository;

  AuthCubit({required this.repository}) : super(AuthInitial()) {
    _checkAuthStatus();
  }

  void _checkAuthStatus() {
    if (repository.isAuthenticated) {
      emit(Authenticated(repository.currentUserId!));
    } else {
      emit(Unauthenticated());
    }
  }

  Future<void> signUp({required String email, required String password}) async {
    emit(AuthLoading());
    final result = await repository.signUp(email: email, password: password);
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) => _checkAuthStatus(),
    );
  }

  Future<void> signIn({required String email, required String password}) async {
    emit(AuthLoading());
    final result = await repository.signIn(email: email, password: password);
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) => _checkAuthStatus(),
    );
  }

  Future<void> signOut() async {
    emit(AuthLoading());
    final result = await repository.signOut();
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) => emit(Unauthenticated()),
    );
  }
}
