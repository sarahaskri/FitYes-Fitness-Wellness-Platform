import 'package:fityes/sprint_2/addMealByAdmin.dart';
import 'package:fityes/sprint_2/admin_service.dart';
import 'package:fityes/sprint_2/mealModelAdmin.dart';
import 'package:fityes/sprint_2/updateByAdmin.dart';
import 'package:flutter/material.dart';

class AdminDashboard extends StatefulWidget {
  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final AdminService adminService = AdminService();
  List<Meal> meals = [];

  @override
  void initState() {
    super.initState();
    fetchMeals();
  }

void fetchMeals() async {
  final fetchedMeals = await adminService.getMealByAdmin();
  setState(() {
    meals = fetchedMeals;
  });
}


  void deleteMeal(String id) async {
    await adminService.deleteMealByAdmin(id);
    fetchMeals();
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Admin Meal Management')),
      body: ListView.builder(
        itemCount: meals.length,
        itemBuilder: (context, index) {
          final meal = meals[index];
          return ListTile(
            title: Text(meal.mealName),
            subtitle: Text(meal.mealType),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UpdateMealByadmin(meal: meal)),
                    );
                    if (result == true) fetchMeals(); 
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => deleteMeal(meal.id),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddMealByAdmin()),
                    );
                    if (result == true) fetchMeals(); 
                  },
        child: Icon(Icons.add),
       
      ),
    );
  }
}
