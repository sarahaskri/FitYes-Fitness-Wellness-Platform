import 'dart:convert';
import 'package:fityes/api_config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  List notifications = [];
  String? storedUserIdGlobal;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadUserIdAndFetchNotifications();
  }

  Future<void> _loadUserIdAndFetchNotifications() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    final prefs = await SharedPreferences.getInstance();
     final storedUserId = prefs.getString('userId');
    storedUserIdGlobal = storedUserId;

    if (storedUserIdGlobal != null) {
      print(" userId in NotificationPage: $storedUserIdGlobal");
      await sendTodayExerciseRequest();
      await fetchNotifications();
    } else {
      setState(() {
        errorMessage = "User ID not found";
        isLoading = false;
      });
    }
  }

  Future<void> fetchNotifications() async {
    try {
      final res = await http.get(
        Uri.parse('${ApiConfig.baseUrl}users/getNotifications/$storedUserIdGlobal'),
      );

      if (res.statusCode == 200) {
        setState(() {
          notifications = jsonDecode(res.body);
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = "Error (${res.statusCode})when loading notifications";
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = "Connection error: $e";
        isLoading = false;
      });
    }
  }

  Future<void> sendTodayExerciseRequest() async {
    if (storedUserIdGlobal == null) return;

    try {
      final res = await http.post(
        Uri.parse('${ApiConfig.baseUrl}users/todayExercice'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'userId': storedUserIdGlobal}),
      );

      if (res.statusCode == 200) {
        print(" Daily notification generated: ${res.body}");
        await fetchNotifications();
      } else {
        print("  todayExercice error  (${res.statusCode}): ${res.body}");
      }
    } catch (e) {
      print(" Exception during todayExercice: $e");
    }
  }

  Future<void> deleteNotification(String notificationId) async {
    try {
      final res = await http.delete(
        Uri.parse(
            '${ApiConfig.baseUrl}users/deleteNotification/$notificationId'),
      );

      if (res.statusCode == 200) {
        setState(() {
          notifications.removeWhere((n) => n['_id'] == notificationId);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Notification removed')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error while deleting')),
        );
      }
    } catch (e) {
      print("Error deletion : $e");
    }
  }

  void confirmDelete(String notificationId) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirmation'),
        content: const Text('Remove this notification ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              deleteNotification(notificationId);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 23,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(child: Text(errorMessage!))
              : notifications.isEmpty
                  ? const Center(child: Text("No notifications available"))
                  : ListView.builder(
                      itemCount: notifications.length,
                      itemBuilder: (context, index) {
                        final notif = notifications[index];
                        final formattedDate = (notif['date'] != null)
                            ? notif['date'].toString().substring(0, 10)
                            : '';

                        return Card(
                          margin: const EdgeInsets.symmetric(
                              vertical: 6, horizontal: 12),
                          child: ListTile(
                            title: Text(notif['title'] ?? 'without title'),
                            subtitle: Text(notif['body'] ?? 'No contenu'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  formattedDate,
                                  style: const TextStyle(color: Colors.grey),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                  onPressed: () => confirmDelete(notif['_id']),
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
