import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fityes/sprint_2/mealModelAdmin.dart';
import 'package:fityes/sprint_2/admin_service.dart';

class UpdateMealByadmin extends StatefulWidget {
  final Meal meal;

  UpdateMealByadmin({required this.meal});

  @override
  _UpdateMealByadminState createState() => _UpdateMealByadminState();
}

class _UpdateMealByadminState extends State<UpdateMealByadmin> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController nameController;
  late TextEditingController timeController;
  String selectedType = 'Breakfast';
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.meal.mealName);
    selectedType = widget.meal.mealType;
    timeController = TextEditingController(text: widget.meal.time);
    selectedDate = DateTime.parse(widget.meal.date);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) setState(() => selectedDate = picked);
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 8, minute: 0),
    );
    if (picked != null) {
      final formattedTime = picked.format(context);
      timeController.text = formattedTime;
    }
  }

  void _updateMeal() async {
    if (_formKey.currentState!.validate()) {
      final updatedMeal = Meal(
        id: widget.meal.id,
        mealName: nameController.text,
        mealType: selectedType,
        date: DateFormat('yyyy-MM-dd').format(selectedDate),
        time: timeController.text,
        description: widget.meal.description,
        imagePath: widget.meal.imagePath,
        nutrition: widget.meal.nutrition,
      );

      await AdminService().updateMealByAdmin(widget.meal.id, updatedMeal);
      Navigator.pop(context, true); 
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Modifier le repas")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nom du repas'),
                validator: (value) => value!.isEmpty ? 'Champ requis' : null,
              ),
              DropdownButtonFormField<String>(
                value: selectedType,
                decoration: const InputDecoration(labelText: 'Type'),
                items: ['Breakfast', 'Lunch', 'Dinner']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (val) => setState(() => selectedType = val!),
              ),
              TextFormField(
                readOnly: true,
                controller: TextEditingController(
                    text: DateFormat('yyyy-MM-dd').format(selectedDate)),
                onTap: () => _selectDate(context),
                decoration: const InputDecoration(labelText: 'Date'),
              ),
              TextFormField(
                controller: timeController,
                readOnly: true,
                onTap: () => _selectTime(context),
                decoration: const InputDecoration(labelText: 'Heure'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateMeal,
                child: const Text("Mettre à jour"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
