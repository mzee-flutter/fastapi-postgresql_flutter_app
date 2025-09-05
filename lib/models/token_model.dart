class TokenModel {
  String accessToken;
  String tokenType;
  String refreshToken;
  int expireAt;

  TokenModel({
    required this.accessToken,
    required this.tokenType,
    required this.refreshToken,
    required this.expireAt,
  });

  factory TokenModel.fromJson(Map<String, dynamic> json) {
    return TokenModel(
      accessToken: json['access_token'],
      tokenType: json['token_type'],
      refreshToken: json['refresh_token'],
      expireAt: (json['expire_at'] is int)
          ? json['expire_at']
          : int.tryParse(json['expire_at'].toString()) ?? 0,
    );
  }
  //
  // Map<String, dynamic> toJson() {
  //   return {'access_token': accessToken, 'token_type': tokenType};
  // }
}
