import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:subscription_tracker/dto/auth/login_dto.dart';
import 'package:subscription_tracker/models/user_bloc/user_event.dart';
import 'package:subscription_tracker/models/user_bloc/user_state.dart';
import 'package:subscription_tracker/services/subs_api_service.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  static const _boxName = 'userBox';

  // late final Box<List> _box;

  // static const _compactionThreshold = 100;
  // int _saveOperations = 0;

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
  ) async {}

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

    emit(
      UserState.authorized(
        loginResponse.body!.id,
        userInfoResponse.body!.email,
        userInfoResponse.body!.surname,
        userInfoResponse.body!.fullName,
        loginResponse.body!.accessToken,
      ),
    );
  }

  Future<void> _logOut(UserLogOutEvent event, Emitter<UserState> emit) async {
    emit(UserState.unauthorized());
  }

  Future<void> _deleteAccount(
    UserDeleteAccountEvent event,
    Emitter<UserState> emit,
  ) async {}

  Future<void> _register(
    UserRegisterEvent event,
    Emitter<UserState> emit,
  ) async {}

  @override
  Future<void> close() {
    // Hive.close();
    return super.close();
  }
}
