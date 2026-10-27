import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:fityes/api_config.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ProgressTrackingPage extends StatefulWidget {
  const ProgressTrackingPage({super.key});

  @override
  _ProgressTrackingPageState createState() => _ProgressTrackingPageState();
}

class _ProgressTrackingPageState extends State<ProgressTrackingPage> {
  String? userId;
  double? targetWeight;
  double? initialWeight;
  String? goal;
  double? currentWeight;
  double? weightDifference;
  double? progressPercentage;
  bool isLoading = false;
  List<String> _adviceList = [];

  final TextEditingController _currentWeightController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() => isLoading = true);

    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('userId'); 

    print("userId in ProgressTrackingPage: $userId");

    if (userId != null) {
      await _fetchGoalData();
      await _fetchAndDisplayAdvice();
    } else {
      print("Aucun userId trouvé, redirection ou alerte possible.");
     
    }

    setState(() => isLoading = false);
  }

  Future<void> _fetchGoalData() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}users/getGoal_targetWieght/$userId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final goalData = json.decode(response.body);
        setState(() {
          targetWeight = double.tryParse(goalData['targetWeight']?.toString() ?? '0') ?? 0;
          initialWeight = double.tryParse(goalData['initialWeight']?.toString() ?? '0') ?? 0;
          goal = goalData['goal'] ?? 'unknown';
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch goal: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching goal: $e')),
      );
    }
  }

  Future<void> _fetchAndDisplayAdvice() async {
    if (goal == null) return;

    List<String> advice = await _getAdviceBasedOnGoal(goal!);
    setState(() {
      _adviceList = advice;
    });
  }

  Future<void> addProgression(
    String userId,
    double targetWeight,
    double initialWeight,
    double currentWeight,
    double weightDifference,
  ) async {
    final url = ApiConfig.addProgression();
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'userId': userId,
        'targetWeight': targetWeight,
        'initialWeight': initialWeight,
        'currentWeight': currentWeight,
        'weightDifference': weightDifference,
      }),
    );

    if (response.statusCode != 200) {
      print('Erreur lors de l\'ajout de la progression: ${response.body}');
    }
  }

  void _compareWeights() {
    if (_currentWeightController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your current weight')),
      );
      return;
    }

    double? tempCurrentWeight = double.tryParse(_currentWeightController.text);
    if (tempCurrentWeight == null || tempCurrentWeight <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid positive weight')),
      );
      return;
    }

    setState(() {
      currentWeight = tempCurrentWeight;

      if (currentWeight != null && targetWeight != null && initialWeight != null) {
        weightDifference = (currentWeight! - targetWeight!).abs();

        addProgression(userId!, targetWeight!, initialWeight!, currentWeight!, weightDifference!);
      
        if (goal?.toLowerCase().contains('lose weight') == true) {
          if (initialWeight! <= targetWeight!) {
            progressPercentage = 100.0;
          } else {
            double totalToLose = (initialWeight! - targetWeight!).clamp(0, double.infinity);
            double lost = (initialWeight! - currentWeight!).clamp(0, totalToLose);
            progressPercentage = totalToLose == 0
                ? 100.0
                : (lost / totalToLose * 100).clamp(0.0, 100.0);
          }
        } else if (goal?.toLowerCase().contains('gain weight') == true ||
            goal?.toLowerCase().contains('build muscle') == true) {
          if (initialWeight! >= targetWeight!) {
            progressPercentage = 100.0;
          } else {
            double totalToGain = (targetWeight! - initialWeight!).clamp(0, double.infinity);
            double gained = (currentWeight! - initialWeight!).clamp(0, totalToGain);
            progressPercentage = totalToGain == 0
                ? 100.0
                : (gained / totalToGain * 100).clamp(0.0, 100.0);
          }
        } else {
          progressPercentage = 0.0;
        }

        if (currentWeight == targetWeight) {
          progressPercentage = 100.0;
        }
      }
    });
  }

  Future<List<String>> _getAdviceBasedOnGoal(String goal) async {
    try {
      print('le goal est ,$goal');
      final response = await http.post(
        ApiConfig.getAdvice(),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'goal': goal}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['advice'] != null) {
         
          final adviceList = (data['advice'] as List<dynamic>)
              .where((item) => item != null && item is String && item.trim().isNotEmpty)
              .cast<String>()
              .toList();
          return adviceList.isNotEmpty
              ? adviceList
              : ['Aucun conseil disponible.'];
        } else {
          print('Champ "advice" manquant dans la réponse');
          return ['Aucun conseil disponible.'];
        }
      } else {
        print('Erreur lors de la récupération des conseils: ${response.body}');
        return ['Aucun conseil disponible.'];
      }
    } catch (e) {
      print('Erreur réseau: $e');
      return ['Erreur réseau.'];
    }
  }

  String _getProgressMessage() {
    if (goal == null || goal == 'unknown' || currentWeight == null || targetWeight == null) {
      return 'Enter your current weight to see progress.';
    }

    if (goal!.toLowerCase().contains('lose weight')) {
      return currentWeight! > targetWeight!
          ? 'You need to lose ${weightDifference!.toStringAsFixed(1)} kg to reach your target.'
          : currentWeight! < targetWeight!
              ? 'You are below your target! Consider adjusting your goal.'
              : 'Congratulations! You’ve reached your target weight!';
    } else if (goal!.toLowerCase().contains('gain weight') ||
        goal!.toLowerCase().contains('build muscle')) {
      return currentWeight! < targetWeight!
          ? 'You need to gain ${weightDifference!.toStringAsFixed(1)} kg to reach your target.'
          : currentWeight! > targetWeight!
              ? 'You have exceeded your target! Consider adjusting your goal.'
              : 'Congratulations! You’ve reached your target weight!';
    }
    return 'Progress cannot be determined. Set a valid goal.';
  }

  @override
  void dispose() {
    _currentWeightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: const Text(
          'Progress Tracking',
          style: TextStyle(
            color: Colors.black,
            fontSize: 23,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Weight Comparison',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87)),
                          const SizedBox(height: 16),
                          Text(
                            'Target Weight: ${targetWeight?.toStringAsFixed(1) ?? 'Loading...'} kg',
                            style: const TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: _currentWeightController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Current Weight (kg)',
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                              prefixIcon: const Icon(Icons.fitness_center, color: Color(0xFF7EB6FF)),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF7EB6FF), Color(0xFFB5AFFF)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: TextButton(
                              onPressed: _compareWeights,
                              child: const Text('Compare',
                                  style: TextStyle(color: Colors.white, fontSize: 18)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  if (weightDifference != null && progressPercentage != null)
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Progress Statistics',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87)),
                            const SizedBox(height: 16),
                            Text(
                              'Weight Difference: ${weightDifference!.toStringAsFixed(1)} kg',
                              style: const TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Progress Towards Goal: ${progressPercentage!.toStringAsFixed(1)}%',
                              style: const TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                            const SizedBox(height: 10),
                            LinearProgressIndicator(
                              value: progressPercentage! / 100,
                              backgroundColor: Colors.grey[200],
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                  Color(0xFF7EB6FF)),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              _getProgressMessage(),
                              style: TextStyle(
                                fontSize: 16,
                                color: (currentWeight == targetWeight ||
                                        progressPercentage == 100)
                                    ? Colors.green
                                    : Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  const SizedBox(height: 20),

                  if (_adviceList.isNotEmpty)
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      color: Colors.white,
                      shadowColor: Colors.grey.withOpacity(0.2),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Icon(
                                  Icons.lightbulb_outline,
                                  color: Color(0xFF7EB6FF),
                                  size: 24,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Advice Based on Your Goal',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: _adviceList.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(top: 6),
                                        width: 6,
                                        height: 6,
                                        decoration: const BoxDecoration(
                                          color: Color(0xFF7EB6FF),
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          _adviceList[index],
                                          style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.black87,
                                            height: 1.5,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
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