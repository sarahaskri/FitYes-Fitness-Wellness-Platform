import 'dart:convert';
import 'package:fityes/api_config.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NutritionBarChart extends StatefulWidget {
  final String userId;
  final String selectedFrequency; 

  const NutritionBarChart({
    super.key,
    required this.userId,
    required this.selectedFrequency,
  });

  @override
  _NutritionBarChartState createState() => _NutritionBarChartState();
}

class _NutritionBarChartState extends State<NutritionBarChart> {
  Map<String, dynamic>? data;

  @override
  void initState() {
    super.initState();
    fetchNutritionStats();
  }

  @override
  void didUpdateWidget(covariant NutritionBarChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedFrequency != widget.selectedFrequency) {
      fetchNutritionStats();
    }
  }
  Future<void> fetchNutritionStats() async {
    final url = Uri.parse(
      
        '${ApiConfig.baseUrl}users/getNutritionStats/${widget.userId}');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      setState(() {
        data = json[widget.selectedFrequency.toLowerCase()];
      });
    } else {
      print("Erreur API: ${response.body}");
    }
  }

  @override
  Widget build(BuildContext context) {
    final nutrients = ['Proteins', 'Fats', 'Carbs'];
    final screenWidth = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: Text(
            "Your ${widget.selectedFrequency} Nutrition Progress",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        data == null
            ? const Center(child: CircularProgressIndicator())
            : SizedBox(
                width: double.infinity,
                height: screenWidth * 0.5,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      maxY: _getMaxY(data!, nutrients),
                      barTouchData: BarTouchData(
                        enabled: true,
                        touchTooltipData: BarTouchTooltipData(
                          getTooltipItem: (group, groupIndex, rod, rodIndex) {
                            return BarTooltipItem(
                              "${rod.toY.toStringAsFixed(1)}g",
                              const TextStyle(color: Colors.black),
                            );
                          },
                        ),
                      ),
                      titlesData: FlTitlesData(
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, _) {
                              if (value.toInt() < 0 ||
                                  value.toInt() >= nutrients.length) {
                                return const Text('');
                              }
                              return Text(
                                nutrients[value.toInt()],
                                style: const TextStyle(fontSize: 12),
                              );
                            },
                          ),
                        ),
                        leftTitles: const AxisTitles(
                          sideTitles:
                              SideTitles(showTitles: true, reservedSize: 32),
                        ),
                        rightTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                        topTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                      ),
                      barGroups: List.generate(nutrients.length, (i) {
                        final nutrient = nutrients[i];
                        final actual = double.tryParse(
                                data![nutrient]?['actual'].toString() ?? '0') ??
                            0;
                        final target = double.tryParse(
                                data![nutrient]?['target'].toString() ?? '0') ??
                            0;

                        return BarChartGroupData(
                          x: i,
                          barRods: [
                            BarChartRodData(
                                toY: actual, width: 4, color: const Color(0xFF9fbef7)),
                            BarChartRodData(
                                toY: target, width: 4, color: const Color(0xFFB5AFFF)),
                          ],
                        );
                      }),
                    ),
                  ),
                ),
              ),
        const SizedBox(height: 12),
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LegendItem(color: Color(0xFF9fbef7), label: "Consumed"),
            SizedBox(width: 16),
            LegendItem(color: Color(0xFFB5AFFF), label: "Target"),
          ],
        )
      ],
    );
  }

  double _getMaxY(Map<String, dynamic> data, List<String> nutrients) {
    double maxVal = 0;
    for (var nutrient in nutrients) {
      final a =
          double.tryParse(data[nutrient]?['actual'].toString() ?? '0') ?? 0;
      final t =
          double.tryParse(data[nutrient]?['target'].toString() ?? '0') ?? 0;
      maxVal = [maxVal, a, t].reduce((a, b) => a > b ? a : b);
    }
    return (maxVal * 1.2).ceilToDouble();
  }
}

class LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const LegendItem({super.key, required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 12, height: 12, color: color),
        const SizedBox(width: 4),
        Text(label),
      ],
    );
  }
}
