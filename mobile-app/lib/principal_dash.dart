import 'package:fityes/sprint_2/admin_dashboard_sprint2.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class AdminDashboardPage extends StatefulWidget {
  @override
  _AdminDashboardPageState createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  int selectedIndex = 0;
  bool isMenuOpen = false;

  final List<String> menuItems = [
    'Home', 'Admins', 'Users', 'Meals', 'Workouts', 'Notifications'
  ];

  final List<IconData> menuIcons = [
    LucideIcons.home,
    LucideIcons.userCog,
    LucideIcons.users,
    LucideIcons.chefHat,
    LucideIcons.dumbbell,
    LucideIcons.bell
  ];

  final List<Widget> pages = [
    HomePage(),
    AdminsPage(),
    UsersPage(),
    AdminDashboard(),
    WorkoutsPage(),
    NotificationsPage(),
  ];

  void _toggleMenu() {
    setState(() {
      isMenuOpen = !isMenuOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            width: isMenuOpen ? 240 : 80,
            color: Colors.white,
            child: Column(
              children: [
                const SizedBox(height: 40),
                IconButton(
                  icon: Icon(
                    isMenuOpen ? LucideIcons.x : LucideIcons.menu,
                    size: 30,
                    color: Colors.deepPurple,
                  ),
                  onPressed: _toggleMenu,
                ),
                const SizedBox(height: 30),
                for (int i = 0; i < menuItems.length; i++)
                  _buildMenuTile(i),
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${menuItems[selectedIndex]} Dashboard',
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(child: pages[selectedIndex]),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuTile(int index) {
    return Tooltip(
      message: isMenuOpen ? '' : menuItems[index],
      child: ListTile(
        leading: Icon(
          menuIcons[index],
          color: selectedIndex == index
              ? Colors.deepPurple
              : Colors.black54,
        ),
        title: isMenuOpen
            ? Text(
                menuItems[index],
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: selectedIndex == index
                      ? Colors.deepPurple
                      : Colors.black87,
                ),
              )
            : null,
        minLeadingWidth: 20,
        dense: true,
        selected: selectedIndex == index,
        onTap: () {
          setState(() {
            selectedIndex = index;
            if (!isMenuOpen) _toggleMenu();
          });
        },
      ),
    );
  }
}

class MealsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          childAspectRatio: 1.5,
        ),
        itemCount: 12,
        itemBuilder: (context, index) {
          return Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Meal ${index + 1}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Détails du repas',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Contenu de la page Accueil'));
  }
}

class AdminsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Gestion des administrateurs'));
  }
}

class UsersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Gestion des utilisateurs'));
  }
}

class WorkoutsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Gestion des entraînements'));
  }
}

class NotificationsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Gestion des notifications'));
  }
}