import 'package:fityes/sprint_3/addExercice.dart';
import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';

class ExerciseDetailPage extends StatefulWidget {
  final Map<String, dynamic> exerciseData;

  const ExerciseDetailPage({Key? key, required this.exerciseData})
      : super(key: key);

  @override
  State<ExerciseDetailPage> createState() => _ExerciseDetailPageState();
}

class _ExerciseDetailPageState extends State<ExerciseDetailPage> {
  late int caloriesBurned;
  late String customRep;
  late int baseRepInt;
  int customRepInt = 0;
  int multiplier = 1;
  late String level;

  int finalCalories = 0;
  int finalReps = 0;

  @override
  void initState() {
    super.initState();
    caloriesBurned =
        int.tryParse(widget.exerciseData["calories"].toString()) ?? 0;
    customRep = widget.exerciseData["info"].replaceAll('x', '');
    baseRepInt = int.tryParse(customRep) ?? 0;
    customRepInt = baseRepInt;
    level = widget.exerciseData["level"];

    if (level == "Hard") multiplier = 3;

    finalCalories = caloriesBurned * multiplier;
    finalReps = baseRepInt * multiplier;
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    final List<Map<String, String>> steps =
        (widget.exerciseData["steps"] as List<dynamic>?)
                ?.cast<Map<String, String>>() ??
            [];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.asset(
                          widget.exerciseData["image"],
                          width: double.infinity,
                          height: media.width * 0.8,
                          fit: BoxFit.cover,
                        ),
                    
                        Positioned(
                          top: 20,
                          left: 10,
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back,
                                color: Color.fromARGB(255, 0, 0, 0), size: 28),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.exerciseData["name"],
                            style: const TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            "${widget.exerciseData["level"]} | ${widget.exerciseData["calories"]} Calories Burn",
                            style: const TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            "Descriptions",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          ReadMoreText(
                            widget.exerciseData["description"],
                            trimLines: 2,
                            trimMode: TrimMode.Line,
                            trimCollapsedText: ' Read More...',
                            trimExpandedText: ' Read Less',
                            style: const TextStyle(
                                fontSize: 14, color: Colors.grey),
                            moreStyle: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "How To Do It",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "${steps.length} Steps",
                                style: const TextStyle(color: Colors.grey),
                              )
                            ],
                          ),
                          const SizedBox(height: 15),
                          ...steps.asMap().entries.map((entry) {
                            final index = entry.key + 1;
                            final step = entry.value;
                            return Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      children: [
                                        CircleAvatar(
                                          radius: 12,
                                          backgroundColor:
                                              Colors.purple.shade100,
                                          child: Text(
                                            index.toString().padLeft(2, '0'),
                                            style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.purple),
                                          ),
                                        ),
                                        if (index != steps.length)
                                          Container(
                                            width: 2,
                                            height: 40,
                                            color: Colors.purple.shade100,
                                          ),
                                      ],
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            step["title"]!,
                                            style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            step["desc"]!,
                                            style: const TextStyle(
                                                fontSize: 13,
                                                color: Colors.grey),
                                          ),
                                          const SizedBox(height: 20),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          }).toList(),
                          const SizedBox(height: 20),
                          DropdownButton<int>(
                            value: customRepInt,
                            items: [
                              DropdownMenuItem(
                                value: baseRepInt,
                                child: Text("$baseRepInt times"),
                              ),
                              DropdownMenuItem(
                                value: baseRepInt * 2,
                                child: Text("${baseRepInt * 2} times"),
                              ),
                              DropdownMenuItem(
                                value: baseRepInt * 3,
                                child: Text("${baseRepInt * 3} times"),
                              ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                customRepInt = value!;
                                int factor = (customRepInt ~/ baseRepInt);
                                finalCalories = caloriesBurned * factor;
                                finalReps = baseRepInt * factor;
                              });
                            },
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            "Custom Repetitions",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 15),
                          Row(
                            children: [
                              const Icon(Icons.local_fire_department,
                                  color: Colors.redAccent, size: 18),
                              const SizedBox(width: 8),
                              Text(
                                "$finalCalories Calories Burn",
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.grey),
                              ),
                              const Spacer(),
                              Text(
                                "$finalReps times",
                                style: const TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 55),
                  backgroundColor: const Color.fromARGB(255, 176, 201, 255),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddExercicePage(
                                exerciseName: widget.exerciseData["name"],
                                workoutName: widget.exerciseData["workoutName"],
                                imagePath: widget.exerciseData["image"],
                                caloriesBurned: finalCalories,
                                level: widget.exerciseData["level"],
                                description: widget.exerciseData["description"],
                                info: "$finalReps x",
                              )));
                },
                child: const Text("Save",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
