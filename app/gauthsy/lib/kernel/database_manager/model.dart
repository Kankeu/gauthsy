library database_manager;

import 'dart:async';
import 'dart:core';
import 'package:gauthsy/auth_manager/auth_manager.dart';
import 'package:gauthsy/kernel/container/container.dart';
import 'package:gauthsy/kernel/json_parser/json_parsable.dart';
import 'package:sqflite/sqflite.dart';

part 'db.dart';

part 'key_value.dart';

class Model<E> with JsonParsable, JsonHelpable<Map<String, dynamic>> {
  DB get db {
    try {
      if (_db != null) return _db;
      _db = DB(Container().get("pdo"));
      return _db;
    } catch (e) {
      return null;
    }
  }

  set db(DB v) => _db = v;

  DB _db;

  String view = "";

  String table;
  String id;

  List<String> get fillable => null;

  Fun<E> _fromJson;

  Model([Fun<E> _fromJson]) {
    this._fromJson = (json) {
      if (json.containsKey('id')) json['id'] = json['id'].toString();
      return _fromJson(json);
    };
    if (this.table == null) this.table = this.getTableByClassName();
  }

  Future find(int id) async {
    List response = await this
        .db
        .from(this.table)
        .where("id", "$id")
        .select()
        .execute<E>(_fromJson);
    return this._fromJson(response[0]);
  }

  Model where(String field, [String operator, String values]) {
    this.db = this.db.where(field, operator, values);
    return this;
  }

  Future<bool> update(Map<String, dynamic> data) async {
    await this.db.from(this.table).update(filters(data)).execute();
    return true;
  }

  Model whereRaw(String field, [String operator, String values]) {
    this.db = this.db.whereRaw(field, operator, values);
    return this;
  }

  Model orderBy(String field, [String order = "ASC"]) {
    this.db = this.db.orderBy(field, order);
    return this;
  }

  Model limit(String limit) {
    this.db = this.db.limit(limit);
    return this;
  }

  Future<List> get([List fields]) async {
    List response =
        await this.db.from(this.table).select(fields).execute<E>(_fromJson);
    response = response.map((res) => dataParser(res)).toList();
    return response.map((row) => this._fromJson(row)).toList();
  }

  Future<dynamic> first([List fields]) async {
    List response = await this
        .db
        .from(this.table)
        .limit("1")
        .select(fields)
        .execute<E>(_fromJson);
    response = response.map((res) => dataParser(res)).toList();
    if (response.isEmpty) return null;
    return this._fromJson(response[0]);
  }

  String getTableByClassName() {
    return this.runtimeType.toString().toLowerCase() + "s";
  }

  Future delete() {
    return this
        .db
        .from(this.table)
        .where("id", "${this.id}")
        .limit("1")
        .execute<E>(_fromJson);
  }

  Map<String, dynamic> filters(Map<String, dynamic> json) {
    if (fillable == null) return json;
    var tmp = Map<String, dynamic>();
    fillable.forEach((e) {
      if(json.containsKey(e))
      tmp[e] = json[e];
    });
    return tmp;
  }

  Future<bool> save() async {
    await this.destroy();
    var data = this.toJson();
    await this.db.from(this.table).create(filters(data)).execute();
    return true;
  }

  Future<bool> destroy() async {
    await this.db.from(this.table).where("id", "${this.id}").delete().execute();
    return true;
  }

  Map<String, dynamic> toJson() {}

  static int getTotal(Map<String, dynamic> data) {
    if (data == null || !(data is Map) || data['paginatorInfo'] == null)
      return null;
    return data['paginatorInfo']['total'];
  }

  bool animated = false;
}
