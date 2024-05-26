import 'package:gauthsy/config/config.dart';
import 'package:gauthsy/graphql/graphql.dart';
import 'package:gauthsy/kernel/database_manager/model.dart';

class Image extends Model {
  String table = 'images';

  String id;
  bool resized;
  String path;
  String createdAt;
  String updatedAt;

  String type;

  Image({this.id, this.resized,this.type, this.path, this.createdAt, this.updatedAt})
      : super((json) => Image.fromJson(json));

  String get fullPath => path.contains("http") ? path : Config.appUrl + path;


  factory Image.fromJson(Map<String, dynamic> json, [String dir = '']) => Image(
      id: json['id'],
      resized: json['resized'] == null ? false : json['resized'],
      type: json['type'],
      path: json['path'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at']);

  Map<String, dynamic> toJson() => {
        "id": id,
        "resized": resized,
        "type": type,
        "path": path,
        "created_at": createdAt,
        "updated_at": updatedAt
      };
}
