import 'package:cackecal/models/ingredient.dart';
import 'package:cackecal/database/ingredient_database.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' show join;
class DatabaseHelper implements IngredientDatabase {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  sql.Database? _db;

  Future<sql.Database> get db async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  Future<sql.Database> _initDb() async {
    String path = join(await sql.getDatabasesPath(), 'ingredients.db');
    return await sql.openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
        CREATE TABLE ingredients(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT,
          unitPrice REAL,
          unitQuantity REAL,
          usedQuantity REAL
        )
        ''');
      },
    );
  }

  @override
  Future<int> insertIngredient(Ingredient ingredient) async {
    final dbClient = await db;
    return await dbClient.insert('ingredients', ingredient.toMap(),
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }

  @override
  Future<List<Ingredient>> getIngredients() async {
    final dbClient = await db;
    final List<Map<String, dynamic>> maps = await dbClient.query('ingredients');
    return List.generate(maps.length, (i) => Ingredient.fromMap(maps[i]));
  }

  @override
  Future<int> updateIngredient(Ingredient ingredient) async {
    final dbClient = await db;
    return await dbClient.update(
      'ingredients',
      ingredient.toMap(),
      where: 'id = ?',
      whereArgs: [ingredient.id],
    );
  }

  @override
  Future<int> deleteIngredient(int id) async {
    final dbClient = await db;
    return await dbClient.delete(
      'ingredients',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}