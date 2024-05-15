import 'dart:convert';
import 'package:http/http.dart' as http;
import '../feature/home/model/details_model.dart';
import '../feature/home/model/recipe_model.dart';

class ApiException implements Exception {
  final String message;
  ApiException(this.message);

  @override
  String toString() {
    return message;
  }
}

class RecipeApi {
  static Future<List<Recipe>> getRecipe({int page = 1, int pageSize = 20}) async {
    var request = http.Request('GET', Uri.parse('http://www.themealdb.com/api/json/v1/1/search.php?f=c'));

    try {
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(await response.stream.bytesToString());
        List<dynamic> meals = data['meals'];

        if (meals != null) {
          return meals.map((meal) => Recipe.fromJson(meal)).toList();
        } else {
          throw ApiException('No recipes found.');
        }
      } else {
        throw ApiException('Failed to load recipes. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw ApiException('An error occurred while fetching recipes: $e');
    }
  }

  static Future<List<RecipeDetails>> getDetails({String? id}) async {
    final uri = Uri.parse('http://www.themealdb.com/api/json/v1/1/lookup.php?i=$id');
    final request = http.Request('GET', uri);

    try {
      final response = await request.send();

      if (response.statusCode == 200) {
        final data = jsonDecode(await response.stream.bytesToString());
        final meals = data['meals'] as List<dynamic>;

        if (meals != null) {
          return meals.map((meal) => RecipeDetails.fromJson(meal as Map<String, dynamic>)).toList();
        } else {
          throw ApiException('No recipe details found.');
        }
      } else {
        throw ApiException('Failed to load recipe details. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw ApiException('An error occurred while fetching recipe details: $e');
    }
  }
}