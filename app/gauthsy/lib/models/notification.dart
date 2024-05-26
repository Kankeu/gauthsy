import 'dart:convert';

import 'package:gauthsy/kernel/database_manager/model.dart';
import 'package:gauthsy/models/user.dart';


class Notification extends Model {
  String id;
  String type;
  Map<String, dynamic> data;
  String readAt;
  User notifiable;
  String createdAt;
  String updatedAt;

  String get message => data['message'];

  String get typeText {
    if (type.contains("document.validated")) return "Document validated";
    if (type.contains("document.rejected")) return "Document rejected";
  }

  String get documentId =>
      data['document'] == null ? null : data['document']['id'];

  bool get navigable => type.contains("document");


  Notification(
      {this.id,
      this.type,
      this.data,
      this.readAt,
      this.createdAt,
      this.updatedAt})
      : super((json) => Notification.fromJson(json));

  factory Notification.fromJson(Map<String, dynamic> json) => Notification(
        id: json['id'],
        type: json['type'],
        data: jsonDecode(json['data']),
        readAt: json['read_at'],
        createdAt: json['created_at'],
        updatedAt: json['updated_at'],
      );

  Map<String, dynamic> toJson() => jsonWithoutNull({
        "id": id,
        "type": type,
        "data": data?.toString(),
        "read_at": readAt,
        "notifiable": notifiable?.toJson(),
        "created_at": createdAt,
        "updated_at": updatedAt
      });
}
