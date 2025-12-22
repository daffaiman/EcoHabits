import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_2/presentation/manager/auth_manager.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> with SingleTickerProviderStateMixin {
  // Controllers
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // State
  bool _isPasswordVisible = false;
  bool _isConfirmVisible = false;
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();

  // Animation
  late AnimationController _animController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOut),
    );

    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOut),
    );

    _animController.forward();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _animController.dispose();
    super.dispose();
  }

  // LOGIKA REGISTER
  Future<void> _handleSignUp() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final auth = Provider.of<AuthManager>(context, listen: false);
      
      // Memanggil fungsi signUpWithEmail yang ada di AuthManager
      await auth.signUpWithEmail(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (!mounted) return;
      
      // Jika sukses, pindah ke Home
      Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
      
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Registration Failed: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFE8F5E9),
              Color(0xFFA5D6A7),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Column(
                  children: [
                    // 1. TOMBOL KEMBALI
                    Align(
                      alignment: Alignment.topLeft,
                      child: InkWell(
                        onTap: () => Navigator.pop(context),
                        borderRadius: BorderRadius.circular(50),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.green.withValues(alpha: 0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.arrow_back_rounded,
                            color: Colors.green[800],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // 2. HEADER
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.green.withValues(alpha: 0.15),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          )
                        ],
                      ),
                      child: Icon(Icons.person_add_alt_1_rounded, size: 40, color: Colors.green[600]),
                    ),

                    const SizedBox(height: 20),

                    Text(
                      'Create Account',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[900],
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Join us to save the planet!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16, 
                        color: Colors.green[700],
                        fontWeight: FontWeight.w400,
                      ),
                    ),

                    const SizedBox(height: 30),

                    // 3. FORM CARD
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF1B5E20).withValues(alpha: 0.08),
                            blurRadius: 25,
                            spreadRadius: 2,
                            offset: const Offset(0, 15),
                          ),
                        ],
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            // USERNAME
                            _buildTextField(
                              controller: _usernameController,
                              label: 'Username',
                              icon: Icons.person_outline_rounded,
                              validator: (v) =>
                                  v!.isEmpty ? 'Username required' : null,
                            ),

                            const SizedBox(height: 20),

                            // EMAIL
                            _buildTextField(
                              controller: _emailController,
                              label: 'Email',
                              icon: Icons.email_outlined,
                              validator: (v) {
                                if (v!.isEmpty) return 'Email required';
                                if (!v.contains('@')) return 'Invalid email format';
                                return null;
                              },
                            ),

                            const SizedBox(height: 20),

                            // PASSWORD
                            _buildTextField(
                              controller: _passwordController,
                              label: 'Password',
                              icon: Icons.lock_outline_rounded,
                              isPassword: true,
                              isVisible: _isPasswordVisible,
                              onVisibilityToggle: () {
                                setState(
                                  () => _isPasswordVisible = !_isPasswordVisible,
                                );
                              },
                              validator: (v) =>
                                  v!.length < 6 ? 'Min. 6 characters' : null,
                            ),

                            const SizedBox(height: 20),

                            // CONFIRM PASSWORD
                            _buildTextField(
                              controller: _confirmPasswordController,
                              label: 'Confirm Password',
                              icon: Icons.lock_reset_rounded,
                              isPassword: true,
                              isVisible: _isConfirmVisible,
                              onVisibilityToggle: () {
                                setState(
                                  () => _isConfirmVisible = !_isConfirmVisible,
                                );
                              },
                              validator: (v) {
                                if (v != _passwordController.text) {
                                  return 'Passwords do not match';
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 30),

                            // REGISTER BUTTON
                            Container(
                              width: double.infinity,
                              height: 56,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF00A040).withValues(alpha: 0.3),
                                    blurRadius: 15,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: ElevatedButton(
                                onPressed: _isLoading ? null : _handleSignUp,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF00A040),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  elevation: 0,
                                ),
                                child: _isLoading 
                                  ? const SizedBox(
                                      height: 24, 
                                      width: 24, 
                                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                                    )
                                  : const Text(
                                      'Sign Up',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1,
                                      ),
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    // 4. FOOTER LINK
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an account? ',
                          style: TextStyle(color: Colors.green[900], fontSize: 15),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: const Text(
                            'Log In',
                            style: TextStyle(
                              color: Color(0xFF00A040),
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              decoration: TextDecoration.underline,
                              decorationColor: Color(0xFF00A040),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // WIDGET HELPERS
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
    bool isVisible = false,
    VoidCallback? onVisibilityToggle,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword && !isVisible,
      validator: validator,
      style: TextStyle(color: Colors.green[900], fontWeight: FontWeight.w500),
      textAlignVertical: TextAlignVertical.center,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.green[700]),
        prefixIcon: Icon(icon, color: Colors.green[600]),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  isVisible ? Icons.visibility : Icons.visibility_off,
                  color: Colors.green[400],
                ),
                onPressed: onVisibilityToggle,
              )
            : null,
        filled: true,
        fillColor: Colors.green.withValues(alpha: 0.08),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.green.shade500, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
      ),
    );
  }
}