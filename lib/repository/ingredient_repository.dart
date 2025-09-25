import 'package:cackecal/models/ingredient.dart';
import 'package:cackecal/database/ingredient_database.dart';
class IngredientRepository {
  final IngredientDatabase _database;

  IngredientRepository(this._database);

  Future<void> initializeDefaultData() async {
    final ingredients = await getIngredients();
    if (ingredients.isEmpty) {
      await insertIngredient(Ingredient(name: "طحين", unitPrice: 100, unitQuantity: 10));
      await insertIngredient(Ingredient(name: "سكر", unitPrice: 80, unitQuantity: 5));
      await insertIngredient(Ingredient(name: "زيت", unitPrice: 200, unitQuantity: 20));
    }
  }

  Future<int> insertIngredient(Ingredient ingredient) =>
      _database.insertIngredient(ingredient);

  Future<List<Ingredient>> getIngredients() => _database.getIngredients();

  Future<int> updateIngredient(Ingredient ingredient) =>
      _database.updateIngredient(ingredient);

  Future<int> deleteIngredient(int id) => _database.deleteIngredient(id);
}