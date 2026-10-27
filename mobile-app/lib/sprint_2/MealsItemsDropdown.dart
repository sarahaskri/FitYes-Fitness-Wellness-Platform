import 'package:flutter/material.dart';

class MealNutritionsDropdown extends StatefulWidget {
  final Function(String) onValueChanged;

  const MealNutritionsDropdown({Key? key, required this.onValueChanged}) : super(key: key);

  @override
  _MealNutritionsDropdownState createState() => _MealNutritionsDropdownState();
}

class _MealNutritionsDropdownState extends State<MealNutritionsDropdown> {
  String selectedValue = "Weekly"; 

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF9fbef7),
        borderRadius: BorderRadius.circular(40),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: DropdownButton<String>(
        value: selectedValue,
        dropdownColor: const Color(0xFF9fbef7),
        underline: const SizedBox(),
        iconEnabledColor: Colors.white,
        items: const [
          DropdownMenuItem(
            value: "Daily",
            child: Text("Daily", style: TextStyle(color: Colors.white)),
          ),
          DropdownMenuItem(
            value: "Weekly",
            child: Text("Weekly", style: TextStyle(color: Colors.white)),
          ),
          DropdownMenuItem(
            value: "Monthly",
            child: Text("Monthly", style: TextStyle(color: Colors.white)),
          ),
        ],
        onChanged: (value) {
          setState(() {
            selectedValue = value!;
            widget.onValueChanged(value); 
          });
        },
      ),
    );
  }
}
