import 'package:flutter/material.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctr;

  // Animasi untuk Logo
  late final Animation<double> _logoScale;
  late final Animation<double> _logoFade;

  // Animasi untuk Teks (muncul sedikit lebih lambat)
  late final Animation<Offset> _textSlide;
  late final Animation<double> _textFade;

  @override
  void initState() {
    super.initState();

    _ctr = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000), // Durasi total 2 detik
    );

    // 1. Konfigurasi Animasi Logo (Muncul dari detik 0.0 sampai 0.6)
    _logoScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _ctr,
        curve: const Interval(
          0.0,
          0.6,
          curve: Curves.elasticOut,
        ), // Efek memantul
      ),
    );

    _logoFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _ctr,
        curve: const Interval(0.0, 0.4, curve: Curves.easeIn),
      ),
    );

    // 2. Konfigurasi Animasi Teks (Muncul dari detik 0.4 sampai 1.0)
    // Teks akan bergerak dari sedikit di bawah ke posisi asli
    _textSlide =
        Tween<Offset>(
          begin: const Offset(0, 0.5), // Mulai dari bawah
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: _ctr,
            curve: const Interval(0.4, 1.0, curve: Curves.easeOutQuart),
          ),
        );

    _textFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _ctr,
        curve: const Interval(0.4, 1.0, curve: Curves.easeIn),
      ),
    );

    // Mulai animasi
    _ctr.forward();

    // Timer navigasi
    Timer(const Duration(seconds: 3), () {
      if (mounted) Navigator.pushReplacementNamed(context, '/welcome');
    });
  }

  @override
  void dispose() {
    _ctr.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Menggunakan Gradient agar terlihat lebih 'Eco' dan premium
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFE8F5E9), // Hijau sangat muda (atas)
              Color(0xFFC8E6C9), // Hijau muda (bawah)
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // --- Bagian Logo ---
              ScaleTransition(
                scale: _logoScale,
                child: FadeTransition(
                  opacity: _logoFade,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          // ignore: deprecated_member_use
                          color: Colors.green.withOpacity(0.2),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    // Pastikan path assets Anda benar
                    child: Image.asset('assets/EcoHabits.png', width: 140),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // --- Bagian Teks ---
              SlideTransition(
                position: _textSlide,
                child: FadeTransition(
                  opacity: _textFade,
                  child: Column(
                    children: [
                      Text(
                        'EcoHabits',
                        style: TextStyle(
                          color: Colors.green[800],
                          fontSize: 28, // Ukuran font diperbesar sedikit
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.2, // Memberi jarak antar huruf
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Build a greener future',
                        style: TextStyle(
                          color: Colors.green[600],
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
