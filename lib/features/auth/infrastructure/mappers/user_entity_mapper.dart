import '../../domain/entities/user_entity.dart';

class UserEntityMapper {
  static userJsonToEntity(Map<String, dynamic> json) => UserEntity(
        id: json["id"],
        email: json["email"],
        name: json["name"],
        fullName: json["fullName"],
        roles: List<String>.from(json["roles"].map((role) => role)),
        token: json["token"],
      );
}
