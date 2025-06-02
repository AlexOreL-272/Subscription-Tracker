import 'dart:async';
import 'dart:convert' as convert;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:hive/hive.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:subscription_tracker/dto/auth/login_dto.dart';
import 'package:subscription_tracker/bloc/user_bloc/user_state.dart';
import 'package:subscription_tracker/services/subs_api_service.dart';

class UserRepo {
  static const _boxName = 'userBox';
  static const _userKey = 'userKey';

  late final Box<String> _box;

  static const _compactionThreshold = 10;
  int _saveOperations = 0;

  UserState _state;
  final SubsApiService apiService;

  UserRepo({required this.apiService}) : _state = UserState.unauthorized();

  Future<void> init() async {
    _box = await Hive.openBox<String>(_boxName);
    final userString = _box.get(_userKey);

    if (userString != null) {
      _state = UserState.fromJson(convert.jsonDecode(userString));
    }
  }

  Future<void> close() async {
    await _box.compact();
    await _box.close();
  }

  Future<void> login({required String email, required String password}) async {
    _state = UserState.pending();

    final loginResponse = await apiService.login(
      loginRequest: LoginRequestDto(email: email, password: password),
    );

    if (!loginResponse.isSuccessful) {
      _state = UserState.error(
        'Login failed: ${loginResponse.statusCode} ${loginResponse.error.toString()}',
      );

      return;
    }

    final userInfoResponse = await apiService.getUserInfo(
      loginResponse.body!.id,
    );

    if (!userInfoResponse.isSuccessful) {
      _state = UserState.error(
        '${userInfoResponse.statusCode} ${userInfoResponse.error.toString()}',
      );

      return;
    }

    _state = UserState.authorized(
      loginResponse.body!.id,
      userInfoResponse.body!.email,
      userInfoResponse.body!.surname,
      userInfoResponse.body!.fullName,
      loginResponse.body!.accessToken,
      loginResponse.body!.refreshToken,
    );

    await _box.put(_userKey, convert.jsonEncode(_state));

    _saveOperations++;
    if (_saveOperations >= _compactionThreshold) {
      _saveOperations = 0;
      await _box.compact();
    }
  }

  Future<void> googleAuth() async {
    _state = UserState.pending();

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

      _state = UserState(
        authStatus: AuthStatus.authorized,
        id: decodedToken['sub'],
        email: userInfo.body!.email,
        surname: userInfo.body!.surname,
        fullName: userInfo.body!.fullName,
        accessToken: accessToken,
        refreshToken: refreshToken,
      );

      await _box.put(_userKey, convert.jsonEncode(_state));

      _saveOperations++;
      if (_saveOperations >= _compactionThreshold) {
        _saveOperations = 0;
        await _box.compact();
      }
    } on PlatformException catch (e) {
      if (e.code == 'CANCELED') {
        debugPrint('User explicitly canceled authentication');
        _state = UserState.error('User explicitly canceled authentication');
      } else {
        debugPrint('Platform error during authentication: ${e.toString()}');
        _state = UserState.error('Platform error during authentication');
      }
    } on TimeoutException catch (e) {
      debugPrint('Authentication timeout: ${e.message}');

      _state = UserState.error('Authentication timeout');
    } catch (e, stackTrace) {
      debugPrint('Authentication failed: $e');
      debugPrint('Stack trace: $stackTrace');

      _state = UserState.error('Authentication failed');
    }
  }

  Future<void> yandexAuth() async {
    _state = UserState.pending();

    try {
      const callbackUrlScheme = 'com.wasubi.auth';
      const authUrl = 'http://alexorel.ru/yandex/login';

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

      _state = UserState(
        authStatus: AuthStatus.authorized,
        id: decodedToken['sub'],
        email: userInfo.body!.email,
        surname: userInfo.body!.surname,
        fullName: userInfo.body!.fullName,
        accessToken: accessToken,
        refreshToken: refreshToken,
      );

      await _box.put(_userKey, convert.jsonEncode(_state));

      _saveOperations++;
      if (_saveOperations >= _compactionThreshold) {
        _saveOperations = 0;
        await _box.compact();
      }
    } on PlatformException catch (e) {
      if (e.code == 'CANCELED') {
        debugPrint('User explicitly canceled authentication');
        _state = UserState.error('User explicitly canceled authentication');
      } else {
        debugPrint('Platform error during authentication: ${e.toString()}');
        _state = UserState.error('Platform error during authentication');
      }
    } on TimeoutException catch (e) {
      debugPrint('Authentication timeout: ${e.message}');

      _state = UserState.error('Authentication timeout');
    } catch (e, stackTrace) {
      debugPrint('Authentication failed: $e');
      debugPrint('Stack trace: $stackTrace');

      _state = UserState.error('Authentication failed');
    }
  }

  Future<void> logOut() async {
    if (_state.authStatus != AuthStatus.authorized) {
      return;
    }

    await _box.delete(_userKey);

    _saveOperations++;
    if (_saveOperations >= _compactionThreshold) {
      _saveOperations = 0;
      await _box.compact();
    }

    _state = UserState.unauthorized();
  }

  Future<void> deleteAccount() async {
    if (_state.authStatus != AuthStatus.authorized) {
      return;
    }

    _state = UserState.unauthorized();
  }

  Future<void> register({
    required String fullName,
    required String surname,
    required String email,
    required String password,
  }) async {
    _state = UserState.pending();

    final registerResponse = await apiService.register(
      registerRequest: RegisterRequestDto(
        fullName: fullName,
        surname: surname,
        email: email,
        password: password,
      ),
    );

    if (!registerResponse.isSuccessful) {
      _state = UserState.error(
        'Register failed: ${registerResponse.statusCode} ${registerResponse.error.toString()}',
      );

      return;
    }
  }

  UserState get user => _state;
}
