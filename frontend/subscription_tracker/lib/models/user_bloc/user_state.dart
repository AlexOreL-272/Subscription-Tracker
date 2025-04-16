enum AuthStatus { unauthorized, pending, authorized, error }

class UserState {
  final AuthStatus authStatus;
  final String? id;
  final String? email;
  final String? surname;
  final String? fullName;

  final String? accessToken;
  final String? refreshToken;

  final String? errorMessage;

  const UserState({
    required this.authStatus,
    this.id,
    this.email,
    this.surname,
    this.fullName,
    this.accessToken,
    this.refreshToken,
    this.errorMessage,
  });

  UserState.unauthorized() : this(authStatus: AuthStatus.unauthorized);

  UserState.pending() : this(authStatus: AuthStatus.pending);

  UserState.error(String errorMsg)
    : this(authStatus: AuthStatus.error, errorMessage: errorMsg);

  UserState.authorized(
    String id,
    String email,
    String surname,
    String fullName,
    String accessToken,
    String refreshToken,
  ) : this(
        authStatus: AuthStatus.authorized,
        id: id,
        email: email,
        surname: surname,
        fullName: fullName,
        accessToken: accessToken,
        refreshToken: refreshToken,
      );

  static UserState fromJson(Map<String, dynamic> json) {
    return UserState(
      authStatus: AuthStatus.values[json['authStatus'] as int],
      id: json['id'] as String?,
      email: json['email'] as String?,
      surname: json['surname'] as String?,
      fullName: json['fullName'] as String?,
      accessToken: json['accessToken'] as String?,
      refreshToken: json['refreshToken'] as String?,
      errorMessage: json['errorMessage'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'authStatus': authStatus.index,
      'id': id,
      'email': email,
      'surname': surname,
      'fullName': fullName,
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'errorMessage': errorMessage,
    };
  }
}
