enum AuthStatus { unauthorized, pending, authorized, error }

class UserState {
  final AuthStatus authStatus;
  final String? id;
  final String? email;
  final String? surname;
  final String? fullName;

  final String? accessToken;

  final String? errorMessage;

  const UserState({
    required this.authStatus,
    this.id,
    this.email,
    this.surname,
    this.fullName,
    this.accessToken,
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
  ) : this(
        authStatus: AuthStatus.authorized,
        id: id,
        email: email,
        surname: surname,
        fullName: fullName,
        accessToken: accessToken,
      );
}
