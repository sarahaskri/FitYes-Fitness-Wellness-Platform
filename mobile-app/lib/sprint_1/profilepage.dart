import 'dart:convert';
import 'package:fityes/sprint_1/goal.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fityes/api_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  final String email; 
  const ProfilePage({super.key, required this.email});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}
class _ProfilePageState extends State<ProfilePage> {
 
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();

 
  String? _selectedGender;


Future<void> updateProfile(String email, String gender, int age,
      double weight, double height) async {
    final baseUrl = ApiConfig.addProfileInformation();

    final response = await http.put(
      baseUrl,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": email,
        "gender": gender,
        "age": age,
        "weight": weight,
        "height": height,
      }),
    );

    if (!mounted) return; 

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      print(response.body);

      if (responseData['message'] == 'Informations mises à jour avec succès') {
        final prefs = await SharedPreferences.getInstance();
        final userId = prefs.getString('userId'); 

        if (userId != null) {
          print(' userID dans la page de profile avant goal: $userId');
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => GoalPage(userId: userId)),
          );
          print(' Navigation vers GoalPage exécutée');
        } else {
          _showErrorDialog('Aucun userId trouvé. Veuillez vous reconnecter.');
        }
      } else {
        _showErrorDialog(responseData['message'] ??
            'Erreur lors de la mise à jour du profil');
      }
    } else {
      _showErrorDialog('Erreur de connexion au serveur.');
    }
  }


  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Erreur'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              
              Container(
                height: 260,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20), 
                  boxShadow: const [],
                ),
                child: ClipRRect(
                  borderRadius:
                      BorderRadius.circular(20), 
                  child: Image.asset(
                    'assets/images/profilepage.png', 
                    fit: BoxFit.cover, 
                  ),
                ),
              ),
              const SizedBox(height: 20),
          
              const Text(
                "Let's complete your profile",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              
              const Text(
                "It will help us to know more about you!",
                style: TextStyle(fontSize: 15, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
            
              CustomDropdown(
                icon: Icons.person_outline,
                label: 'Choose Gender',
                items: ['Male', 'Female'],
                onChanged: (value) {
                  setState(() {
                    _selectedGender = value;
                  });
                },
              ),
              const SizedBox(height: 15),
             
              CustomTextField(
                controller: _ageController,
                icon: Icons.calendar_today_outlined,
                label: 'Your Age',
                unit: 'Years',
              ),
              const SizedBox(height: 15),
             
              CustomTextField(
                controller: _weightController,
                icon: Icons.monitor_weight,
                label: 'Your Weight',
                unit: 'KG',
              ),
              const SizedBox(height: 15),
             
              CustomTextField(
                controller: _heightController,
                icon: Icons.height,
                label: 'Your Height',
                unit: 'CM',
              ),
              const SizedBox(height: 20),
              
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton(
                    onPressed: () {
                     
                      if (_selectedGender != null &&
                          _ageController.text.isNotEmpty &&
                          _weightController.text.isNotEmpty &&
                          _heightController.text.isNotEmpty) {
                      

                        String gender = _selectedGender!;
                        int age = int.parse(_ageController.text);
                        double weight = double.parse(_weightController.text);
                        double height = double.parse(_heightController.text);

                        updateProfile(
                            widget.email, gender, age, weight, height);
                      } else {
                       
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Please fill all fields')),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 15,
                      ),
                      backgroundColor:
                          const Color(0xFF9fbef7), 
                    ),
                    child: const Text(
                      'Next',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}


class CustomDropdown extends StatefulWidget {
  final IconData icon;
  final String label;
  final List<String> items;
  final Function(String?) onChanged;

  const CustomDropdown({
    super.key,
    required this.icon,
    required this.label,
    required this.items,
    required this.onChanged,
  });

  @override
  _CustomDropdownState createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(widget.icon, color: Colors.grey),
          const SizedBox(width: 10),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                hint: Text(
                  widget.label,
                  style: const TextStyle(color: Colors.grey), 
                ),
                value: selectedValue,
                items: widget.items
                    .map((item) => DropdownMenuItem<String>(
                        value: item, child: Text(item)))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedValue = value;
                  });
                  widget.onChanged(value); 
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class CustomTextField extends StatelessWidget {
  final IconData icon;
  final String label;
  final String unit;
  final TextEditingController controller;

  const CustomTextField({
    super.key,
    required this.icon,
    required this.label,
    required this.unit,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(icon, color: Colors.grey),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      hintText: label,
                      hintStyle: const TextStyle(
                        color: Colors.grey, 
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFE3ACF9), Color(0xFFB085F5)], 
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            unit,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
