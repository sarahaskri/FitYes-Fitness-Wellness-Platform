import 'package:flutter/material.dart';

class Todaymealdropdownstate extends StatefulWidget {
  final Function(String) onValueChanged;

  const Todaymealdropdownstate({Key? key, required this.onValueChanged}) : super(key: key);

  @override
  _Todaymealdropdownstate createState() => _Todaymealdropdownstate();
}

class _Todaymealdropdownstate extends State<Todaymealdropdownstate> {
  String selectedValue = "Breakfast"; 

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
            value: "Breakfast",
            child: Text("Breakfast", style: TextStyle(color: Colors.white)),
          ),
          DropdownMenuItem(
            value: "Lunch",
            child: Text("Lunch", style: TextStyle(color: Colors.white)),
          ),
          DropdownMenuItem(
            value: "Dinner",
            child: Text("Dinner", style: TextStyle(color: Colors.white)),
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
