import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../api_config.dart';


class AddExercicePage extends StatefulWidget {
  final String exerciseName;
  final String workoutName;
  final String imagePath;
  final int caloriesBurned; 
  final String level;
  final String description;
  final String info;

  const AddExercicePage({
    super.key,
    required this.exerciseName,
    required this.workoutName,
    required this.imagePath,
    required this.caloriesBurned, 
    required this.level,
    required this.description,
    required this.info,
  });

  @override
  _AddExercicePageState createState() => _AddExercicePageState();
}

class _AddExercicePageState extends State<AddExercicePage> {
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
        title: Text('Add Exercise to ${widget.workoutName}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
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
                  addExerciseToDatabase(
                    date: dateController.text,
                    time: timeController.text,
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please fill all fields')),
                  );
                }
              },
              child: const Text('Add Exercise'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> addExerciseToDatabase({
    required String date,
    required String time,
  }) async {
    final baseUrl = ApiConfig.addExercise();
    final response = await http.post(
      baseUrl,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "userId": userId,
        "image": widget.imagePath,
        "nameOfExercise": widget.exerciseName,
        "nameOfWorkout": widget.workoutName,
        "burnedCalories": widget.caloriesBurned.toString(), 
        "selectedDifficulty": widget.level,
        "description": widget.description,
        "info": widget.info,
        "date": date,
        "time": time,
      }),
    );
     
    print("Status: ${response.statusCode}");
    print("Body: ${response.body}");

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Exercise added successfully')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to add exercise')),
      );
    }
  }
}
