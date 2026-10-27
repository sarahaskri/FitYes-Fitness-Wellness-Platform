import 'dart:convert';
import 'package:fityes/api_config.dart';
import 'package:fityes/gemini.dart';
import 'package:fityes/sprint_1/DataProfile.dart';
import 'package:fityes/sprint_1/dashboardClient.dart';
import 'package:fityes/sprint_2/mealPlanner.dart';
import 'package:fityes/sprint_3/workout_planner.dart';
import 'package:fityes/sprint_4/progressionPage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class DashboardHome extends StatefulWidget {
  final String goal;

  const DashboardHome({Key? key, required this.goal}) : super(key: key);

  @override
  State<DashboardHome> createState() => _DashboardHome();
}

class _DashboardHome extends State<DashboardHome> {
  String? userId;
  int _selectedIndex = 0;
  double posX = 20;
  double posY = 500;

  Future<void> _loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('userId');

    setState(() {
      print("userId dans dashboard Home : $userId");
    });

    if (userId == null) {
      print(" Aucun userId trouvé dans SharedPreferences.");
      return;
    }

    String? userGoal;
    try {
      final goalResponse = await http.get(
        Uri.parse('${ApiConfig.baseUrl}users/getGoal/$userId'),
      );

      if (goalResponse.statusCode == 200) {
        final goalData = json.decode(goalResponse.body);
        userGoal = goalData['goal'];
      } else {
        print('📭 Goal introuvable');
        userGoal = "unknown";
      }
    } catch (e) {
      print(' Erreur lors de la récupération du goal: $e');
      userGoal = "unknown";
    }
  }

  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    print("Goal reçu : ${widget.goal}");
    _loadUserId();
    _screens = [
      DashboardClient(),
      MealPlannerPage(),
      WorkoutTrackerView(),
      ProgressTrackingPage(),
      DataProfile(),
    ];
  }

  void _onTappedItem(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
        
          _screens[_selectedIndex],

          Positioned(
            left: posX,
            top: posY,
            child: GestureDetector(
              onPanUpdate: (details) {
                setState(() {
                  posX += details.delta.dx;
                  posY += details.delta.dy;
                });
              },
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => GeminiChatbot()),
                );
              },
              child: Container(
                width: 60,
                height: 60,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFD8B5FF),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: const Icon(Icons.chat_rounded, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        height: 70,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(Icons.home, 0),
            _buildNavItem(Icons.restaurant, 1),
            _buildNavItem(Icons.fitness_center, 2),
            _buildNavItem(Icons.show_chart, 3),
            _buildNavItem(Icons.person, 4),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index) {
    bool isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => _onTappedItem(index),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        width: 60,
        height: 60,
        transform: Matrix4.translationValues(0, isSelected ? -20 : 0, 0),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected ? const Color(0xFF9fbef7) : Colors.transparent,
        ),
        child: Icon(
          icon,
          color: isSelected
              ? Colors.white
              : const Color.fromARGB(255, 186, 186, 186),
          size: 30,
        ),
      ),
    );
  }

  Future<void> calculateGoal(String userId, String goal) async {
    final baseUrl = ApiConfig.calculate_goal();
    print('userId: $userId, goal: $goal');
    final response = await http.post(
      baseUrl,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'userId': userId, 'goal': goal}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('IMC: ${data['imc']}');
      print('Message: ${data['message']}');
    } else {
      print('Erreur: ${response.body}');
    }
  }
}
 
