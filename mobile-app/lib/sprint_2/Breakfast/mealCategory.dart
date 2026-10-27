class MealExample {
  final String name;
  final String category;
  final String description;
  final Map<String, String> nutrition;
  final String imagePath;

  const MealExample({
    required this.name,
    required this.category,
    required this.description,
    required this.nutrition,
    required this.imagePath,
  });
}

final Map<String, List<MealExample>> categoryMeals = {
  'Salad': [
    const MealExample(
      name: 'Fruit Salad',
      category: 'Salad',
      description: 'Fresh fruit mix with Greek yogurt and honey',
      nutrition: {
        'Calories': '280Ckal',
        'Fats': '4g',
        'Proteins': '6g',
        'Carbs': '58g'
      },
      imagePath: 'assets/images/fruit-salad.png',
    ),
    const MealExample(
      name: 'High Protein Salad',
      category: 'Salad',
      description: 'Grilled chicken, quinoa and avocado',
      nutrition: {
        'Calories': '420Ckal',
        'Fats': '18g',
        'Proteins': '38g',
        'Carbs': '32g'
      },
      imagePath: 'assets/images/protein_salad.png',
    ),
    const MealExample(
      name: 'Muscle Building Salad',
      category: 'Salad',
      description: 'Lean beef, hard-boiled eggs and spinach',
      nutrition: {
        'Calories': '550Ckal',
        'Fats': '25g',
        'Proteins': '45g',
        'Carbs': '35g'
      },
      imagePath: 'assets/images/muscle_salad.png',
    ),
    const MealExample(
      name: 'Lose Weight Salad',
      category: 'Salad',
      description: 'Green vegetables with light vinaigrette',
      nutrition: {
        'Calories': '150Ckal',
        'Fats': '3g',
        'Proteins': '8g',
        'Carbs': '20g'
      },
      imagePath: 'assets/images/weightloss_salad.png',
    ),
  ],
  'Cake': [
    const MealExample(
      name: 'Banana Protein Cake',
      category: 'Cake',
      description: 'Gluten-free with whey protein',
      nutrition: {
        'Calories': '240Ckal',
        'Fats': '7g',
        'Proteins': '18g',
        'Carbs': '28g'
      },
      imagePath: 'assets/images/banana_cake.png',
    ),
    const MealExample(
      name: 'Energy Cake',
      category: 'Cake',
      description: 'Oats, nuts and honey',
      nutrition: {
        'Calories': '320Ckal',
        'Fats': '12g',
        'Proteins': '9g',
        'Carbs': '45g'
      },
      imagePath: 'assets/images/energy_cake.png',
    ),
    const MealExample(
      name: 'Chocolate Cake',
      category: 'Cake',
      description: 'Light version with 70% cocoa',
      nutrition: {
        'Calories': '290Ckal',
        'Fats': '14g',
        'Proteins': '8g',
        'Carbs': '38g'
      },
      imagePath: 'assets/images/Chocolate_cake.png',
    ),
    const MealExample(
      name: 'Protein Cake',
      category: 'Cake',
      description: 'High-protein low-sugar',
      nutrition: {
        'Calories': '180Ckal',
        'Fats': '5g',
        'Proteins': '22g',
        'Carbs': '15g'
      },
      imagePath: 'assets/images/protein_cake.png',
    ),
  ],
  'Pie': [
    const MealExample(
      name: 'Apple Pie',
      category: 'Pie',
      description: 'Wholemeal pasta and organic apples',
      nutrition: {
        'Calories': '270Ckal',
        'Fats': '8g',
        'Proteins': '12g',
        'Carbs': '40g'
      },
      imagePath: 'assets/images/apple-pie.png',
    ),
    const MealExample(
      name: 'Chicken Pie',
      category: 'Pie',
      description: 'Chicken and vegetables in a wholemeal crust',
      nutrition: {
        'Calories': '350Ckal',
        'Fats': '15g',
        'Proteins': '25g',
        'Carbs': '30g'
      },
      imagePath: 'assets/images/chicken-pie.png',
    ),
    const MealExample(
      name: 'Pumpkin Pie',
      category: 'Pie',
      description: 'Butternut squash and spices',
      nutrition: {
        'Calories': '230Ckal',
        'Fats': '9g',
        'Proteins': '6g',
        'Carbs': '35g'
      },
      imagePath: 'assets/images/pumpkin-pie.png',
    ),
    const MealExample(
      name: 'Healthy Pie',
      category: 'Pie',
      description: 'Roasted vegetables and pasta with olive oil',
      nutrition: {
        'Calories': '280Ckal',
        'Fats': '12g',
        'Proteins': '10g',
        'Carbs': '38g'
      },
      imagePath: 'assets/images/Healthy-pie.png',
    ),
  ],
  'Smoothie': [
    const MealExample(
      name: 'Muscle Gain Smoothie',
      category: 'Smoothie',
      description: 'Banana, peanut butter, whey protein',
      nutrition: {
        'Calories': '450Ckal',
        'Fats': '18g',
        'Proteins': '32g',
        'Carbs': '45g'
      },
      imagePath: 'assets/images/banana-smoothie.png',
    ),
    const MealExample(
      name: 'Post-Workout Shake',
      category: 'Smoothie',
      description: 'Fast protein and simple carbohydratess',
      nutrition: {
        'Calories': '300Ckal',
        'Fats': '4g',
        'Proteins': '35g',
        'Carbs': '35g'
      },
      imagePath: 'assets/images/mango.png',
    ),
    const MealExample(
      name: 'Pre-Workout Shake',
      category: 'Smoothie',
      description: 'Sustainable energy with apricot',
      nutrition: {
        'Calories': '250Ckal',
        'Fats': '6g',
        'Proteins': '15g',
        'Carbs': '40g'
      },
      imagePath: 'assets/images/apricot.png',
    ),
    const MealExample(
      name: 'Whey Protein Shake',
      category: 'Smoothie',
      description: 'Whey isolate and creamy berry shake for instant refreshment.',
      nutrition: {
        'Calories': '220Ckal',
        'Fats': '8g',
        'Proteins': '28g',
        'Carbs': '12g'
      },
      imagePath: 'assets/images/berry_shake.png',
    ),
  ],
};

List<MealExample> getMealsByCategory(String category) {
  return categoryMeals[category] ?? [];
}
Map<String, String> cleanNutritionDatabreakfast(Map<String, String> nutrition) {
  return nutrition.map((key, value) {
    final cleaned = value.replaceAll(RegExp(r'[^0-9]'), '');
    return MapEntry(key, cleaned.isNotEmpty ? cleaned : '0');
  });
}

