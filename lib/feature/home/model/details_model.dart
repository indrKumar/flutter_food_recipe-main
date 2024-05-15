class RecipeDetails {
  final String idMeal;
  final String strMeal;
  final String? strDrinkAlternate;
  final String strCategory;
  final String strArea;
  final String strMealThumb;
  final String strInstructions;

  RecipeDetails({
    required this.idMeal,
    required this.strMeal,
    this.strDrinkAlternate,
    required this.strCategory,
    required this.strArea,
    required this.strMealThumb,
    required this.strInstructions,
  });

  factory RecipeDetails.fromJson(Map<String, dynamic> json) {
    return RecipeDetails(
      idMeal: json['idMeal'],
      strMeal: json['strMeal'],
      strDrinkAlternate: json['strDrinkAlternate'],
      strCategory: json['strCategory'],
      strArea: json['strArea'],
      strMealThumb: json['strMealThumb'],
      strInstructions: json['strInstructions'],
    );
  }
}
