class Recipe {
  final String idMeal;
  final String strMeal;
  final String? strDrinkAlternate;
  final String strCategory;
  final String strArea;
  final String strMealThumb;

  Recipe({
    required this.idMeal,
    required this.strMeal,
    this.strDrinkAlternate,
    required this.strCategory,
    required this.strArea,
    required this.strMealThumb,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      idMeal: json['idMeal'],
      strMeal: json['strMeal'],
      strDrinkAlternate: json['strDrinkAlternate'],
      strCategory: json['strCategory'],
      strArea: json['strArea'],
      strMealThumb: json['strMealThumb'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idMeal': idMeal,
      'strMeal': strMeal,
      'strDrinkAlternate': strDrinkAlternate,
      'strCategory': strCategory,
      'strArea': strArea,
      'strMealThumb': strMealThumb,
    };
  }
}
