import 'package:flutter/material.dart';
import 'package:food_recipe/feature/home/model/recipe_model.dart';

import '../../../db handler/db_handler.dart';
import 'details_page.dart';

class FavouriteRecipesScreen extends StatefulWidget {
  @override
  _FavouriteRecipesScreenState createState() => _FavouriteRecipesScreenState();
}

class _FavouriteRecipesScreenState extends State<FavouriteRecipesScreen> {
  final DatabaseHelper dbHelper = DatabaseHelper();
  List<Recipe> _likedRecipes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadLikedRecipes();
  }

  Future<void> _loadLikedRecipes() async {
    final recipes = await dbHelper.getRecipes();
    setState(() {
      _likedRecipes = recipes;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Liked Recipes')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        shrinkWrap: true,
        itemCount: _likedRecipes.length,
        itemBuilder: (context, index) {
          final recipe = _likedRecipes[index];
          return ListTile(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => RecipeDetailsPage(id:recipe.idMeal),));
            },
            leading: Image.network(recipe.strMealThumb),
            title: Text(recipe.strMeal),
            subtitle: Text('${recipe.strCategory} - ${recipe.strArea}'),
            trailing: IconButton(onPressed: () {
              DatabaseHelper().deleteRecipe(recipe.idMeal);
              _loadLikedRecipes();
            }, icon: Icon(Icons.delete)),
          );
        },
      ),
    );
  }
}
