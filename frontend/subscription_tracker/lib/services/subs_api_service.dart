import 'dart:async';

import 'package:chopper/chopper.dart';
import 'package:subscription_tracker/dto/auth/login_dto.dart';
import 'package:subscription_tracker/models/subscription_model.dart';
import 'package:subscription_tracker/services/json_converter.dart';

part 'subs_api_service.chopper.dart';

@ChopperApi(baseUrl: 'http://alexorel.ru')
abstract class SubsApiService extends ChopperService {
  static SubsApiService create() {
    final client = ChopperClient(
      services: [_$SubsApiService()],
      converter: $JsonSerializableConverter(),
    );
    return _$SubsApiService(client);
  }

  @POST(path: '/login')
  Future<Response<LoginDto>> login({
    @Body() required LoginRequestDto loginRequest,
  });

  @POST(path: '/register')
  Future<Response<RegisterDto>> register({
    @Body() required RegisterRequestDto registerRequest,
  });

  @GET(path: '/subscriptions')
  Future<Response<List<SubscriptionModel>>> getSubscriptions({
    @Query('user_id') required String userId,
    @Query('result_type') required String resultType,
    @Query('category') String? category,
    @Query('limit') int? limit,
    @Query('offset') int? offset,
  });

  @GET(path: '/users/{userId}')
  Future<Response<UserDto>> getUserInfo(@Path('userId') String userId);
}
