import 'package:flutter/material.dart';
import 'package:food_recipe/Apis/api.dart';
import 'package:food_recipe/core/theme/app_color.dart';
import 'package:food_recipe/feature/home/model/details_model.dart';
import 'package:food_recipe/feature/home/model/recipe_model.dart';
import 'package:food_recipe/feature/home/presentation/widget/recipe_dettails.dart';

import 'package:food_recipe/feature/home/presentation/widget/recipe_item.dart';

class RecipeDetailsPage extends StatefulWidget {
  String? id;
   RecipeDetailsPage({super.key,this.id});

  @override
  State<RecipeDetailsPage> createState() => _RecipeDetailsPageState();
}

class _RecipeDetailsPageState extends State<RecipeDetailsPage> {
  List<RecipeDetails> _recipeDetails = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    getRecipes();
  }

  Future<void> getRecipes() async {
    try {
      _recipeDetails = await RecipeApi.getDetails(id: widget.id.toString());
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching recipes: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        title:  Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            "Recipe Details",
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(color: AppColor.primaryColor),
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator()):SingleChildScrollView(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 24,
          bottom: MediaQuery.of(context).padding.bottom + 24,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _recipeDetails.length,
              // scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              separatorBuilder: (_, __) {
                return const SizedBox(width: 16);
              },
              itemBuilder: (context, index) {
                final recipe = _recipeDetails[index];
                return RecipeDetailsItem(recipe: recipe);
              },
            ),
          ],
        ),
      ),
    );
  }
}
