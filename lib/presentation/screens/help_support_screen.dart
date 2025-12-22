import 'package:flutter/material.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6F4E7), // Background hijau pastel
      appBar: AppBar(
        title: const Text('Help & Support'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.green[900],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- BAGIAN 1: CONTACT SUPPORT ---
            const Text(
              'Contact Us',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.green[700],
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    // ignore: deprecated_member_use
                    color: Colors.green.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: const Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 24,
                    child: Icon(
                      Icons.support_agent_rounded,
                      color: Colors.green,
                      size: 28,
                    ),
                  ),
                  SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Customer Service',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'support@ecohabits.com',
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // --- BAGIAN 2: FAQ ---
            const Text(
              'Frequently Asked Questions',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            _buildFaqTile(
              'How do I create a new habit?',
              "Go to the Home screen and tap the '+' button in the bottom navigation bar. Fill in the details and save.",
            ),
            _buildFaqTile(
              'Can I delete a habit?',
              'Yes, simply tap on the habit you want to remove and look for the delete icon or swipe left on the list.',
            ),
            _buildFaqTile(
              'Is my data secure?',
              'Absolutely. We use industry-standard encryption to protect your personal information and habit data.',
            ),
            _buildFaqTile(
              'How do I reset my password?',
              "Go to the Login screen and tap 'Forgot Password'. Follow the instructions sent to your email.",
            ),
          ],
        ),
      ),
    );
  }

  // Helper Widget untuk FAQ Item (Expandable)
  Widget _buildFaqTile(String question, String answer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        // ignore: deprecated_member_use
        border: Border.all(color: Colors.green.withOpacity(0.1)),
      ),
      child: Theme(
        data: ThemeData().copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          title: Text(
            question,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.green[900],
              fontSize: 15,
            ),
          ),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          children: [
            Text(
              answer,
              style: TextStyle(color: Colors.grey[700], height: 1.4),
            ),
          ],
        ),
      ),
    );
  }
}
