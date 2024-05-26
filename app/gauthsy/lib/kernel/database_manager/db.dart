part of database_manager;

typedef Fun<E> = E Function(Map<String, dynamic> a);

class DB {
  List _select = [];
  String _from;
  List _where = [];
  List<String> _order;
  String _limit;
  List _keys = [];
  List _values = [];
  bool _isCreate = false;
  bool _isUpdate = false;
  bool _isDelete = false;
  final Database pdo;
  DB(this.pdo);
  DB from(String from) {
    this._from = from;
    return this;
  }

  DB select([List fields]) {
    if (fields == null) fields = ["*"];
    fields.forEach((field) => this._select.add(field));
    return this;
  }

  DB where(String field, [String operator, String values]) {
    if (values == null) {
      values = operator;
      operator = "=";
    }
    this._where.add("$field$operator'$values'");
    return this;
  }

  DB whereRaw(String field, [String operator, String values]) {
    if (values == null) {
      values = operator;
      operator = "=";
    }
    this._where.add("$field$operator$values");
    return this;
  }

  DB limit(String limit) {
    this._limit = limit;
    return this;
  }

  DB orderBy(String field, String order) {
    this._order = [field, order];
    return this;
  }

  DB all() {
    this._select = ["*"];
    return this;
  }

  DB create(Map<String, dynamic> data) {
    this._isCreate = true;
    this._keys = data.keys.toList();
    this._values = data.values.toList();
    return this;
  }

  DB update(Map<String, dynamic> data) {
    this._isUpdate = true;
    this._keys = data.keys.toList();
    this._values = data.values.toList();
    return this;
  }

  DB delete() {
    this._isDelete = true;
    return this;
  }

  Future<List<Map<String, dynamic>>> execute<E>([Fun<E> _fromJson]) async {
    var pdo = this.pdo;
    List<Map<String, dynamic>> result = await pdo.rawQuery(this.toString());
    this.clear();
    return result;
  }

  @override
  String toString() {
    List parts = [];
    if (this._select.isNotEmpty) {
      parts = this._makeSelect(parts);
    } else if (this._isCreate) {
      parts = this._makeCreate(parts);
    } else if (this._isUpdate) {
      parts = this._makeUpdate(parts);
    } else if (this._isDelete) {
      parts = this.makeDelete(parts);
    }

    return parts.join(" ");
  }

  List _makeSelect(parts) {
    parts.add("SELECT");
    parts.add(this._select.join(", "));
    if (this._from != null) {
      parts.add("FROM");
      parts.add(this._from);
    }
    if (this._where.isNotEmpty) {
      parts.add("WHERE");
      parts.add("(${this._where.join(') AND (')})");
    }
    if (this._order != null) {
      parts.add("ORDER BY");
      parts.add("${this._order[0]} ${this._order[1]}");
    }
    if (this._limit != null) {
      parts.add("LIMIT");
      parts.add(this._limit);
    }
    return parts;
  }

  List _makeCreate(List parts) {
    parts.add("INSERT INTO");
    parts.add(this._from);
    parts.add("(${this._keys.join(', ')})");
    parts.add("VALUES");
    parts.add("('${this._values.join('\', \'')}')");
    return parts;
  }

  List _makeUpdate(List parts) {
    parts.add("UPDATE");
    parts.add(this._from);
    parts.add("SET");
    Iterable data = this
        ._keys
        .asMap()
        .map((index, key) => MapEntry(index, "$key='${this._values[index]}'"))
        .values;
    parts.add(data.join(", "));
    parts.add("WHERE");
    parts.add("(${this._where.join(') AND (')})");
    return parts;
  }

  List makeDelete(List parts) {
    parts.add("DELETE");
    parts.add("FROM");
    parts.add(this._from);
    if (this._where.isNotEmpty) {
      parts.add("WHERE");
      parts.add("(${this._where.join(') AND (')})");
    }
    if (this._limit != null) {
      parts.add("LIMIT");
      parts.add(this._limit);
    }
    return parts;
  }

  void clear() {
    _select = [];
    _from = null;
    _where = [];
    _order = null;
    _limit = null;
    _keys = [];
    _values = [];
    _isCreate = false;
    _isUpdate = false;
    _isDelete = false;
  }
}
