import 'dart:convert';
import 'package:fityes/api_config.dart';
import 'package:fityes/home.dart';
import 'package:fityes/sprint_1/LoginPage.dart';
import 'package:fityes/sprint_1/editProfile.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DataProfile extends StatefulWidget {
  const DataProfile({super.key});

  @override
  _DataProfileState createState() => _DataProfileState();
}

class _DataProfileState extends State<DataProfile> {
  String firstname = '';
  String lastname = '';
  String email = '';
  String password = '';
  String weight = '';
  String height = '';
  String age = '';
  String goal = 'unknown';
  String sexe = '';

  bool isLoading = false;
  String? userId;

  @override
  void initState() {
    super.initState();
    _loadUserIdAndFetchData();
  }



  Future<void> _loadUserIdAndFetchData() async {
  setState(() {
    isLoading = true; 
  });

  final prefs = await SharedPreferences.getInstance();
  final storedUserId = prefs.getString('userId');

  setState(() {
    userId = storedUserId;
    print(" userId in DataProfile: $userId");
  });

  if (userId != null) {
    await fetchAdherentData();
  } else {
    setState(() {
      isLoading = false;
    });
  }
}

  Future<Map<String, dynamic>?> getAdherent(String userId) async {
    final url = ApiConfig.getAdherentById(userId);
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print('Error: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Network error: $e');
      return null;
    }
  }

  Future<void> fetchAdherentData() async {
    if (userId == null) return;

    final data = await getAdherent(userId!);
    if (data != null) {
      setState(() {
        firstname = data['firstname']?.toString() ?? '';
        lastname = data['lastname']?.toString() ?? '';
        email = data['email']?.toString() ?? '';
        password = data['password']?.toString() ?? '';
        weight = data['weight']?.toString() ?? '';
        height = data['height']?.toString() ?? '';
        age = data['age']?.toString() ?? '';
        sexe = data['gender']?.toString() ?? '';
      });
    }

   
    try {
      final goalResponse = await http.get(
        Uri.parse('${ApiConfig.baseUrl}users/getGoal/$userId'),
      );
      if (goalResponse.statusCode == 200) {
        final goalData = json.decode(goalResponse.body);
        setState(() {
          goal = goalData['goal'] ?? 'unknown';
        });
      } else {
        setState(() {
          goal = 'unknown';
          print('Goal does not exist');
        });
      }
    } catch (e) {
      setState(() {
        goal = 'unknown';
        print('Error retrieving goal: $e');
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
        title: const Text('Profile'),
        titleTextStyle: const TextStyle(
          fontSize: 23,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Center(
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: AssetImage(
                            sexe == 'Female'
                                ? 'assets/images/beauty.png'
                                : 'assets/images/boy.png',
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '$firstname $lastname',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Want to edit your profil ?',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit,
                              color: Color(0xFF9fbef7), size: 30),
                          onPressed: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditProfile(
                                  firstname: firstname,
                                  lastname: lastname,
                                  email: email,
                                  password: password,
                                  weight: weight,
                                  height: height,
                                  age: age,
                                  goal: goal,
                                ),
                              ),
                            );
                            if (result == true) {
                            
                              fetchAdherentData();
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Recomandcard1(title: 'Your goal is', goal: goal),
                  ),
                  const SizedBox(height: 20),
                  AccountCard(
                    firstname: firstname,
                    lastname: lastname,
                    email: email,
                    password: '......', 
                    weight: weight,
                    height: height,
                    goal: goal,
                    age: age,
                  ),
                  const SizedBox(height: 10),
                  const AccountCard2(),
                ],
              ),
            ),
    );
  }
}

class Recomandcard1 extends StatelessWidget {
  final String title;
  final String goal;

  const Recomandcard1({
    super.key,
    required this.title,
    required this.goal,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color.fromARGB(255, 189, 210, 255), Color(0xFFf8f8fc)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            goal,
            style: const TextStyle(
              fontSize: 20,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

class AccountCard extends StatelessWidget {
  final String firstname;
  final String lastname;
  final String email;
  final String password;
  final String weight;
  final String height;
  final String age;
  final String goal;

  const AccountCard({
    super.key,
    required this.firstname,
    required this.lastname,
    required this.email,
    required this.password,
    required this.weight,
    required this.height,
    required this.age,
    required this.goal,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Account Information',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            _buildOption(Icons.person, 'First Name', firstname),
            _buildOption(Icons.person, 'Last Name', lastname),
            _buildOption(Icons.email, 'Email', email),
            _buildOption(Icons.lock, 'Password',
                '•••••••••••••••'), 
            _buildOption(Icons.fitness_center, 'Weight', weight),
            _buildOption(Icons.straighten, 'Height', height),
            _buildOption(Icons.track_changes, 'Goal', goal),
            _buildOption(Icons.calendar_month, 'Age', age),
          ],
        ),
      ),
    );
  }

  Widget _buildOption(IconData icon, String title, String value) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF9fbef7), size: 30),
      title: Text(title),
      subtitle: Text(value.isEmpty ? 'Not set' : value),
    );
  }
}

class AccountCard2 extends StatelessWidget {
  const AccountCard2({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildOption(context, Icons.logout, 'Logout'),
            _buildOption(context, Icons.delete, 'Delete account'),
          ],
        ),
      ),
    );
  }

  Widget _buildOption(BuildContext context, IconData icon, String title) {
    void _logout(BuildContext context) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear(); 
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    }

    void _deleteAccount(BuildContext context) async {
      final prefs = await SharedPreferences.getInstance();
      final userId =
          prefs.getString('userId'); 

      if (userId == null) {
        print(' User ID is null');
        return;
      }

      try {
        final url = ApiConfig.deleteAdherent(userId);
        final response = await http.delete(
          url,
          headers: {'Content-Type': 'application/json'},
        );

        if (response.statusCode == 200) {
          await prefs.clear(); 
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => Home()),
          );
          print(' Compte supprimé avec succès');
        } else {
          print(' Échec de suppression du compte : ${response.body}');
        }
      } catch (e) {
        print(' Erreur lors de la suppression du compte : $e');
      }
    }

   return ListTile(
  leading: Icon(icon, color: Colors.red, size: 30),
  title: Text(title, style: const TextStyle(color: Colors.red)),
  onTap: () {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title == 'Logout' ? 'Confirm Logout' : 'Confirm Account Deletion'),
          content: Text(
            title == 'Logout'
                ? 'Are you sure you want to log out?'
                : 'Are you sure you want to delete your account? This action is irreversible.',
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Confirm', style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.of(context).pop(); 
                if (title == 'Logout') {
                  _logout(context);
                } else if (title == 'Delete account') {
                  _deleteAccount(context);
                }
              },
            ),
          ],
        );
      },
    );
  },
);

  }
}
