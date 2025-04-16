import 'dart:convert' as convert;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:subscription_tracker/dto/auth/login_dto.dart';
import 'package:subscription_tracker/models/user_bloc/user_event.dart';
import 'package:subscription_tracker/models/user_bloc/user_state.dart';
import 'package:subscription_tracker/services/subs_api_service.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  static const _boxName = 'userBox';
  static const _userKey = 'userKey';

  late final Box<String> _box;

  static const _compactionThreshold = 10;
  int _saveOperations = 0;

  final apiService = SubsApiService.create();

  UserBloc() : super(UserState.unauthorized()) {
    on<InitializeUserEvent>(_initialize);
    on<UserLogInEvent>(_logIn);
    on<UserLogOutEvent>(_logOut);
    on<UserDeleteAccountEvent>(_deleteAccount);
    on<UserRegisterEvent>(_register);

    add(InitializeUserEvent());
  }

  Future<void> _initialize(
    InitializeUserEvent event,
    Emitter<UserState> emit,
  ) async {
    _box = await Hive.openBox(_boxName);
    final userString = _box.get(_userKey);

    if (userString != null) {
      final user = UserState.fromJson(convert.jsonDecode(userString));

      emit(user);
    }
  }

  Future<void> _logIn(UserLogInEvent event, Emitter<UserState> emit) async {
    emit(UserState.pending());

    final loginResponse = await apiService.login(
      loginRequest: LoginRequestDto(
        email: event.email,
        password: event.password,
      ),
    );

    await Future.delayed(const Duration(seconds: 1));

    if (!loginResponse.isSuccessful) {
      emit(
        UserState.error(
          '${loginResponse.statusCode} ${loginResponse.error.toString()}',
        ),
      );

      return;
    }

    final userInfoResponse = await apiService.getUserInfo(
      loginResponse.body!.id,
    );

    if (!userInfoResponse.isSuccessful) {
      emit(
        UserState.error(
          '${userInfoResponse.statusCode} ${userInfoResponse.error.toString()}',
        ),
      );

      return;
    }

    final authorizedUserState = UserState.authorized(
      loginResponse.body!.id,
      userInfoResponse.body!.email,
      userInfoResponse.body!.surname,
      userInfoResponse.body!.fullName,
      loginResponse.body!.accessToken,
      loginResponse.body!.refreshToken,
    );

    await _box.put(_userKey, convert.jsonEncode(authorizedUserState));

    _saveOperations++;
    if (_saveOperations >= _compactionThreshold) {
      _saveOperations = 0;
      await _box.compact();
    }

    emit(authorizedUserState);
  }

  Future<void> _logOut(UserLogOutEvent event, Emitter<UserState> emit) async {
    if (state.authStatus != AuthStatus.authorized) {
      return;
    }

    await _box.delete(_userKey);

    _saveOperations++;
    if (_saveOperations >= _compactionThreshold) {
      _saveOperations = 0;
      await _box.compact();
    }

    emit(UserState.unauthorized());
  }

  Future<void> _deleteAccount(
    UserDeleteAccountEvent event,
    Emitter<UserState> emit,
  ) async {
    if (state.authStatus != AuthStatus.authorized) {
      return;
    }
  }

  Future<void> _register(
    UserRegisterEvent event,
    Emitter<UserState> emit,
  ) async {
    emit(UserState.pending());

    final fullName =
        event.middleName == null
            ? event.name
            : '${event.name} ${event.middleName}';

    final registerResponse = await apiService.register(
      registerRequest: RegisterRequestDto(
        fullName: fullName,
        surname: event.surname,
        email: event.email,
        password: event.password,
      ),
    );

    await Future.delayed(const Duration(seconds: 1));

    if (!registerResponse.isSuccessful) {
      emit(
        UserState.error(
          '${registerResponse.statusCode} ${registerResponse.error.toString()}',
        ),
      );

      return;
    }

    add(UserLogInEvent(event.email, event.password));
  }

  @override
  Future<void> close() {
    _box.close();
    return super.close();
  }
}
