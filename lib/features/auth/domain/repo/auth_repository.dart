import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';

abstract class AuthRepository {
  Future<Either<Failure, void>> signUp({
    required String email,
    required String password,
  });

  Future<Either<Failure, void>> signIn({
    required String email,
    required String password,
  });

  Future<Either<Failure, void>> signOut();

  bool get isAuthenticated;
  String? get currentUserId;

  Future<Either<Failure, void>> updateTimezone(int offsetInHours);
}
