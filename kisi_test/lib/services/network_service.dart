import 'package:dio/dio.dart';

class NetworkService {
  final Dio dio;
  late String _baseUrl;

  String get baseUrl => _baseUrl;

  NetworkService({
    required this.dio,
    required String baseUrl,
  }) {
    _baseUrl = baseUrl;
  }

  Future<Response> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await dio.post(
        '$baseUrl/api/login',
        queryParameters: {
          'email': email,
          'password': password,
        },
      );
      return response;
    } on DioError catch (e) {
      throw Exception('Error occurred: $e');
    }
  }

  void getUserToken() async {
    print('Network request!');
    final response = await dio.get(
      '$baseUrl/api/kisi/get-user-token',
    );
    print(response);
  }
}
