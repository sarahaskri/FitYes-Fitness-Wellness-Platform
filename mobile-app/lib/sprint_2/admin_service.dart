import 'dart:convert';
import 'package:fityes/api_config.dart';
import 'package:http/http.dart' as http;
import 'package:fityes/sprint_2/mealModelAdmin.dart';

class AdminService {

Future<List<Meal>> getMealByAdmin() async {
    final baseUrl = ApiConfig.getAllMealsByAdmin();
  final response = await http.get(
    baseUrl,
    headers: { 'Content-Type': 'application/json' },
  );

  if (response.statusCode != 200) {
    throw Exception('Failed to load meals (${response.statusCode})');
  }

 
  final dynamic decoded = json.decode(response.body);

  if (decoded is List) {
    
    return (decoded as List)
        .map((e) => Meal.fromJson(e as Map<String, dynamic>))
        .toList();
  } else if (decoded is Map && decoded['meals'] is List) {
  
    return (decoded['meals'] as List)
        .map((e) => Meal.fromJson(e as Map<String, dynamic>))
        .toList();
  } else {
    throw Exception('Unexpected JSON format');
  }
}

  Future<void> addMealByAdmin(Meal meal) async {
        final baseUrl = ApiConfig.addMealByAdmin();
    await http.post(
      baseUrl,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(meal.toJson()),
    );
  }

Future<void> updateMealByAdmin(String id, Meal meal) async {
  final url = Uri.parse('${ApiConfig.baseUrl}users/updateMealByAdmin/$id'); 
  final response = await http.put(
    url,
    headers: {'Content-Type': 'application/json'},
    body: json.encode(meal.toJson()),
  );

  if (response.statusCode != 200) {
    throw Exception('Échec de la mise à jour du repas : ${response.body}');
  }
}


  Future<void> deleteMealByAdmin(String id) async {
     final baseUrl = ApiConfig.deleteMealByAdmin();
    await http.delete(Uri.parse("$baseUrl/$id"));
  }
}