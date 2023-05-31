class UserKisiDetails {
  final int id;
  final String authToken;
  final String phoneKey;
  final String certificate;

  UserKisiDetails({
    required this.id,
    required this.authToken,
    required this.phoneKey,
    required this.certificate,
  });

  factory UserKisiDetails.fromJson(Map<String, dynamic> json) {
    return UserKisiDetails(
      id: json['login_id'] as int,
      authToken: json['token'] as String,
      phoneKey: json['key'] as String,
      certificate: json['certificate'] as String,
    );
  }
}
