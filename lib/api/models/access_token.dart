class AccessToken {
  final String accessToken;
  final String tokenType;
  final String scope;
  final int createdAt;

  AccessToken({
    this.accessToken,
    this.tokenType,
    this.scope,
    this.createdAt
  });

  factory AccessToken.fromJson(Map<String, dynamic> jsonStr) {
    return new AccessToken(
      accessToken: jsonStr['access_token'],
      tokenType: jsonStr['token_type'],
      scope: jsonStr['scope'],
      createdAt: jsonStr['created_at']
    );
  }
}