class Session {

  final String? tokenType;
  final String? accessToken;
  final String? refreshToken;
  final int? expiresIn;
  final DateTime? createdAt;

  Session({this.tokenType, this.accessToken, this.refreshToken, this.expiresIn, DateTime? createdAt})
      : createdAt = createdAt ?? DateTime.now();

  static Session fromJson(Map<String, dynamic> data) {
    DateTime? createdAt;
    if (data['created_at'] != null) {
      try {
        if (data['created_at'] is String) {
          createdAt = DateTime.parse(data['created_at']);
        }
      } catch (e) {
        // Si falla el parseo, usar DateTime.now()
        createdAt = DateTime.now();
      }
    } else {
      createdAt = DateTime.now();
    }
    
    return Session(
      tokenType: data['token_type'],
      accessToken: data['access_token'],
      refreshToken: data['refresh_token'],
      expiresIn: data['expires_in'],
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    var data = <String, dynamic>{};
    data['token_type'] = tokenType;
    data['access_token'] = accessToken;
    data['refresh_token'] = refreshToken;
    data['expires_in'] = expiresIn;
    data['created_at'] = createdAt?.toIso8601String();
    return data;
  }

  /// Verifica si el token de acceso está expirado o próximo a expirarse
  /// [bufferSeconds] tiempo en segundos antes de la expiración para considerarlo expirado (default: 60)
  bool isExpired({int bufferSeconds = 60}) {
    if (accessToken == null || expiresIn == null || createdAt == null) {
      return true;
    }
    
    final expirationTime = createdAt!.add(Duration(seconds: expiresIn!));
    final bufferTime = expirationTime.subtract(Duration(seconds: bufferSeconds));
    
    return DateTime.now().isAfter(bufferTime);
  }

  /// Verifica si el token puede ser refrescado
  bool canRefresh() {
    return refreshToken != null && refreshToken!.isNotEmpty;
  }

  /// Calcula la fecha de expiración del token
  DateTime? get expirationDate {
    if (createdAt == null || expiresIn == null) {
      return null;
    }
    return createdAt!.add(Duration(seconds: expiresIn!));
  }

}