import 'dart:convert';

import 'package:client/auth/model/user_model.dart';
import 'package:client/core/failure/failure.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;

class AuthRemoteRepository {
  Future<Either<AppFailure, UserModel>> signup({required String name, required String email, required String password}) async {
    try {
      final response = await http.post(
        Uri.parse("http://127.0.0.1:8000/auth/signup"),
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
        Uri.parse("http://127.0.0.1:8000/auth/login"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"email": email, "password": password}),
      );
      final res = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode != 200) {
        return Left(AppFailure(message: res['detail']));
      }
      return Right(UserModel.fromJson(response.body));
    } catch (e) {
      return Left(AppFailure(message: e.toString()));
    }
  }
}
