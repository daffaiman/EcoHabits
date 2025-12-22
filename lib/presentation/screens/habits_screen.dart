import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../manager/habit_manager.dart'; // Sesuaikan path

class HabitsScreen extends StatefulWidget {
  const HabitsScreen({super.key});

  @override
  State<HabitsScreen> createState() => _HabitsScreenState();
}

class _HabitsScreenState extends State<HabitsScreen> {
  final List<String> _filters = ['All', 'Morning', 'Afternoon', 'Night'];
  String _selectedFilter = 'All';

  @override
  void initState() {
    super.initState();
    // Panggil data saat halaman pertama kali dibuka
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<HabitManager>(context, listen: false).listenToHabits();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9F6),
      appBar: AppBar(
        title: const Text('My Habits', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.green[900],
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          // --- SEARCH & FILTER SECTION (UI SAMA) ---
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Search habits...',
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    prefixIcon: Icon(Icons.search, color: Colors.green[600]),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                  ),
                  onChanged: (value) {
                    // Fitur search bisa diimplementasikan di sini nanti
                  },
                ),
                const SizedBox(height: 16),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _filters.map((filter) {
                      final isSelected = _selectedFilter == filter;
                      return Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: ChoiceChip(
                          label: Text(filter),
                          selected: isSelected,
                          onSelected: (selected) => setState(() => _selectedFilter = filter),
                          selectedColor: Colors.green[700],
                          backgroundColor: Colors.white,
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : Colors.grey[600],
                            fontWeight: FontWeight.w600,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(color: isSelected ? Colors.transparent : Colors.grey.shade200),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),

          // --- HABITS LIST DARI FIREBASE ---
          Expanded(
            child: Consumer<HabitManager>(
              builder: (context, habitManager, child) {
                if (habitManager.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                var habits = habitManager.habits;

                // Simple Filter Logic (Berdasarkan Waktu)
                if (_selectedFilter != 'All') {
                  habits = habits.where((h) {
                    int hour = int.parse(h.reminderTime.split(':')[0]);
                    if (_selectedFilter == 'Morning') return hour < 12;
                    if (_selectedFilter == 'Afternoon') return hour >= 12 && hour < 18;
                    if (_selectedFilter == 'Night') return hour >= 18;
                    return true;
                  }).toList();
                }

                if (habits.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.eco_outlined, size: 60, color: Colors.grey[300]),
                        const SizedBox(height: 10),
                        Text('No habits found. Add one! 🌱', style: TextStyle(color: Colors.grey[500])),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: habits.length,
                  itemBuilder: (context, index) {
                    final habit = habits[index];
                    final style = _getCategoryDetails(habit.category); // Helper warna/icon

                    return _buildHabitCard(
                      context: context,
                      id: habit.id,
                      title: habit.title,
                      time: habit.reminderTime,
                      icon: style['icon'],
                      color: style['color'],
                      frequency: habit.frequency,
                      isCompleted: habit.isCompletedToday,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Helper untuk menentukan Warna & Ikon berdasarkan Kategori agar UI tetap cantik
  Map<String, dynamic> _getCategoryDetails(String category) {
    switch (category) {
      case 'Water': return {'icon': Icons.water_drop_rounded, 'color': Colors.blue};
      case 'Reading': return {'icon': Icons.menu_book_rounded, 'color': Colors.purple};
      case 'Exercise': return {'icon': Icons.directions_run_rounded, 'color': Colors.orange};
      case 'Energy': return {'icon': Icons.bolt_rounded, 'color': Colors.amber};
      case 'Recycle': return {'icon': Icons.recycling_rounded, 'color': Colors.green};
      default: return {'icon': Icons.star_rounded, 'color': Colors.teal};
    }
  }

  Widget _buildHabitCard({
    required BuildContext context,
    required String id,
    required String title,
    required String time,
    required IconData icon,
    required Color color,
    required String frequency,
    required bool isCompleted,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isCompleted ? Colors.grey[100] : Colors.white, // Ubah warna jika selesai
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon Box
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isCompleted ? Colors.grey[300] : color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: isCompleted ? Colors.grey : color, size: 26),
          ),
          const SizedBox(width: 16),

          // Text Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isCompleted ? Colors.grey : Colors.green[900],
                    decoration: isCompleted ? TextDecoration.lineThrough : null,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.access_time_rounded, size: 14, color: Colors.grey[500]),
                    const SizedBox(width: 4),
                    Text(time, style: TextStyle(fontSize: 12, color: Colors.grey[500])),
                    const SizedBox(width: 10),
                    Icon(Icons.repeat_rounded, size: 14, color: Colors.grey[500]),
                    const SizedBox(width: 4),
                    Text(frequency, style: TextStyle(fontSize: 12, color: Colors.grey[500])),
                  ],
                ),
              ],
            ),
          ),

          // Checkbox Action
          IconButton(
            icon: Icon(
              isCompleted ? Icons.check_circle : Icons.circle_outlined,
              color: isCompleted ? Colors.green : Colors.grey[300],
              size: 28,
            ),
            onPressed: () {
               Provider.of<HabitManager>(context, listen: false).toggleHabitCompletion(id, isCompleted);
            },
          ),

          // Menu Option
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert_rounded, color: Colors.grey[400]),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            onSelected: (value) {
              if (value == 'delete') {
                Provider.of<HabitManager>(context, listen: false).deleteHabit(id);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Habit deleted')));
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete_outline, size: 20, color: Colors.red),
                    SizedBox(width: 10),
                    Text('Delete', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}