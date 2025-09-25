import 'package:cackecal/models/ingredient.dart';
abstract class IngredientDatabase {
  Future<int> insertIngredient(Ingredient ingredient);
  Future<List<Ingredient>> getIngredients();
  Future<int> updateIngredient(Ingredient ingredient);
  Future<int> deleteIngredient(int id);
}