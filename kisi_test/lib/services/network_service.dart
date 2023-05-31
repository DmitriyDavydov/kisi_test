import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:kisi_test/models/login_access_token.dart';
import 'package:kisi_test/models/user_kisi_details.dart';

class NetworkService {
  final Dio dio;
  late String _baseUrl;

  String get baseUrl => _baseUrl;

  NetworkService({
    required this.dio,
    required String baseUrl,
  }) {
    dio.options.baseUrl = baseUrl;
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await dio.post(
        '/api/login',
        queryParameters: {
          'email': email,
          'password': password,
        },
      );

      final jsonData = json.decode(json.encode(response.data));
      final accessToken = LoginAccessToken.fromJson(jsonData).token;

      dio.options.headers['Authorization'] = 'Bearer $accessToken';
    } on DioError catch (e) {
      throw Exception('Error occurred: $e');
    }
  }

  Future<UserKisiDetails> getUserKisiDetails() async {
    try {
      final response = await dio.get(
        '/api/kisi/user-kisi-token',
      );

      final jsonData = json.decode(json.encode(response.data));
      final userKisiDetails = UserKisiDetails.fromJson(jsonData);

      return userKisiDetails;
    } on DioError catch (e) {
      throw Exception('Error occurred: $e');
    }
  }
}
