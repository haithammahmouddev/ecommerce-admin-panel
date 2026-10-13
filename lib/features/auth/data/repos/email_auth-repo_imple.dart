import 'package:dartz/dartz.dart';
import 'package:ecommerce_admin_pannal/common/local_storage/local_storage_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../../common/network/firebase/database_services.dart';
import '../../../../common/errors/exceptions.dart';
import '../../../../common/errors/failure.dart';
import '../../../../utils/constants/enums.dart';
import '../models/user_model.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repos/email_auth_repo.dart';
import '../data_source/email_auth_datasource.dart';

class EmailAuthRepoImple implements EmailAuthRepo {
  final EmailAuthDatasource _emailAuthDatasource;
  final DatabaseServices _databaseServices;

  EmailAuthRepoImple({
    required EmailAuthDatasource emailAuthDatasource,
    required DatabaseServices databaseServices,
  })  : _emailAuthDatasource = emailAuthDatasource,
        _databaseServices = databaseServices;

  @override
  Future<Either<Failure, UserEntity>> login({
    required String email,
    required String password,
  }) async {
    try {
      final UserModel user = await _emailAuthDatasource.login(
        email: email,
        password: password,
      );
      final UserModel? userModel = LocalStorageService.userRepo.getData();
      if (FirebaseAuth.instance.currentUser?.emailVerified ?? false) {
        if (userModel == null) {
          await _databaseServices.setData(
            path: 'users',
            docId: user.id,
            data: user.toJson(),
          );
          await LocalStorageService.userRepo.saveData(user);
        }
      }
      return right(user.toEntity());
    } on AuthException catch (e) {
      return left(AuthFailure(e.toString()));
    } on ServerException catch (e) {
      return left(ServerFailure(e.toString()));
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signUp({
    required String userName,
    required String phoneNumber,
    required String email,
    required String password,
  }) async {
    try {
      final UserModel user = await _emailAuthDatasource.signUp(
        userName: userName,
        email: email,
        password: password,
        phoneNumber: phoneNumber,
      );

       final adminUser = user.copyWith(
        fullName: userName,
        phoneNumber: phoneNumber,
        role: AppRole.admin,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

       await _databaseServices.setData(
        path: 'users',
        docId: adminUser.id,
        data: adminUser.toJson(),
      );

       await LocalStorageService.userRepo.saveData(adminUser);

      return right(adminUser.toEntity());
    } on AuthException catch (e) {
      return left(AuthFailure(e.toString()));
    } on ServerException catch (e) {
      return left(ServerFailure(e.toString()));
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }
}