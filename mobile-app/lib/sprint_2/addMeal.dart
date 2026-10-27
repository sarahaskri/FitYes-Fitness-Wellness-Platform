import 'dart:convert';
import 'package:fityes/sprint_2/Breakfast/mealCategory.dart';
import 'package:fityes/sprint_2/Dinner/mealCategoryforDinner.dart';
import 'package:fityes/sprint_2/Lunch/mealCategoryforLunch.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fityes/api_config.dart';


class AddMealPage extends StatefulWidget {
  final String mealName;
  final String mealType;
  final String imagepath; 

  AddMealPage({required this.mealName, required this.mealType, required this.imagepath});

  @override
  _AddMealPageState createState() => _AddMealPageState();
}

class _AddMealPageState extends State<AddMealPage> {
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();

  final DateFormat dateFormat = DateFormat('yyyy-MM-dd');
  final DateFormat timeFormat = DateFormat('HH:mm');

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  String? userId;

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final storedUserId = prefs.getString('userId');

    setState(() {
      userId = storedUserId;
      print(" userId dans breakfast interface : $userId");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add to ${widget.mealType} Meal'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          
            TextField(
              controller: dateController,
              readOnly: true,
              decoration: const InputDecoration(
                labelText: 'Select Date',
                hintText: 'YYYY-MM-DD',
                border: OutlineInputBorder(),
              ),
              onTap: () async {
                FocusScope.of(context).unfocus();
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: selectedDate,
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2101),
                );
                if (pickedDate != null) {
                  setState(() {
                    selectedDate = pickedDate;
                    dateController.text = dateFormat.format(pickedDate);
                  });
                }
              },
            ),
            const SizedBox(height: 16),
          
            TextField(
              controller: timeController,
              readOnly: true,
              decoration: const InputDecoration(
                labelText: 'Select Time',
                hintText: 'HH:mm',
                border: OutlineInputBorder(),
              ),
              onTap: () async {
                FocusScope.of(context).unfocus();
                TimeOfDay? pickedTime = await showTimePicker(
                  context: context,
                  initialTime: selectedTime,
                );
                if (pickedTime != null) {
                  setState(() {
                    selectedTime = pickedTime;
                    final formattedTime = timeFormat.format(
                      DateTime(0, 1, 1, pickedTime.hour, pickedTime.minute),
                    );
                    timeController.text = formattedTime;
                  });
                }
              },
            ),
            const SizedBox(height: 16),

            ElevatedButton(
              onPressed: () {
                if (dateController.text.isNotEmpty &&
                    timeController.text.isNotEmpty &&
                    userId != null) {
                  addMealToDatabase(
                    mealType: widget.mealType, 
                    mealName: widget.mealName,
                    date: dateController.text,
                    time: timeController.text,
                    imagepath: widget.imagepath,
                    nutrition: _getMealNutrition(), 
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please select a date and time')),
                  );
                }
              },
              child: const Text('Add Meal'),
            ),
          ],
        ),
      ),
    );
  }

  Map<String, String> _getMealNutrition() {
    if (widget.mealType == "Breakfast") {
      final allMeals = categoryMeals.values.expand((m) => m).toList();
      final meal = allMeals.firstWhere(
        (m) => m.name == widget.mealName,
        orElse: () => const MealExample(
          name: '',
          category: '',
          description: '',
          nutrition: {},
          imagePath: '',
        ),
      );
      return cleanNutritionDatabreakfast(meal.nutrition);
    }

    if (widget.mealType == "Lunch") {
      final lunchAllMeals = lunchcategoryMeals.values.expand((m) => m).toList();
      final meal = lunchAllMeals.firstWhere(
        (m) => m.name == widget.mealName,
        orElse: () => const MealExampleForLunch(
          name: '',
          category: '',
          description: '',
          nutrition: {},
          imagePath: '',
        ),
      );
      return cleanNutritionDatalunch(meal.nutrition);
    }

    if (widget.mealType == "Dinner") {
      final dinnerAllMeals = dinnerCategoryMeals.values.expand((m) => m).toList();
      final meal = dinnerAllMeals.firstWhere(
        (m) => m.name == widget.mealName,
        orElse: () => const MealExampleForDinner(
          name: '',
          category: '',
          description: '',
          nutrition: {},
          imagePath: '',
        ),
      );
      return cleanNutritionDatadinner(meal.nutrition);
    }

    return {}; 
  }

  Future<void> addMealToDatabase({
    required String mealType,
    required String mealName,
    required String date,
    required String time,
    required String imagepath,
    required Map<String, String> nutrition,
  }) async {
    final baseUrl = ApiConfig.addMeal();
    final cleanedNutrition = nutrition; 

    final response = await http.post(
      baseUrl,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "userId": userId,
        "mealType": mealType,
        "mealName": mealName,
        "date": date,
        "time": time,
        "imagePath": imagepath,
        "nutrition": cleanedNutrition, 
      }),
    );

    print("Status: ${response.statusCode}");
    print("Body: ${response.body}");

    if (response.statusCode == 200) {
      print(" Meal added successfully");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Meal added successfully')),
      );
    } else {
      print(" Failed to add meal");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to add meal')),
      );
    }
  }
}
