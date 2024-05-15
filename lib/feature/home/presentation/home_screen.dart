import 'package:flutter/material.dart';
import 'package:food_recipe/Apis/api.dart';
import 'package:food_recipe/core/theme/app_color.dart';
import 'package:food_recipe/feature/home/model/recipe_model.dart';
import 'package:food_recipe/feature/home/presentation/favourite.dart';
import 'package:food_recipe/feature/home/presentation/widget/recipe_item.dart';

import '../../../core/route/app_route_name.dart';

class HomeScrenn extends StatefulWidget {
  const HomeScrenn({super.key});

  @override
  State<HomeScrenn> createState() => _HomeScrennState();
}

class _HomeScrennState extends State<HomeScrenn> {
  List<Recipe> _recipes = [];
  List<Recipe> _filteredRecipes = [];
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';  bool _isFetchingMore = false;
  final _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  int _currentPage = 1;
  final int _pageSize = 20;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    getRecipes();
  }

  Future<void> getRecipes() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
      _errorMessage = '';
    });

    try {
      _recipes = await RecipeApi.getRecipe();
      _filteredRecipes = _recipes;
    } catch (e) {
      setState(() {
        _hasError = true;
        _errorMessage = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> fetchMoreRecipes() async {
    if (_isFetchingMore) return;
    setState(() {
      _isFetchingMore = true;
    });
    _currentPage++;
    List<Recipe> moreRecipes = await RecipeApi.getRecipe(page: _currentPage, pageSize: _pageSize);
    setState(() {
      _isFetchingMore = false;
      _recipes.addAll(moreRecipes);
      _filteredRecipes = _recipes;
    });
  }

  void _scrollListener() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      fetchMoreRecipes();
    }
  }

  void _filterRecipes(String query) {
    if (query.isEmpty) {
      setState(() {
        _filteredRecipes = _recipes;
      });
    } else {
      setState(() {
        _filteredRecipes = _recipes.where((recipe) {
          final searchTerms = query.toLowerCase().split(' ');
          return searchTerms.every((term) =>
          recipe.strMeal.toLowerCase().contains(term) ||
              recipe.strCategory.toLowerCase().contains(term) ||
              recipe.strArea.toLowerCase().contains(term));
        }).toList();
      });
    }
  }

  Widget _searchBar() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.backgroundGray,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(Icons.search),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _searchController,
              onChanged: (value) => _filterRecipes(value),
              decoration: const InputDecoration(
                hintText: "Search Recipes",
                border: InputBorder.none,
              ),
            ),
          ),
          if (_searchController.text.isNotEmpty)
            GestureDetector(
              onTap: () {
                _searchController.clear();
                _filterRecipes('');
              },
              child: const Icon(Icons.clear),
            ),
        ],
      ),
    );
  }
  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 50),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Hallo Hr",
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(color: AppColor.primaryColor),
                ),
                IconButton(onPressed: () {
                 Navigator.push(context, MaterialPageRoute(builder: (context) => FavouriteRecipesScreen(),));
                }, icon: const Icon(Icons.favorite_border))
              ],
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              "What you want to cook today?",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          _searchBar(),
          const SizedBox(height: 16),

          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _hasError
              ? Center(
            child: Text(
              _errorMessage,
              style: const TextStyle(color: Colors.red, fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ):Expanded(
            child: ListView.separated(
              controller: _scrollController,
              itemCount: _filteredRecipes.length + (_isFetchingMore ? 1 : 0),
              padding: const EdgeInsets.symmetric(horizontal: 24),
              separatorBuilder: (_, __) {
                return const SizedBox(width: 16);
              },
              itemBuilder: (context, index) {
                if (index == _filteredRecipes.length) {
                  return const Center(child: CircularProgressIndicator());
                }
                final recipe = _filteredRecipes[index];
                return RecipeItem(recipe: recipe);
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }
}
