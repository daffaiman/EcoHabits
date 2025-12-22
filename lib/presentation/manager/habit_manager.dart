import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../data/models/habit_model.dart';

class HabitManager extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<HabitModel> _habits = [];
  bool _isLoading = false;

  List<HabitModel> get habits => _habits;
  bool get isLoading => _isLoading;

  // --- FUNGSI 1: MENDENGARKAN DATA REALTIME (READ) ---
  void listenToHabits() {
    final user = _auth.currentUser;
    if (user == null) return;

    _isLoading = true;
    notifyListeners();

    // Mengambil data dari: users -> {uid} -> habits
    _firestore
        .collection('users')
        .doc(user.uid)
        .collection('habits')
        .orderBy('createdAt', descending: true) // Urutkan dari yang terbaru
        .snapshots() // Stream realtime
        .listen((snapshot) {
      _habits = snapshot.docs.map((doc) => HabitModel.fromSnapshot(doc)).toList();
      _isLoading = false;
      notifyListeners();
    }, onError: (e) {
      debugPrint('Error listening to habits: $e');
      _isLoading = false;
      notifyListeners();
    });
  }

  // --- FUNGSI 2: TAMBAH DATA (CREATE) ---
  Future<void> addHabit({
    required String title,
    required String description,
    required String category,
    required String frequency,
    required TimeOfDay reminderTime,
  }) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final String timeString =
        '${reminderTime.hour.toString().padLeft(2, '0')}:${reminderTime.minute.toString().padLeft(2, '0')}';

    final newHabit = {
      'title': title,
      'description': description,
      'category': category,
      'frequency': frequency,
      'reminderTime': timeString,
      'completedDates': [], // Awalnya kosong
      'createdAt': FieldValue.serverTimestamp(),
    };

    // Ini akan otomatis membuat collection 'habits' jika belum ada
    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('habits')
        .add(newHabit);
  }

  // --- FUNGSI 3: CEKLIS/UNCEKLIS (UPDATE) ---
  Future<void> toggleHabitCompletion(String habitId, bool isCurrentlyCompleted) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final today = DateTime.now().toIso8601String().split('T')[0];
    final docRef = _firestore.collection('users').doc(user.uid).collection('habits').doc(habitId);

    if (isCurrentlyCompleted) {
      // Jika sudah selesai, hapus tanggal hari ini (Undo)
      await docRef.update({
        'completedDates': FieldValue.arrayRemove([today])
      });
    } else {
      // Jika belum, tambahkan tanggal hari ini (Complete)
      await docRef.update({
        'completedDates': FieldValue.arrayUnion([today])
      });
    }
  }

  // --- FUNGSI 4: HAPUS DATA (DELETE) ---
  Future<void> deleteHabit(String habitId) async {
    final user = _auth.currentUser;
    if (user == null) return;

    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('habits')
        .doc(habitId)
        .delete();
  }
}