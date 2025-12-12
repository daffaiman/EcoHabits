import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Firebase
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// Manager
// Pastikan path import ini sesuai dengan nama project Anda
import 'presentation/manager/auth_manager.dart';
import 'presentation/manager/habit_manager.dart'; 

// Screens
import 'presentation/screens/splash_screen.dart';
import 'presentation/screens/welcome_screen.dart';
import 'presentation/screens/login_screen.dart';
import 'presentation/screens/register_screen.dart';
import 'presentation/screens/forgot_password_screen.dart';
import 'presentation/screens/home_screen.dart';
import 'presentation/screens/profile_screen.dart';
import 'presentation/screens/edit_profile_screen.dart';
import 'presentation/screens/change_password_screen.dart';
import 'presentation/screens/habits_screen.dart';
import 'presentation/screens/add_habits_screen.dart';
import 'presentation/screens/help_support_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const EcoHabitsApp());
}

class EcoHabitsApp extends StatelessWidget {
  const EcoHabitsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      // DAFTARKAN SEMUA MANAGER DI SINI
      providers: [
        // 1. Auth Manager (Login/Register)
        ChangeNotifierProvider<AuthManager>(
          create: (_) => AuthManager(),
        ),
        
        // 2. Habit Manager (Database Firestore)
        ChangeNotifierProvider<HabitManager>(
          create: (_) => HabitManager(),
        ),
      ],
      child: MaterialApp(
        title: 'EcoHabits',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.green,
          useMaterial3: false,
          scaffoldBackgroundColor: const Color(0xFFE6F4E7),
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashScreen(),
          '/welcome': (context) => const WelcomeScreen(),
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const RegisterScreen(),
          '/forgot-password': (context) => const ForgotPasswordScreen(),
          '/home': (context) => const HomeScreen(),
          '/profile': (context) => const ProfileScreen(),
          '/habits': (context) => const HabitsScreen(),
          '/add-habit': (context) => const AddHabitScreen(),
          '/edit-profile': (context) => const EditProfileScreen(),
          '/change-password': (context) => const ChangePasswordScreen(),
          '/help-support': (context) => const HelpSupportScreen(),
        },
      ),
    );
  }
}