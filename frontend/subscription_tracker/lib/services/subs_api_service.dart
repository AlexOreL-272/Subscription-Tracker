import 'dart:async';

import 'package:chopper/chopper.dart';
import 'package:subscription_tracker/domain/subscriptions/requests.dart';
import 'package:subscription_tracker/dto/auth/login_dto.dart';
import 'package:subscription_tracker/dto/subscriptions/subscriptions_dto.dart';
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

  @POST(path: '/subscriptions')
  Future<Response<CreateSubscriptionDto>> createSubscription({
    // @Header('Authorization') required String authorization,
    @Body() required CreateSubscriptionRequest request,
  });

  @PUT(path: '/subscriptions/{subscriptionId}')
  Future<Response<UpdateSubscriptionDto>> updateSubscription({
    // @Header('Authorization') required String authorization,
    @Path('subscriptionId') required String subscriptionId,
    @Body() required SubscriptionModel subscription,
  });

  @DELETE(path: '/subscriptions/{subscriptionId}')
  Future<Response<String>> deleteSubscription({
    // @Header('Authorization') required String authorization,
    @Path('subscriptionId') required String subscriptionId,
  });

  @GET(path: '/users/{userId}')
  Future<Response<UserDto>> getUserInfo(@Path('userId') String userId);
}
