import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:food_recipe/core/theme/app_color.dart';
import 'package:food_recipe/feature/home/model/recipe_model.dart';
import 'package:food_recipe/feature/home/presentation/details_page.dart';

import '../../../../db handler/db_handler.dart';

class RecipeItem extends StatelessWidget {
  final Recipe recipe;
  final DatabaseHelper dbHelper = DatabaseHelper();

   RecipeItem({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => RecipeDetailsPage(id:recipe.idMeal),));
        },
        child: SizedBox(
          height: 280,
          width: double.infinity,
          child: Stack(
            children: [
              Container(
                height: 280,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  image: DecorationImage(
                    image: NetworkImage(recipe.strMealThumb.toString()),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                top: 8,
                left: 8,
                /// make a glass effect
                child: ClipRRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: 5,
                      sigmaY: 5,
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColor.black.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        recipe.strMeal.toString(),
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 8,
                left: 8,
                right: 8,

                /// make a glass effect
                child: ClipRRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: 5,
                      sigmaY: 5,
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColor.black.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  recipe.strArea.toString(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(color: Colors.white),
                                  maxLines: 2,
                                ),
                              ),
                              const SizedBox(width: 16),
                              IconButton(
                                icon: Icon(Icons.favorite_border,color: Colors.white,),
                                onPressed: () async {
                                  await dbHelper.insertRecipe(recipe);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Recipe saved!')),
                                  );
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          // Text(
                          //   "${recipe.duration} | ${recipe.serving}",
                          //   style: Theme.of(context)
                          //       .textTheme
                          //       .bodyMedium
                          //       ?.copyWith(color: Colors.white),
                          //   maxLines: 2,
                          // ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
