import 'dart:convert';

import 'package:client/core/constants/server_constant.dart';
import 'package:client/core/failure/app_failure.dart';
import 'package:client/features/auth/model/user_model.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_remote_repository.g.dart';

@riverpod
AuthRemoteRepository authRemoteRepository(AuthRemoteRepositoryRef ref) {
  return AuthRemoteRepository();
}

class AuthRemoteRepository {
  Future<Either<AppFailure, UserModel>> signup({required String name, required String email, required String password}) async {
    try {
      final response = await http.post(
        Uri.parse("${ServerConstant.serverUrl}auth/signup"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"name": name, "email": email, "password": password}),
      );
      final res = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode != 201) {
        return Left(AppFailure(message: res['detail']));
      }
      return Right(UserModel.fromJson(response.body));
    } catch (e) {
      return Left(AppFailure(message: e.toString()));
    }
  }

  Future<Either<AppFailure, UserModel>> login({required String email, required String password}) async {
    try {
      final response = await http.post(
        Uri.parse("${ServerConstant.serverUrl}auth/login"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"email": email, "password": password}),
      );
      final res = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode != 200) {
        return Left(AppFailure(message: res['detail']));
      }
      return Right(UserModel.fromMap(res['user']).copyWith(token: res['token']));
    } catch (e) {
      return Left(AppFailure(message: e.toString()));
    }
  }

  Future<Either<AppFailure, UserModel>> getCurrentUserData(String token) async {
    try {
      final response = await http.get(
        Uri.parse("${ServerConstant.serverUrl}auth/"),
        headers: {'Content-Type': 'application/json', 'x-auth-token': token},
      );
      final res = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode != 200) {
        return Left(AppFailure(message: res['detail']));
      }
      return Right(UserModel.fromMap(res).copyWith(token: token));
    } catch (e) {
      return Left(AppFailure(message: e.toString()));
    }
  }
}
