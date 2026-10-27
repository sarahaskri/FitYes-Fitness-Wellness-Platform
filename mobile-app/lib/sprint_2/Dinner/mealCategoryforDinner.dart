class MealExampleForDinner {
  final String name;
  final String category;
  final String description;
  final Map<String, String> nutrition;
  final String imagePath;

  const MealExampleForDinner({
    required this.name,
    required this.category,
    required this.description,
    required this.nutrition,
    required this.imagePath,
  });
}

final Map<String, List<MealExampleForDinner>> dinnerCategoryMeals = {
  'Soup': [
    const MealExampleForDinner(
      name: 'Tomato Basil Soup',
      category: 'Soup',
      description: 'Creamy tomato soup with fresh basil',
      nutrition: {
        'Calories': '150',
        'Fats': '5g',
        'Proteins': '4g',
        'Carbs': '20g',
      },
      imagePath: 'assets/images/tomato_soup.png',
    ),
    const MealExampleForDinner(
      name: 'Chicken Noodle Soup',
      category: 'Soup',
      description: 'Light broth with chicken, carrots and noodles',
      nutrition: {
        'Calories': '220',
        'Fats': '6g',
        'Proteins': '18g',
        'Carbs': '24g',
      },
      imagePath: 'assets/images/chicken_soup.png',
    ),
    const MealExampleForDinner(
      name: 'Lentil Soup',
      category: 'Soup',
      description: 'Hearty lentil soup with spices',
      nutrition: {
        'Calories': '180',
        'Fats': '4g',
        'Proteins': '12g',
        'Carbs': '25g',
      },
      imagePath: 'assets/images/lentil_soup.png',
    ),
    const MealExampleForDinner(
      name: 'Miso Soup',
      category: 'Soup',
      description: 'Traditional Japanese soup with tofu and seaweed',
      nutrition: {
        'Calories': '90',
        'Fats': '3g',
        'Proteins': '6g',
        'Carbs': '8g',
      },
      imagePath: 'assets/images/miso_soup.png',
    ),
  ],
  'Grilled': [
    const MealExampleForDinner(
      name: 'Grilled Chicken Plate',
      category: 'Grilled',
      description: 'Grilled chicken with veggies and brown rice',
      nutrition: {
        'Calories': '360',
        'Fats': '8g',
        'Proteins': '32g',
        'Carbs': '35g',
      },
      imagePath: 'assets/images/grilled_chicken.png',
    ),
    const MealExampleForDinner(
      name: 'Grilled Veggie Mix',
      category: 'Grilled',
      description: 'Zucchini, peppers, eggplant grilled to perfection',
      nutrition: {
        'Calories': '200',
        'Fats': '7g',
        'Proteins': '4g',
        'Carbs': '22g',
      },
      imagePath: 'assets/images/grilled_veggies.png',
    ),
    const MealExampleForDinner(
      name: 'Grilled Fish',
      category: 'Grilled',
      description: 'Grilled white fish with lemon and herbs',
      nutrition: {
        'Calories': '280',
        'Fats': '10g',
        'Proteins': '25g',
        'Carbs': '10g',
      },
      imagePath: 'assets/images/grilled_fish.png',
    ),
    const MealExampleForDinner(
      name: 'Grilled Tofu Skewers',
      category: 'Grilled',
      description: 'Tofu cubes grilled with bell peppers and onions',
      nutrition: {
        'Calories': '220',
        'Fats': '11g',
        'Proteins': '14g',
        'Carbs': '15g',
      },
      imagePath: 'assets/images/grilled_tofu.png',
    ),
  ],
  'Seafood': [
    const MealExampleForDinner(
      name: 'Shrimp Stir-Fry',
      category: 'Seafood',
      description: 'Shrimp with vegetables and soy sauce',
      nutrition: {
        'Calories': '300',
        'Fats': '9g',
        'Proteins': '24g',
        'Carbs': '28g',
      },
      imagePath: 'assets/images/sea1.png',
    ),
    const MealExampleForDinner(
      name: 'Grilled Salmon',
      category: 'Seafood',
      description: 'Salmon fillet with lemon, dill and veggies',
      nutrition: {
        'Calories': '350',
        'Fats': '16g',
        'Proteins': '30g',
        'Carbs': '5g',
      },
      imagePath: 'assets/images/grilled_salmon.png',
    ),
    const MealExampleForDinner(
      name: 'Seafood Paella',
      category: 'Seafood',
      description: 'Rice with mixed seafood and spices',
      nutrition: {
        'Calories': '400',
        'Fats': '14g',
        'Proteins': '22g',
        'Carbs': '42g',
      },
      imagePath: 'assets/images/paella.png',
    ),
    const MealExampleForDinner(
      name: 'Tuna Nicoise',
      category: 'Seafood',
      description: 'Tuna with green beans, eggs and olives',
      nutrition: {
        'Calories': '320',
        'Fats': '13g',
        'Proteins': '26g',
        'Carbs': '20g',
      },
      imagePath: 'assets/images/tuna_nicoise.png',
    ),
  ],
  'Rice Bowl': [
    const MealExampleForDinner(
      name: 'Chicken Rice Bowl',
      category: 'Rice Bowl',
      description: 'Chicken breast, brown rice and broccoli',
      nutrition: {
        'Calories': '400',
        'Fats': '9g',
        'Proteins': '36g',
        'Carbs': '40g',
      },
      imagePath: 'assets/images/chicken_rice.png',
    ),
    const MealExampleForDinner(
      name: 'Beef Teriyaki Bowl',
      category: 'Rice Bowl',
      description: 'Sliced beef in teriyaki sauce over white rice',
      nutrition: {
        'Calories': '450',
        'Fats': '14g',
        'Proteins': '32g',
        'Carbs': '42g',
      },
      imagePath: 'assets/images/beef_bowl.png',
    ),
    const MealExampleForDinner(
      name: 'Vegan Tofu Bowl',
      category: 'Rice Bowl',
      description: 'Tofu, edamame and vegetables over quinoa',
      nutrition: {
        'Calories': '370',
        'Fats': '12g',
        'Proteins': '18g',
        'Carbs': '38g',
      },
      imagePath: 'assets/images/tofu_bowl.png',
    ),
    const MealExampleForDinner(
      name: 'Egg & Veggie Bowl',
      category: 'Rice Bowl',
      description: 'Scrambled egg, spinach and rice',
      nutrition: {
        'Calories': '320',
        'Fats': '10g',
        'Proteins': '14g',
        'Carbs': '36g',
      },
      imagePath: 'assets/images/egg_bowl.png',
    ),
  ],
};

List<MealExampleForDinner> getMealsByCategoryForDinner(String category) {
  return dinnerCategoryMeals[category] ?? [];
}
Map<String, String> cleanNutritionDatadinner(Map<String, String> nutrition) {
  return nutrition.map((key, value) {
    final cleaned = value.replaceAll(RegExp(r'[^0-9]'), '');
    return MapEntry(key, cleaned.isNotEmpty ? cleaned : '0');
  });
}
