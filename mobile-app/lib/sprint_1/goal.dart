import 'package:fityes/api_config.dart';
import 'package:fityes/dashboardHome.dart';
import 'package:fityes/sprint_1/dashboardClient.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; 
import 'dart:convert';



Future<void> calculateGoal(String userId, String goal) async {
  final baseUrl = ApiConfig.calculate_goal();
  print('userId: $userId, goal: $goal');
  try {
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
      throw Exception('Échec de la requête : ${response.statusCode}');
    }
  } catch (e) {
    print('Exception lors de l\'appel API : $e');
  }
}

class GoalPage extends StatelessWidget {
  final List<GoalItem> goals = [
    GoalItem(
      title: "Build muscles",
      description:
          "I have a low amount of body fat and need / want to build more muscle",
      image:
          "assets/images/build_muscle-removebg.png", 
      value: "build muscle",
    ),
    GoalItem(
      title: "Lose weight",
      description:
          "I have over 20 lbs to lose. I want to drop fat and gain muscle mass",
      image: "assets/images/lose_weight_removebg.png",
      value: "lose weight",
    ),
    GoalItem(
      title: "Gain weight",
      description:
          "I'm 'skinny fat', look thin but have no shape. I want to add lean muscle",
      image: "assets/images/gain_weight-removebg.png",
      value: "gain weight",
    ),
  ];

 
  final String userId; 

  GoalPage({required this.userId}); 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("What is your goal?"),
        titleTextStyle: const TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 139, 144, 244),
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Text(
              "It will help us to choose  a best \n program for you",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: goals.length,
              itemBuilder: (context, index) {
                final goal = goals[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: GoalCard(goal: goal, userId: userId), 
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class GoalItem {
  final String title;
  final String description;
  final String image;
  final String value;

  GoalItem({
    required this.title,
    required this.description,
    required this.image,
    required this.value,
  });
}

class GoalCard extends StatelessWidget {
  final GoalItem goal;
  final String userId; 

  const GoalCard({required this.goal, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      margin: const EdgeInsets.only(top: 20, bottom: 40),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF7EB6FF), Color(0xFFB5AFFF)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            blurRadius: 8,
            color: Colors.white,
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Image.asset(goal.image, height: 300, width: 300),
          Text(goal.title,
              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white)),
          Text(goal.description,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, color: Colors.white)),
          ElevatedButton(
            onPressed: () async {
              try {
                
                await calculateGoal(userId, goal.value);
                print('Goal selected: ${goal.value}');

               
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DashboardHome(goal: goal.value)),
                );
              } catch (e) {
                print('Erreur lors du calcul du goal : $e');
               
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Erreur : $e')),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.blueAccent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
              padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 15),
            ),
            child: const Text("Confirm",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}