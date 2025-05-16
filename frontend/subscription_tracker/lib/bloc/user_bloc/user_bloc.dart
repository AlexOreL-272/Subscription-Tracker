import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:subscription_tracker/bloc/user_bloc/user_event.dart';
import 'package:subscription_tracker/bloc/user_bloc/user_state.dart';
import 'package:subscription_tracker/repo/user_repo/user_repo.dart';
import 'package:subscription_tracker/services/subs_api_service.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepo userRepo;
  final SubsApiService apiService;

  UserBloc({required this.userRepo, required this.apiService})
    : super(UserState.unauthorized()) {
    on<InitializeUserEvent>(_initialize);
    on<UserLogInEvent>(_logIn);
    on<UserGoogleAuthEvent>(_googleAuth);
    on<UserYandexAuthEvent>(_yandexAuth);
    on<UserLogOutEvent>(_logOut);
    on<UserDeleteAccountEvent>(_deleteAccount);
    on<UserRegisterEvent>(_register);

    add(InitializeUserEvent());
  }

  Future<void> _initialize(
    InitializeUserEvent event,
    Emitter<UserState> emit,
  ) async {
    emit(userRepo.user);
  }

  Future<void> _logIn(UserLogInEvent event, Emitter<UserState> emit) async {
    emit(UserState.pending());

    await userRepo.login(email: event.email, password: event.password);

    emit(userRepo.user);
  }

  Future<void> _googleAuth(
    UserGoogleAuthEvent event,
    Emitter<UserState> emit,
  ) async {
    emit(UserState.pending());

    await userRepo.googleAuth();

    emit(userRepo.user);
  }

  Future<void> _yandexAuth(
    UserYandexAuthEvent event,
    Emitter<UserState> emit,
  ) async {
    emit(UserState.pending());

    await userRepo.yandexAuth();

    emit(userRepo.user);
  }

  Future<void> _logOut(UserLogOutEvent event, Emitter<UserState> emit) async {
    await userRepo.logOut();
    emit(userRepo.user);
  }

  Future<void> _deleteAccount(
    UserDeleteAccountEvent event,
    Emitter<UserState> emit,
  ) async {
    await userRepo.deleteAccount();
    emit(userRepo.user);
  }

  Future<void> _register(
    UserRegisterEvent event,
    Emitter<UserState> emit,
  ) async {
    emit(UserState.pending());

    final fullName = '${event.name} ${event.middleName}'.trim();

    await userRepo.register(
      fullName: fullName,
      surname: event.surname,
      email: event.email,
      password: event.password,
    );

    add(UserLogInEvent(event.email, event.password));
  }

  @override
  Future<void> close() async {
    await userRepo.close();
    return super.close();
  }
}
