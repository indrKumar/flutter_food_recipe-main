import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:food_recipe/core/theme/app_color.dart';
import 'package:food_recipe/feature/home/model/details_model.dart';

class RecipeDetailsItem extends StatelessWidget {
  final RecipeDetails recipe;
  const RecipeDetailsItem({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: GestureDetector(
        onTap: () {
        },
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: 5,
                    sigmaY: 5,
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColor.black.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      recipe.strMeal.toString(),
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(color: Colors.black),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30,),
              SizedBox(
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
                                    const Icon(
                                      Icons.bookmark_outline,
                                      size: 20,
                                      color: Colors.white,
                                    )
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
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20,),
              Text(
                "Recipe",
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(color: AppColor.black),
              ),
              SizedBox(height:10,),
              Text(recipe.strInstructions,
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(color: AppColor.black),
              )
            ],
          ),
        ),
      ),
    );
  }
}
