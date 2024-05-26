part of database;

class Migrations{
  static Future<bool> make(Sqflite.Database pdo) async{
    await pdo.execute(
        "CREATE TABLE users(id VARCHAR(255) UNIQUE PRIMARY KEY, surname VARCHAR(255), forename VARCHAR(255), email VARCHAR(255), created_at TEXT, updated_at TEXT, is_account INTEGER, is_active INTEGER, email_verified_at TEXT)");
    print("Users table created");
    await pdo.execute(
        "CREATE TABLE tokens(id VARCHAR(255) UNIQUE PRIMARY KEY, access_token TEXT, refresh_token TEXT, expires_in INTEGER, token_type VARCHAR(255), created_at TEXT, updated_at TEXT, FOREIGN KEY(id) REFERENCES users(id)  ON DELETE CASCADE )");
    print("Tokens table created");
    return true;
  }

  static Future<bool> truncateAll(Sqflite.Database pdo) async{
    await pdo.execute(
        "DELETE FROM users");
    print("Users table truncated");
    await pdo.execute(
        "DELETE FROM tokens");
    print("Tokens table truncated");
    return true;
  }
}