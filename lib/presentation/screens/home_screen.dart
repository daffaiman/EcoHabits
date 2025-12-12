import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Manager
import '../manager/habit_manager.dart'; 
import '../manager/auth_manager.dart'; 

// Screens
import 'profile_screen.dart';
import 'habits_screen.dart';
import 'add_habits_screen.dart';
import 'tips_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _idx = 0;
  
  // [PERBAIKAN 1]: Gunakan 'late' dan inisialisasi di initState
  late final List<Widget> pages; 

  // Fungsi untuk mengubah index tab
  void _setIndex(int index) {
    setState(() {
      _idx = index;
    });
  }
  
  @override
  void initState() {
    super.initState();
    
    // [PERBAIKAN 1]: Inisialisasi daftar halaman di sini
    // Sekarang kita bisa mengakses '_setIndex' tanpa error
    pages = [
      DashboardPage(onSeeAllTap: () => _setIndex(1)), // Tab 0: Home
      const HabitsScreen(), // Tab 1: Habits
      const AddHabitScreen(), // Tab 2: Add
      const TipsScreen(), // Tab 3: Tips
      const ProfileScreen(), // Tab 4: Profile
    ];

    // Panggil listener habit saat Home Screen dibuat
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<HabitManager>(context, listen: false).listenToHabits();
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _idx == 0,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        setState(() => _idx = 0);
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F9F6),
        // Pastikan pages sudah diinisialisasi sebelum digunakan (dijamin oleh initState)
        body: pages[_idx],

        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 20,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: BottomNavigationBar(
            currentIndex: _idx,
            onTap: (v) => _setIndex(v),
            selectedItemColor: Colors.green[700],
            unselectedItemColor: Colors.grey[400],
            backgroundColor: Colors.white,
            elevation: 0,
            type: BottomNavigationBarType.fixed,
            showUnselectedLabels: true,
            selectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
            unselectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 11,
            ),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.grid_view_rounded),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.list_alt_rounded),
                label: 'Habits',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.add_circle_outline_rounded),
                label: 'Add',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.tips_and_updates_rounded),
                label: 'Tips',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_rounded),
                label: 'Profile',
              ),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: SizedBox(
          height: 64,
          width: 64,
          child: FloatingActionButton(
            elevation: 0,
            backgroundColor: Colors.green[700],
            shape: const CircleBorder(),
            child: const Icon(Icons.add, size: 32, color: Colors.white),
            onPressed: () => _setIndex(2),
          ),
        ),
      ),
    );
  }
}

// -------------------------------------------------------
//                     DASHBOARD PAGE
// -------------------------------------------------------

class DashboardPage extends StatelessWidget {
  final VoidCallback onSeeAllTap;
  const DashboardPage({super.key, required this.onSeeAllTap});

  // Helper untuk menentukan Ikon berdasarkan Kategori
  IconData _getIconForCategory(String category) {
    switch (category) {
      case 'Water': return Icons.water_drop_rounded;
      case 'Reading': return Icons.menu_book_rounded;
      case 'Exercise': return Icons.directions_walk_rounded;
      case 'Energy': return Icons.bolt_rounded;
      case 'Recycle': return Icons.recycling_rounded;
      default: return Icons.star_rounded;
    }
  }

  // Helper untuk menentukan Warna berdasarkan Kategori
  Color _getColorForCategory(String category) {
    switch (category) {
      case 'Water': return Colors.blue;
      case 'Reading': return Colors.purple;
      case 'Exercise': return Colors.orange;
      case 'Energy': return Colors.amber;
      case 'Recycle': return Colors.green;
      default: return Colors.teal;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Ambil data dari AuthManager (untuk nama user)
    final auth = Provider.of<AuthManager>(context);
    final String userName = auth.user?.displayName?.split(' ').first ?? "Eco-User";
    final String todayDate = 
      "${DateTime.now().weekday == 6 ? 'Saturday' : 'Weekday'}, ${DateTime.now().day} ${DateTime.now().month}"; 
    
    
    // Gunakan Consumer untuk data habits
    return Consumer<HabitManager>(
      builder: (context, habitManager, child) {
        
        // Data Realtime dari Firebase
        final allHabits = habitManager.habits;
        final completedHabits = allHabits.where((h) => h.isCompletedToday).length;
        final totalHabits = allHabits.length;
        final progressValue = totalHabits == 0 ? 0.0 : completedHabits / totalHabits;

        return SingleChildScrollView(
          child: Column(
            children: [
              // HEADER
              Container(
                padding: const EdgeInsets.fromLTRB(24, 60, 24, 30),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Good Morning, $userName! ☀️", 
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.green[900],
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              todayDate,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.green.shade100,
                              width: 2,
                            ),
                          ),
                          child: CircleAvatar(
                            radius: 24,
                            backgroundColor: Colors.green[50],
                            child: Image.asset('assets/EcoHabits.png', width: 32),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // PROGRESS CARD
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.green[800]!, Colors.green[500]!],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.green.withValues(alpha: 0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Daily Goals",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Text(
                                  "Level 4 🌱",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "$completedHabits of $totalHabits completed", 
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 13,
                                ),
                              ),
                              Text(
                                "${(progressValue * 100).toInt()}%", 
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: LinearProgressIndicator(
                              value: progressValue, 
                              minHeight: 8,
                              backgroundColor: Colors.black.withValues(alpha: 0.2),
                              valueColor: const AlwaysStoppedAnimation(
                                Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // HABITS LIST PREVIEW
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Your Habits",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.green[900],
                          ),
                        ),
                        TextButton(
                          onPressed: onSeeAllTap,
                          child: const Text("See All"),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    
                    if (habitManager.isLoading && totalHabits == 0)
                      const Center(child: CircularProgressIndicator()),

                    if (totalHabits == 0)
                      Center(
                        child: Text("Start adding your first habit! 🌱", style: TextStyle(color: Colors.grey[500])),
                      )
                    else
                      // [PERBAIKAN 2]: Menghapus .toList() karena spread operator (...) 
                      // sudah bisa menangani Iterable yang dikembalikan oleh .map()
                      ...allHabits.take(4).map((habit) { 
                        final iconData = _getIconForCategory(habit.category);
                        final colorData = _getColorForCategory(habit.category);
                        
                        return _buildHabitTile(
                          title: habit.title,
                          subtitle: habit.description.isNotEmpty 
                              ? habit.description 
                              : habit.frequency,
                          icon: iconData,
                          color: colorData,
                          isCompleted: habit.isCompletedToday,
                          onTap: () {
                             Provider.of<HabitManager>(context, listen: false).toggleHabitCompletion(habit.id, habit.isCompletedToday);
                          },
                        );
                      }),
                    
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHabitTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required bool isCompleted,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.green.withValues(alpha: 0.03),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon Box
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isCompleted
                    ? Colors.grey[100]
                    : color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                icon,
                color: isCompleted ? Colors.grey : color,
                size: 26,
              ),
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
                      color: isCompleted ? Colors.grey : Colors.black87,
                      decoration: isCompleted ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 13, color: Colors.grey[500]),
                  ),
                ],
              ),
            ),
            // Checkbox Custom
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: isCompleted ? Colors.green : Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isCompleted ? Colors.green : Colors.grey.shade300,
                  width: 2,
                ),
              ),
              child: isCompleted
                  ? const Icon(Icons.check, size: 16, color: Colors.white)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}