import 'package:gauthsy/kernel/database_manager/model.dart';

class User<E> extends Model<User> {
  String id;
  String surname;
  String forename;
  String email;
  String createdAt;
  String updatedAt;

  String get fullName => forename + " " + surname;

  User({this.id,
    this.surname,
    this.email,
    this.forename,
    this.createdAt,
    this.updatedAt,
    Fun<E> fromJson})
      : super(fromJson ?? (json) => User.fromJson(json));

  @override
  factory User.fromJson(Map<String, dynamic> json) =>
      User(
        id: json['id'],
        surname: json['surname'],
        forename: json['forename'],
        email: json['email'],
        createdAt: json['created_at'],
        updatedAt: json['updated_at'],
      );

  Map<String, dynamic> toJson() =>
      jsonWithoutNull({
        'id': id,
        'surname': surname,
        'email': email,
        'forename': forename,
        'created_at': createdAt,
        'updated_at': updatedAt,
      });
}
