// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subs_api_service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$SubsApiService extends SubsApiService {
  _$SubsApiService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = SubsApiService;

  @override
  Future<Response<LoginDto>> login({required LoginRequestDto loginRequest}) {
    final Uri $url = Uri.parse('http://alexorel.ru/login');
    final $body = loginRequest;
    final Request $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<LoginDto, LoginDto>($request);
  }

  @override
  Future<Response<RegisterDto>> register({
    required RegisterRequestDto registerRequest,
  }) {
    final Uri $url = Uri.parse('http://alexorel.ru/register');
    final $body = registerRequest;
    final Request $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<RegisterDto, RegisterDto>($request);
  }

  @override
  Future<Response<List<SubscriptionModel>>> getSubscriptions({
    required String userId,
    required String resultType,
    String? category,
    int? limit,
    int? offset,
  }) {
    final Uri $url = Uri.parse('http://alexorel.ru/subscriptions');
    final Map<String, dynamic> $params = <String, dynamic>{
      'user_id': userId,
      'result_type': resultType,
      'category': category,
      'limit': limit,
      'offset': offset,
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<List<SubscriptionModel>, SubscriptionModel>($request);
  }

  @override
  Future<Response<UserDto>> getUserInfo(String userId) {
    final Uri $url = Uri.parse('http://alexorel.ru/users/${userId}');
    final Request $request = Request('GET', $url, client.baseUrl);
    return client.send<UserDto, UserDto>($request);
  }
}
