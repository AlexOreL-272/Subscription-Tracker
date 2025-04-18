import 'dart:async';
import 'dart:convert' as convert;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:hive/hive.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
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
    on<UserGoogleAuthEvent>(_googleAuth);
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

  Future<void> _googleAuth(
    UserGoogleAuthEvent event,
    Emitter<UserState> emit,
  ) async {
    emit(UserState.pending());

    try {
      const callbackUrlScheme = 'com.wasubi.auth';
      const authUrl = 'http://alexorel.ru/auth?provider=google';

      final result = await FlutterWebAuth2.authenticate(
        url: authUrl,
        callbackUrlScheme: callbackUrlScheme,
      ).timeout(
        const Duration(seconds: 120),
        onTimeout: () {
          throw TimeoutException('Authentication timed out after 2 minutes');
        },
      );

      if (result.isEmpty) {
        throw Exception('Empty response from authentication flow');
      }

      final uri = Uri.parse(result);

      final accessToken = uri.queryParameters['access_token'] ?? '';
      final refreshToken = uri.queryParameters['refresh_token'] ?? '';

      if (accessToken.isEmpty || refreshToken.isEmpty) {
        debugPrint('Available query parameters: ${uri.queryParameters}');
        throw Exception('No valid token found in callback. Received: $result');
      }

      final decodedToken = JwtDecoder.decode(accessToken);
      final id = decodedToken['sub'];

      final userInfo = await apiService.getUserInfo(id);

      if (!userInfo.isSuccessful) {
        throw Exception('Failed to get user info');
      }

      final userState = UserState(
        authStatus: AuthStatus.authorized,
        id: decodedToken['sub'],
        email: userInfo.body!.email,
        surname: userInfo.body!.surname,
        fullName: userInfo.body!.fullName,
        accessToken: accessToken,
        refreshToken: refreshToken,
      );

      await _box.put(_userKey, convert.jsonEncode(userState));

      _saveOperations++;
      if (_saveOperations >= _compactionThreshold) {
        _saveOperations = 0;
        await _box.compact();
      }

      emit(userState);

      return;
    } on PlatformException catch (e) {
      if (e.code == 'CANCELED') {
        debugPrint('User explicitly canceled authentication');
      } else {
        debugPrint('Platform error during authentication: ${e.toString()}');
      }

      emit(UserState.unauthorized());
      rethrow;
    } on TimeoutException catch (e) {
      debugPrint('Authentication timeout: ${e.message}');

      emit(UserState.unauthorized());
      rethrow;
    } catch (e, stackTrace) {
      debugPrint('Authentication failed: $e');
      debugPrint('Stack trace: $stackTrace');

      emit(UserState.unauthorized());
      rethrow;
    }
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
