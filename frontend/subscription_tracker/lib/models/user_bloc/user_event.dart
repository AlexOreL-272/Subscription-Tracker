abstract class UserEvent {}

class UserLogInEvent extends UserEvent {
  final String email;
  final String password;

  UserLogInEvent(this.email, this.password);
}

class UserGoogleAuthEvent extends UserEvent {}

class UserLogOutEvent extends UserEvent {}

class UserRegisterEvent extends UserEvent {
  final String surname;
  final String name;
  final String? middleName;
  final String email;
  final String password;

  UserRegisterEvent(
    this.surname,
    this.name,
    this.middleName,
    this.email,
    this.password,
  );
}

class UserDeleteAccountEvent extends UserEvent {}

class InitializeUserEvent extends UserEvent {}
