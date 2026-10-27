import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:fityes/sprint_2/mealModelAdmin.dart';
import 'package:fityes/sprint_2/admin_service.dart';
import 'package:image_picker/image_picker.dart';

class AddMealByAdmin extends StatefulWidget {
  @override
  _AddMealByAdminState createState() => _AddMealByAdminState();
}

class _AddMealByAdminState extends State<AddMealByAdmin> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  String selectedType = 'Breakfast';
  String? imagePath;
  final ImagePicker _picker = ImagePicker();

  String? role;

  @override
  void initState() {
    super.initState();
    _loadUserRole();
  }

  Future<void> _loadUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    final storedRole = prefs.getString('role');

    setState(() {
      role = storedRole;
      print(" Rôle chargé dans addMealByAdmin : $role");
    });
  }

  Future<void> _selectImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        imagePath = pickedFile.path;
      });
    }
  }

  void _addMeal() async {
    if (_formKey.currentState!.validate()) {
      String base64Image = '';
      if (imagePath != null) {
        final bytes = await File(imagePath!).readAsBytes();
        base64Image = base64Encode(bytes);
      }

      final newMeal = Meal(
        mealName: nameController.text,
        mealType: selectedType,
        description: '',
        imagePath: base64Image,
        nutrition: {},
        id: '',
        role: role,
       date: '', time: '',
      );

      await AdminService().addMealByAdmin(newMeal);
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Ajouter un repas")),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Nom du repas'),
                validator: (value) =>
                    value!.isEmpty ? 'Champ requis' : null,
              ),
              DropdownButtonFormField<String>(
                value: selectedType,
                decoration: InputDecoration(labelText: 'Type'),
                items: ['Breakfast', 'Lunch', 'Dinner']
                    .map((e) =>
                        DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (val) => setState(() => selectedType = val!),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _selectImage,
                child: Text("Sélectionner une image"),
              ),
              if (imagePath != null)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Image.file(
                    File(imagePath!),
                    height: 150,
                    width: 150,
                    fit: BoxFit.cover,
                  ),
                ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addMeal,
                child: Text("Ajouter"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
