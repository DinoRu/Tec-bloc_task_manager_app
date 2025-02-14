
import 'dart:convert';
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:tec_bloc/core/constants/app_urls.dart';
import 'package:tec_bloc/core/failures/failure.dart';
import 'package:tec_bloc/data/auth/models/user.dart';
import 'package:tec_bloc/data/auth/models/user_login_req.dart';
import 'package:tec_bloc/locals/db/db_helper.dart';

abstract class AuthRemoteService {


  Future<Either> login(UserLoginReq user);
  Future<bool> isLoggedIn();
  Future<Either> authUser();
  Future<Either> logout();
}


class AuthRemoteServiceImpl implements AuthRemoteService {

  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  static const String tokenKey = "auth_token";


  final http.Client client;
  AuthRemoteServiceImpl({required this.client});

  @override
  Future<Either> authUser() async {
    final token = await secureStorage.read(key: tokenKey);
    if (token == null) {
      return const Left("Token not found.");
    }
    try {
      final response = await client.get(
        Uri.parse(AppUrls.me),
        headers: {
          'Content-Type': 'application/json',
          "Authorization": "Bearer $token"
        }
      );
      if (response.statusCode == 200) {
        Utf8Decoder decoder = const Utf8Decoder();
        String decoderBody = decoder.convert(response.bodyBytes);
        final userModel = UserModel.fromjson(jsonDecode(decoderBody));
        final user = userModel.toEntity();
        log('$user');
        return Right(user);
      } else if (response.statusCode == 404) {
        return const Left("User not found.");
      } else {
        return Left("Failed to fetch user: ${response.statusCode}");
      }
    } catch (e) {
      return Left("An error occured: $e");
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    final token = await secureStorage.read(key: tokenKey);
    return token != null && token.isNotEmpty;
  }

  @override
  Future<Either> login(UserLoginReq user) async {
    try {
      final response = await client.post(
        Uri.parse(AppUrls.login),
        headers: {
            'Content-Type': 'application/json',
            'accept': 'application/json'
        },
        body: json.encode({
          'username': user.username,
          'password': user.password
        })
      );
      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        final String token = result["access_token"];
        await secureStorage.write(key: tokenKey, value: token);
        return Right(token);
      } else {
        return Left(Failure(
            'Erreur : ${response.statusCode} - ${response.reasonPhrase}',
        ));
      }
    } catch (e) {
      return Left(
        Failure("Error to sign in: $e")
      );
    }
  }
  
  @override
  Future<Either<Failure, bool>> logout() async {
    final DbHelper dbHelper = DbHelper();
    await secureStorage.delete(key: tokenKey);
    final token = await secureStorage.read(key: tokenKey);
    await dbHelper.deleteAllTasks();
    if (token == null) {
      return Right(true);
    } else {
      return Left(Failure("Failed to delete the token."));
    }

  }
}