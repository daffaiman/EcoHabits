import 'package:cloud_firestore/cloud_firestore.dart';

class HabitModel {
  final String id;
  final String title;
  final String description;
  final String category;
  final String frequency;
  final String reminderTime;
  final List<String> completedDates; // List tanggal selesai (format YYYY-MM-DD)

  HabitModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.frequency,
    required this.reminderTime,
    required this.completedDates,
  });

  // Helper: Cek apakah habit sudah selesai hari ini
  bool get isCompletedToday {
    final today = DateTime.now().toIso8601String().split('T')[0];
    return completedDates.contains(today);
  }

  // Dari Firebase Document ke Object Dart
  factory HabitModel.fromSnapshot(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return HabitModel(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      category: data['category'] ?? 'General',
      frequency: data['frequency'] ?? 'Daily',
      reminderTime: data['reminderTime'] ?? '08:00',
      completedDates: List<String>.from(data['completedDates'] ?? []),
    );
  }

  // Dari Object Dart ke Map (untuk dikirim ke Firebase)
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'category': category,
      'frequency': frequency,
      'reminderTime': reminderTime,
      'completedDates': completedDates,
      'createdAt': FieldValue.serverTimestamp(), // Penting untuk sorting
    };
  }
}