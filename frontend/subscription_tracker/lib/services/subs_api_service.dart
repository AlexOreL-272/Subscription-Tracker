import 'dart:async';

import 'package:chopper/chopper.dart';
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

  @GET(path: '/subscriptions')
  Future<Response<List<SubscriptionModel>>> getSubscriptions({
    @Query('user_id') required String userId,
    @Query('result_type') required String resultType,
    @Query('category') String? category,
    @Query('limit') int? limit,
    @Query('offset') int? offset,
  });
}
