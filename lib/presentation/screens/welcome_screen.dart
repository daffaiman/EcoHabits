import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
// Pastikan path import ini sesuai dengan struktur folder Anda
import 'package:flutter_application_2/presentation/manager/auth_manager.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  late final AnimationController _ctr;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _ctr = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fade = Tween<double>(begin: 0, end: 1)
        .animate(CurvedAnimation(parent: _ctr, curve: Curves.easeOut));
    _slide = Tween<Offset>(begin: const Offset(0, 0.12), end: Offset.zero)
        .animate(CurvedAnimation(parent: _ctr, curve: Curves.easeOut));
    _ctr.forward();
  }

  @override
  void dispose() {
    _ctr.dispose();
    super.dispose();
  }

  // Tombol utama (UI TETAP SAMA)
  Widget _mainButton(String text, VoidCallback onTap) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.7,
      height: 46,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF9ED96A),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(26),
          ),
          elevation: 3,
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 15,
          ),
        ),
      ),
    );
  }

  // Tombol social (UI TETAP SAMA)
  Widget _social(String asset, VoidCallback onTap) {
    return Material(
      color: Colors.white,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 44,
          height: 44,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Image.asset(asset, fit: BoxFit.contain),
          ),
        ),
      ),
    );
  }

  // LOGIKA LOGIN
  Future<void> _handleGoogleLogin(AuthManager auth) async {
    await auth.signInWithGoogle();
    // Cek jika widget masih aktif & user berhasil login
    if (mounted && auth.user != null) {
      Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
    }
  }

  // Fungsi _handleFacebookLogin SUDAH DIHAPUS

  @override
  Widget build(BuildContext context) {
    // Panggil AuthManager
    final auth = Provider.of<AuthManager>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFC7EBC0),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: FadeTransition(
              opacity: _fade,
              child: SlideTransition(
                position: _slide,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 24),
                    // Pastikan aset gambar ada
                    Image.asset('assets/EcoHabits.png', width: 120), 
                    const SizedBox(height: 20),
                    Text(
                      'WELCOME',
                      style: GoogleFonts.lora(
                        textStyle: const TextStyle(
                          color: Color(0xFF2F6232),
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Your Small Steps, Big Changes for the Earth.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.lora(
                        textStyle: TextStyle(
                          // Menggunakan withValues agar kompatibel dengan Flutter terbaru
                          color: const Color(0xFF2F6232).withValues(alpha: 0.85),
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                    const SizedBox(height: 36),
                    
                    // Button Log In
                    _mainButton('Log In', () {
                      Navigator.pushNamed(context, '/login');
                    }),
                    
                    const SizedBox(height: 14),
                    
                    // Button Create Account
                    _mainButton('Create Account', () {
                      Navigator.pushNamed(context, '/register');
                    }),
                    
                    const SizedBox(height: 28),
                    
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 36),
                      child: const Row(
                        children: [
                          Expanded(
                            child: Divider(color: Colors.black26, thickness: 1),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              'Or sign in with',
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Divider(color: Colors.black26, thickness: 1),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // SOCIAL BUTTONS (SEKARANG HANYA GOOGLE)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Google
                        _social('assets/google.png', () => _handleGoogleLogin(auth)),
                        
                        // Facebook button dan SizedBox penghubung sudah dihapus
                      ],
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}