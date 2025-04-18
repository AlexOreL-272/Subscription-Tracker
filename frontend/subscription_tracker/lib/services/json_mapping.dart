import 'package:subscription_tracker/dto/auth/login_dto.dart';
import 'package:subscription_tracker/models/subscription_model.dart';

final Map<Type, Object Function(Map<String, dynamic>)> generatedMapping = {
  SubscriptionModel: SubscriptionModel.fromJson,
  LoginDto: LoginDto.fromJson,
  RegisterDto: RegisterDto.fromJson,
  UserDto: UserDto.fromJson,
};
