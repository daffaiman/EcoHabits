import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// Sesuaikan import path
import 'package:flutter_application_2/presentation/manager/auth_manager.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Data Profil Lokal (untuk gambar)
  File? _profileImage;
  // State untuk Switch Notifikasi
  bool _notificationsEnabled = true;

  // Fungsi Navigasi ke Edit Profile
  Future<void> _navigateToEditProfile() async {
    final result = await Navigator.pushNamed(context, '/edit-profile');
    if (result != null && result is File) {
      setState(() {
        _profileImage = result;
      });
    }
  }

  // LOGIKA LOGOUT
  void _showLogoutDialog(BuildContext context, AuthManager auth) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Log Out"),
        content: const Text("Are you sure you want to log out?"),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx); // Tutup dialog
              
              // Proses Logout Firebase
              await auth.logout();
              
              if (mounted) {
                Navigator.pushNamedAndRemoveUntil(
                  // ignore: use_build_context_synchronously
                  context,
                  '/login',
                  (route) => false,
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text("Log Out"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 1. AMBIL DATA USER DARI AUTH MANAGER (FIREBASE)
    final auth = Provider.of<AuthManager>(context);
    final user = auth.user; 
    
    // Tampilan default jika data loading/null
    final String displayName = user?.displayName ?? "User";
    final String displayEmail = user?.email ?? "email@example.com";

    return Scaffold(
      backgroundColor: const Color(0xFFE6F4E7),
      appBar: AppBar(
        title: const Text("My Profile"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.green[900],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          children: [
            // FOTO PROFIL
            GestureDetector(
              onTap: _navigateToEditProfile,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 130,
                    height: 130,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.green.shade300,
                        width: 3,
                      ),
                      color: Colors.green[100],
                    ),
                  ),

                  if (_profileImage == null)
                    const Icon(Icons.person, size: 70, color: Colors.grey),

                  if (_profileImage != null)
                    ClipOval(
                      child: Image.file(
                        _profileImage!,
                        width: 130,
                        height: 130,
                        fit: BoxFit.cover,
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // 2. NAMA & EMAIL DARI FIREBASE
            Text(
              displayName,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green[900],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              displayEmail,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),

            const SizedBox(height: 30),

            // MENU GRUP 1
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildProfileMenuItem(
                    icon: Icons.person_outline_rounded,
                    title: "Edit Personal Details",
                    onTap: _navigateToEditProfile,
                  ),
                  const Divider(height: 1, indent: 20, endIndent: 20),

                  _buildProfileMenuItem(
                    icon: Icons.lock_outline_rounded,
                    title: "Change Password",
                    onTap: () {
                      Navigator.pushNamed(context, '/change-password');
                    },
                  ),
                  const Divider(height: 1, indent: 20, endIndent: 20),

                  _buildProfileMenuItem(
                    icon: Icons.notifications_outlined,
                    title: "Notifications",
                    onTap: () {
                      setState(() {
                        _notificationsEnabled = !_notificationsEnabled;
                      });
                    },
                    trailing: Switch(
                      value: _notificationsEnabled,
                      activeThumbColor: Colors.green,
                      onChanged: (v) {
                        setState(() {
                          _notificationsEnabled = v;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // MENU GRUP 2
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildProfileMenuItem(
                    icon: Icons.help_outline_rounded,
                    title: "Help & Support",
                    onTap: () {
                      Navigator.pushNamed(context, '/help-support');
                    },
                  ),

                  const Divider(height: 1, indent: 20, endIndent: 20),

                  _buildProfileMenuItem(
                    icon: Icons.logout_rounded,
                    title: "Log Out",
                    textColor: Colors.red,
                    iconColor: Colors.red,
                    onTap: () {
                      _showLogoutDialog(context, auth);
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // WIDGET MENU
  Widget _buildProfileMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? textColor,
    Color? iconColor,
    Widget? trailing,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: (iconColor ?? Colors.green).withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: iconColor ?? Colors.green[700], size: 22),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 15,
          color: textColor ?? Colors.green[900],
        ),
      ),
      trailing:
          trailing ??
          const Icon(
            Icons.arrow_forward_ios_rounded,
            size: 16,
            color: Colors.grey,
          ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
    );
  }
}