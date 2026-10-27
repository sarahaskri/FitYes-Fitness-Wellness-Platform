import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../api_config.dart';
import 'package:shared_preferences/shared_preferences.dart';


class WorkoutListPage extends StatefulWidget {
  final String workoutType;

  const WorkoutListPage({super.key, required this.workoutType});

  @override
  _WorkoutListPageState createState() => _WorkoutListPageState();
}

class _WorkoutListPageState extends State<WorkoutListPage> {
  List<dynamic> workouts = [];
  bool isLoading = true;
  String errorMessage = '';
  String? userId;

  @override
  void initState() {
    super.initState();
    _loadUserAndFetchWorkouts();
  }
  Future<void> _loadUserAndFetchWorkouts() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('userId'); 

    if (userId != null) {
      await fetchWorkouts(userId!);
    } else {
      setState(() {
        isLoading = false;
        errorMessage = 'User ID not found';
      });
      print(" Aucun userId trouvé dans SharedPreferences.");
    }
  }

  Future<void> fetchWorkouts(String userId) async {
    final url = ApiConfig.getWorkoutsByType(widget.workoutType, userId);
    print('URL: $url');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          workouts = data['workouts'] ?? [];
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'No workouts found';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Erreur de connexion: ${e.toString()}';
        isLoading = false;
      });
    }
  }

  void _confirmDelete(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmation'),
        content: const Text('Do you really want to delete this exercise?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              deletedWorkout(id);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Future<void> deletedWorkout(String id) async {
    final url = ApiConfig.deletedWorkout(id);

    try {
      final response = await http.delete(url);
      if (response.statusCode == 200) {
        setState(() {
          workouts.removeWhere((exercise) => exercise['_id'] == id);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Workout successfully deleted')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: ${response.statusCode}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur de connexion: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.workoutType} Exercises',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFFCC58F1),
      ),
      body: _buildBodyContent(),
    );
  }

  Widget _buildBodyContent() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorMessage.isNotEmpty) {
      return Center(child: Text(errorMessage));
    }

    if (workouts.isEmpty) {
      return const Center(child: Text('No exercises found.'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: workouts.length,
      itemBuilder: (context, index) {
        final exercise = workouts[index];
        return Card(
          elevation: 5,
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Stack(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    exercise['image'] != null
                        ? Image.asset(
                            exercise['image'],
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          )
                        : const Icon(Icons.fitness_center, size: 40),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            exercise['nameOfExercise'] ?? 'Exercise without a name',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(exercise['info'] ?? ''),
                          const SizedBox(height: 5),
                          Text('Date: ${exercise['date']}'),
                          const SizedBox(height: 5),
                          Text('Time: ${exercise['time']}'),
                          const SizedBox(height: 5),
                          Text(
                            'Difficulty: ${exercise['selectedDifficulty'] ?? 'Not specified'}',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: Text(
                    '${exercise['burnedCalories']?.toString() ?? 'N/A'} kcal',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.deepPurple,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    height: 36,
                    width: 36,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red.withOpacity(0.1),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.delete_outline,
                          color: Colors.redAccent, size: 18),
                      padding: EdgeInsets.zero,
                      onPressed: () => _confirmDelete(exercise['_id']),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
