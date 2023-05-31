class LoginAccessToken {
  final String token;

  LoginAccessToken({required this.token});

  factory LoginAccessToken.fromJson(Map<String, dynamic> json) {
    return LoginAccessToken(
      token: json['access_token'] as String,
    );
  }
}
