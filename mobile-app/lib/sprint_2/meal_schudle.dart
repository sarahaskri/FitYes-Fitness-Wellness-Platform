import 'package:flutter/material.dart';

class Meal {
  final String name;
  final DateTime dateTime;

  Meal({required this.name, required this.dateTime});
}

class MealSchedule extends StatelessWidget {
  final List<Meal> _meals = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meal Schedule'),
      ),
      body: const Center(
        child: Text('No meals scheduled yet.'),
      ),
    );
  }

 
  void addMeal(String name, DateTime dateTime) {
    _meals.add(Meal(name: name, dateTime: dateTime));
    print('Repas ajouté : $name à $dateTime');
  }

  
  void removeMeal(String name) {
    _meals.removeWhere((meal) => meal.name == name);
    print('Repas supprimé : $name');
  }

  
  void displayMeals() {
    if (_meals.isEmpty) {
      print('Aucun repas prévu.');
    } else {
      print('Planning des repas :');
      for (var meal in _meals) {
        print('- ${meal.name} à ${meal.dateTime}');
      }
    }
  }
}

