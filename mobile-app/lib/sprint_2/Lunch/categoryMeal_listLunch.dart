import 'package:fityes/sprint_2/Breakfast/mealCategory.dart';
import 'package:flutter/material.dart';
import 'package:fityes/sprint_2/addMeal.dart';
import 'package:fityes/sprint_2/Lunch/mealCategoryforLunch.dart'; 

class CategoryMealListLunch extends StatelessWidget {
  final Map mObj;
  final Map dObj;

  const CategoryMealListLunch({
    super.key,
    required this.dObj,
    required this.mObj,
  });

  @override
  Widget build(BuildContext context) {
    final meals = getMealsByCategoryforLunch(dObj['name']);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${dObj['name']} Meals',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        color: Colors.grey[50],
        child: ListView.separated(
          padding: const EdgeInsets.all(20),
          itemCount: meals.length,
          separatorBuilder: (_, __) => const SizedBox(height: 15),
          itemBuilder: (context, index) {
            final meal = meals[index];
            return _buildMealCard(
              context: context,
              meal: meal,
            );
          },
        ),
      ),
    );
  }

  Widget _buildMealCard({
    required BuildContext context,
    required MealExampleForLunch meal,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.grey[100]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.asset(
                    meal.imagePath,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        Image.asset('assets/images/default_meal.png',
                            width: 100, height: 100),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        meal.name,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple[800],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        meal.description,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 15,
                        children: meal.nutrition.entries
                            .map((e) => _buildNutritionBadge(e.key, e.value))
                            .toList(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF7EB6FF), Color(0xFFB5AFFF)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextButton.icon(
                  icon: const Icon(Icons.add,
                      color: Colors.white, size: 18),
                  label: const Text('Add to Plan',
                      style: TextStyle(color: Colors.white)),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AddMealPage(
                          mealType: mObj['name'],
                          mealName: meal.name,
                            imagepath: meal.imagePath,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNutritionBadge(String title, String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.check, size: 14, color: Colors.green),
        const SizedBox(width: 4),
        Text(
          '$title: $value',
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
