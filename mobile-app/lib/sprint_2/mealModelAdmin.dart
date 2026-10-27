class Meal {
  final String id;
  final String mealName;
  final String mealType;
  final String description;
  final Map<String, String> nutrition;
  final String imagePath;
  final String date;
  final String time;
  String? role;
 

  Meal({
    required this.id,
    required this.mealName,
    required this.mealType,
    required this.description,
    required this.nutrition,
    required this.imagePath,
    required this.date,
    required this.time,
    this.role,
    

  });

  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      id: json['_id'] ?? '', 
      mealName: json['mealName'] ??
          json['name'] ??
          'Unnamed Meal', 
      mealType: json['mealType'] ?? 'Uncategorized',
      description: json['description'] ?? '',
      nutrition: json['nutrition'] != null
          ? Map<String, String>.from(
              json['nutrition'].map((k, v) => MapEntry(k, v?.toString() ?? '')))
          : <String, String>{}, 
      imagePath: json['imagePath'] ?? '',
      date: json['date'] ?? '',
      time: json['time'] ?? '',
        role: json['role'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'mealName': mealName,
      'mealType': mealType,
      'description': description,
      'nutrition': nutrition,
      'imagePath': imagePath,
      'date': date,
      'time': time,
        'role': role,
    };
  }
}
