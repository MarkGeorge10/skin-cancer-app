class User {
  final String userId;
  final String email;
  final String name;
  final DateTime createdAt;
  final DateTime? emailVerifiedAt;
  final DateTime? lastLoginAt;
  final DateTime updatedAt;
  final bool isEmailVerified;
  final String accessToken;
  final DateTime accessTokenExpiry;
  final String? avatarUrl;

  User({
    required this.userId,
    required this.email,
    required this.name,
    required this.createdAt,
    this.emailVerifiedAt,
    this.lastLoginAt,
    required this.updatedAt,
    required this.isEmailVerified,
    this.avatarUrl,
    required this.accessToken,
    required this.accessTokenExpiry,
  });

  /// For API response
  factory User.fromApiJson(Map<String, dynamic> json) {
    final userJson = json['result']?['user'];
    if (userJson == null) {
      throw Exception('User data is missing in response');
    }

    final expiresInSeconds = json['result']?['expires_in'];
    final expiry = (expiresInSeconds != null && expiresInSeconds is int)
        ? DateTime.now().add(Duration(seconds: expiresInSeconds))
        : DateTime.now().add(const Duration(hours: 1));

    return User(
      userId: userJson['userId'] as String,
      email: userJson['email'] as String,
      name: userJson['name'] as String,
      createdAt: DateTime.parse(userJson['createdAt'] as String),
      emailVerifiedAt: userJson['emailVerifiedAt'] != null
          ? DateTime.parse(userJson['emailVerifiedAt'] as String)
          : null,
      lastLoginAt: userJson['lastLoginAt'] != null
          ? DateTime.parse(userJson['lastLoginAt'] as String)
          : null,
      updatedAt: DateTime.parse(userJson['updatedAt'] as String),
      isEmailVerified: userJson['isEmailVerified'] as bool,
      accessToken: json['result']['access_token'] as String,
      accessTokenExpiry: expiry,
      avatarUrl: null,
    );
  }

  /// For saving/loading locally
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['userId'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      emailVerifiedAt: json['emailVerifiedAt'] != null
          ? DateTime.parse(json['emailVerifiedAt'] as String)
          : null,
      lastLoginAt: json['lastLoginAt'] != null
          ? DateTime.parse(json['lastLoginAt'] as String)
          : null,
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      isEmailVerified: json['isEmailVerified'] as bool,
      accessToken: json['accessToken'] as String,
      accessTokenExpiry: DateTime.parse(json['accessTokenExpiry'] as String),
      avatarUrl: json['avatarUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'email': email,
      'name': name,
      'createdAt': createdAt.toIso8601String(),
      'emailVerifiedAt': emailVerifiedAt?.toIso8601String(),
      'lastLoginAt': lastLoginAt?.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isEmailVerified': isEmailVerified,
      'accessToken': accessToken,
      'accessTokenExpiry': accessTokenExpiry.toIso8601String(),
      'avatarUrl': avatarUrl,
    };
  }
}
