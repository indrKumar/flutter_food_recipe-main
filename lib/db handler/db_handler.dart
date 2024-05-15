// database_helper.dart
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../feature/home/model/recipe_model.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'recipes.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE recipes (
            idMeal TEXT PRIMARY KEY,
            strMeal TEXT,
            strDrinkAlternate TEXT,
            strCategory TEXT,
            strArea TEXT,
            strMealThumb TEXT
          )
        ''');
      },
    );
  }

  Future<void> insertRecipe(Recipe recipe) async {
    final db = await database;
    await db.insert(
      'recipes',
      recipe.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Recipe>> getRecipes() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('recipes');

    return List.generate(maps.length, (i) {
      return Recipe.fromJson(maps[i]);
    });
  }

  Future<void> deleteRecipe(String idMeal) async {
    final db = await database;
    await db.delete(
      'recipes',
      where: 'idMeal = ?',
      whereArgs: [idMeal],
    );
  }
}
