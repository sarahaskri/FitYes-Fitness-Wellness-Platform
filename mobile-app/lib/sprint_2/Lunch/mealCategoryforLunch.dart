
class MealExampleForLunch {
  final String name;
  final String category;
  final String description;
  final Map<String, String> nutrition;
  final String imagePath;

  const MealExampleForLunch({
    required this.name,
    required this.category,
    required this.description,
    required this.nutrition,
    required this.imagePath,
  });
}

final Map<String, List<MealExampleForLunch>> lunchcategoryMeals = {
  'Salad': [
    const MealExampleForLunch(
      name: 'Fruit Salad',
      category: 'Salad',
      description: 'Fresh fruit mix with Greek yogurt and honey',
      nutrition: {
        'Calories': '280',
        'Fats': '4g',
        'Proteins': '6g',
        'Carbs': '58g'
      },
      imagePath: 'assets/images/fruit-salad.png',
    ),
    const MealExampleForLunch(
      name: 'High Protein Salad',
      category: 'Salad',
      description: 'Grilled chicken, quinoa and avocado',
      nutrition: {
        'Calories': '420',
        'Fats': '18g',
        'Proteins': '38g',
        'Carbs': '32g'
      },
      imagePath: 'assets/images/protein_salad.png',
    ),
    const MealExampleForLunch(
      name: 'Muscle Building Salad',
      category: 'Salad',
      description: 'Lean beef, hard-boiled eggs and spinach',
      nutrition: {
        'Calories': '550',
        'Fats': '25g',
        'Proteins': '45g',
        'Carbs': '35g'
      },
      imagePath: 'assets/images/muscle_salad.png',
    ),
    const MealExampleForLunch(
      name: 'Lose Weight Salad',
      category: 'Salad',
      description: 'Green vegetables with light vinaigrette',
      nutrition: {
        'Calories': '150',
        'Fats': '3g',
        'Proteins': '8g',
        'Carbs': '20g'
      },
      imagePath: 'assets/images/weightloss_salad.png',
    ),
  ],
'Steak': [
  const MealExampleForLunch(
    name: 'Grilled Beef Steak',
    category: 'Steak',
    description: 'Lean beef steak with grilled vegetables',
    nutrition: {
      'Calories': '280',
      'Fats': '12g',
      'Proteins': '26g',
      'Carbs': '5g'
    },
    imagePath: 'assets/images/beef.png',
  ),
  const MealExampleForLunch(
    name: 'Chicken Steak',
    category: 'Steak',
    description: 'Grilled chicken breast with herbs',
    nutrition: {
      'Calories': '240',
      'Fats': '6g',
      'Proteins': '30g',
      'Carbs': '2g'
    },
    imagePath: 'assets/images/meat.png',
  ),
  const MealExampleForLunch(
    name: 'Turkey Steak',
    category: 'Steak',
    description: 'Lean turkey steak with steamed greens',
    nutrition: {
      'Calories': '220',
      'Fats': '5g',
      'Proteins': '28g',
      'Carbs': '3g'
    },
    imagePath: 'assets/images/turkey_steak.png',
  ),
  const MealExampleForLunch(
    name: 'Tofu Steak',
    category: 'Steak',
    description: 'Grilled tofu with sesame and soy sauce',
    nutrition: {
      'Calories': '200',
      'Fats': '10g',
      'Proteins': '20g',
      'Carbs': '6g'
    },
    imagePath: 'assets/images/tofu.png',
  ),
],

  'Sandwich': [
  const MealExampleForLunch(
    name: 'Whole Wheat Turkey Sandwich',
    category: 'Sandwich',
    description: 'Turkey, lettuce, tomato on whole wheat bread',
    nutrition: {
      'Calories': '310',
      'Fats': '8g',
      'Proteins': '26g',
      'Carbs': '30g'
    },
    imagePath: 'assets/images/turkey_sandwich.png',
  ),
  const MealExampleForLunch(
    name: 'Grilled Chicken Wrap',
    category: 'Sandwich',
    description: 'Grilled chicken with veggies in a whole wheat wrap',
    nutrition: {
      'Calories': '290',
      'Fats': '7g',
      'Proteins': '28g',
      'Carbs': '27g'
    },
    imagePath: 'assets/images/chicken_wrap.png',
  ),
  const MealExampleForLunch(
    name: 'Tuna Avocado Sandwich',
    category: 'Sandwich',
    description: 'Tuna and mashed avocado on multigrain bread',
    nutrition: {
      'Calories': '330',
      'Fats': '12g',
      'Proteins': '24g',
      'Carbs': '28g'
    },
    imagePath: 'assets/images/tuna_avocado.png',
  ),
  const MealExampleForLunch(
    name: 'Vegan Hummus Wrap',
    category: 'Sandwich',
    description: 'Hummus, spinach, cucumber in a whole grain wrap',
    nutrition: {
      'Calories': '260',
      'Fats': '9g',
      'Proteins': '10g',
      'Carbs': '33g'
    },
    imagePath: 'assets/images/hummus_wrap.png',
  ),
],

'Pasta': [
  const MealExampleForLunch(
    name: ' Pasta with Chicken',
    category: 'Pasta',
    description: 'Grilled chicken with whole grain pasta and veggies',
    nutrition: {
      'Calories': '350',
      'Fats': '9g',
      'Proteins': '30g',
      'Carbs': '40g'
    },
    imagePath: 'assets/images/chicken_pasta.png',
  ),
  const MealExampleForLunch(
    name: ' Pasta with Pesto',
    category: 'Pasta',
    description: 'Lentil-based pasta topped with basil pesto',
    nutrition: {
      'Calories': '320',
      'Fats': '10g',
      'Proteins': '20g',
      'Carbs': '35g'
    },
    imagePath: 'assets/images/lentil_pesto.png',
  ),
  const MealExampleForLunch(
    name: 'Zucchini Noodle ',
    category: 'Pasta',
    description: 'Zucchini noodles with cherry tomatoes and herbs',
    nutrition: {
      'Calories': '180',
      'Fats': '6g',
      'Proteins': '6g',
      'Carbs': '20g'
    },
    imagePath: 'assets/images/zoodle_bowl.png',
  ),
  const MealExampleForLunch(
    name: 'Salmon Pasta ',
    category: 'Pasta',
    description: 'Salmon chunks with whole grain pasta and spinach',
    nutrition: {
      'Calories': '370',
      'Fats': '14g',
      'Proteins': '28g',
      'Carbs': '34g'
    },
    imagePath: 'assets/images/salmon_pasta.png',
  ),
],

};

List<MealExampleForLunch> getMealsByCategoryforLunch(String category) {
  return lunchcategoryMeals[category] ?? [];
}
Map<String, String> cleanNutritionDatalunch(Map<String, String> nutrition) {
  return nutrition.map((key, value) {
    final cleaned = value.replaceAll(RegExp(r'[^0-9]'), '');
    return MapEntry(key, cleaned.isNotEmpty ? cleaned : '0');
  });
}
