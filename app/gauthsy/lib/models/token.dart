import 'package:gauthsy/kernel/database_manager/model.dart';

class Token extends Model {
  String id;
  int expiresIn;
  String tokenType;
  String accessToken;
  String refreshToken;
  String createdAt = DateTime.now().toString();
  String updatedAt = DateTime.now().toString();

  Duration get remainingTime => DateTime.parse(createdAt)
      .add(Duration(seconds: expiresIn))
      .difference(DateTime.now());

  Token(
      {this.id,
      this.expiresIn,
      this.tokenType,
      this.accessToken,
      this.refreshToken,
      this.createdAt,
      this.updatedAt})
      : super((json) => Token.fromJson(json));

  factory Token.fromJson(Map<String, dynamic> json) => Token(
        id: json['id'],
        expiresIn: json['expires_in'],
        tokenType: json['token_type'],
        accessToken: json['access_token'],
        refreshToken: json['refresh_token'],
      );

  Map<String, dynamic> toJson() => jsonWithoutNull({
        "id": id,
        "expires_in": expiresIn,
        "token_type": tokenType,
        "access_token": accessToken,
        "refresh_token": refreshToken,
        "created_at": createdAt,
        "updated_at": updatedAt
      });
}
