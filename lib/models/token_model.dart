class TokenModel {
  String token;
  String tokenType;

  TokenModel({required this.token, required this.tokenType});

  factory TokenModel.fromJson(Map<String, dynamic> json) {
    return TokenModel(
      token: json['access_token'],
      tokenType: json['token_type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'access_token': token, 'token_type': tokenType};
  }
}
