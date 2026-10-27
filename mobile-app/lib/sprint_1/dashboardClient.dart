import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fityes/NotificationPage.dart';
import 'package:fityes/api_config.dart';
import 'package:fityes/sprint_1/PageModifyGoal.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DashboardClient extends StatefulWidget {
  const DashboardClient({super.key});

  @override
  _DashboardClientState createState() => _DashboardClientState();
}

class _DashboardClientState extends State<DashboardClient> {
  String? firstname = "";
  String? lastname = ""; 
  double? bmi = 0; 
  String? goal = " "; 
  double? targetWeight = 0; 
  double? calories = 0; 
  double? fats = 0; 
  double? carbs = 0; 
  double? proteins = 0; 
  double? height; 
  double? weight; 
  bool isLoading = false;
  String? userId;
  String getBmiMessage(double? bmi) {
    if (bmi == null) return "Unknown";
    if (bmi < 18.5) return "You are underweight";
    if (bmi < 25) return "You have a normal weight";
    if (bmi < 30) return "You are overweight";
    return "You are obese";
  }

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    await _loadUserId();
    await _fetchData();
    if (userId != null) {
      await fetchUserFullName(userId!);
      await fetchUserDetails(userId!);
    }
    await getTodayNutrition();
  }

  Future<void> _loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('userId');

    print(" userId in DashboardClient: $userId");
  }

  Future<void> _fetchData() async {
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User ID not found')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final baseUrl = ApiConfig.getGoal_tW_imc_ByUserId(userId!);
      final response = await http.get(
        baseUrl,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          goal = data['goal'];
          targetWeight = data['targetWeight']?.toDouble();
          bmi = data['imc']?.toDouble();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Failed to fetch goal data: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching data: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchUserFullName(String userId) async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}users/getAdherent_Fn_Ln_ById/$userId'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        firstname = data['firstname'] ?? "";
        lastname = data['lastname'] ?? "";
      });
    } else {
      print('Erreur lors de la récupération du nom : ${response.statusCode}');
    }
  }

  Future<void> fetchUserDetails(String userId) async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}users/getAdherentDetails/$userId'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        height = (data['height']?.toDouble() ?? 0) / 100; 
        weight = data['weight']?.toDouble() ?? 0;
      });
    } else {
      print(
          'Erreur lors de la récupération des détails : ${response.statusCode}');
    }
  }

  Future<void> getTodayNutrition() async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}users/getTodayNutrition/$userId'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        calories = data['totalCalories']?.toDouble() ?? 0;
        fats = data['totalFats']?.toDouble() ?? 0;
        carbs = data['totalCarbs']?.toDouble() ?? 0;
        proteins = data['totalProteins']?.toDouble() ?? 0;
      });
    } else {
      print('Erreur serveur: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           
            const SizedBox(height: 40),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Welcome Back,",
                  style: TextStyle(fontSize: 20, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${firstname ?? ''} ${lastname ?? ''}".trim().isEmpty
                      ? "Loading..."
                      : "${firstname!} ${lastname!}",
                  style: const TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.notifications, color: Colors.red),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              NotificationPage()),
                    );
                  },
                )
              ],
            ),

            const SizedBox(height: 16),

          
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF7EB6FF), Color(0xFFB5AFFF)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "BMI (Body Mass Index)",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            getBmiMessage(bmi),
                            style: const TextStyle(
                                fontSize: 18, color: Colors.white),
                          ),
                          Container(
                            width: 80,
                            height: 80,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [
                                  Color.fromARGB(255, 250, 156, 183),
                                  Color(0xFFD8B5FF),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                bmi?.toStringAsFixed(1) ?? "0.0",
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              color: const Color(0xFFECF4FF),
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF7EB6FF), Color(0xFFB5AFFF)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Goal",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            goal ?? "Loading...",
                            style: const TextStyle(
                                fontSize: 18,
                                color: Colors.black87,
                                fontWeight: FontWeight.bold),
                          ),
                          Container(
                            width: 90,
                            height: 40,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  Color.fromARGB(255, 250, 156, 183), 
                                  Color(0xFFD8B5FF), 
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  if (userId != null &&
                                      height != null &&
                                      weight != null) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => PageModifyGoal(
                                          userId: userId!,
                                          height: height!,
                                          weight: weight!,
                                          currentGoal: goal ?? "lose weight",
                                        ),
                                      ),
                                    );
                                  }
                                  ;
                                },
                                borderRadius: BorderRadius.circular(10),
                                child: const Center(
                                  child: Text(
                                    "Modify",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF7EB6FF), Color(0xFFB5AFFF)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Target Weight",
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "${targetWeight?.toStringAsFixed(1) ?? '0.0'} kg",
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

          
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              color: const Color(0xFFECF4FF),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Today Status",
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Container(
                                width: 100,
                                height: 100,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(0xFF7EB6FF),
                                      Color(0xFFB5AFFF)
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    "${calories?.toStringAsFixed(0) ?? '0'} kCal",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text("Calories",
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            children: [
                              Container(
                                width: 100,
                                height: 100,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(0xFF7EB6FF),
                                      Color(0xFFB5AFFF)
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    "${fats?.toStringAsFixed(0) ?? '0'} g",
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text("Fats",
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            children: [
                              Container(
                                width: 100,
                                height: 100,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(0xFF7EB6FF),
                                      Color(0xFFB5AFFF)
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    "${carbs?.toStringAsFixed(0) ?? '0'} g",
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text("Carbs",
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            children: [
                              Container(
                                width: 100,
                                height: 100,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(0xFF7EB6FF),
                                      Color(0xFFB5AFFF)
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    "${proteins?.toStringAsFixed(0) ?? '0'} g",
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text("Proteins",
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
