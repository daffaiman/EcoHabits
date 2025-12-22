import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../manager/habit_manager.dart'; // Sesuaikan path

class AddHabitScreen extends StatefulWidget {
  const AddHabitScreen({super.key});

  @override
  State<AddHabitScreen> createState() => _AddHabitScreenState();
}

class _AddHabitScreenState extends State<AddHabitScreen> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();

  String _selectedCategory = 'General';
  String _selectedFrequency = 'Daily';
  TimeOfDay _selectedTime = const TimeOfDay(hour: 8, minute: 0);

  final List<String> _categories = [
    'General', 'Water', 'Energy', 'Recycle', 'Exercise', 'Reading'
  ];
  final List<String> _frequencies = ['Daily', 'Weekly', 'Weekdays'];

  bool _isSaving = false; // Loading state lokal untuk tombol

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _pickTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.green,
              onPrimary: Colors.white,
              onSurface: Colors.green,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _selectedTime = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9F6),
      appBar: AppBar(
        title: const Text('New Habit', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.green[900],
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Habit Name'),
            _buildTextField(
              controller: _titleController,
              hint: 'e.g. Drink Water',
              icon: Icons.edit_outlined,
            ),
            const SizedBox(height: 20),

            _buildSectionTitle('Description'),
            _buildTextField(
              controller: _descController,
              hint: 'e.g. Drink 2L water daily...',
              icon: Icons.description_outlined,
              maxLines: 3,
            ),
            const SizedBox(height: 20),

            _buildSectionTitle('Category'),
            Wrap(
              spacing: 10,
              children: _categories.map((category) {
                final isSelected = _selectedCategory == category;
                return ChoiceChip(
                  label: Text(category),
                  selected: isSelected,
                  selectedColor: Colors.green[700],
                  backgroundColor: Colors.white,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : Colors.grey[600],
                    fontWeight: FontWeight.w600,
                  ),
                  onSelected: (selected) => setState(() => _selectedCategory = category),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(
                      color: isSelected ? Colors.transparent : Colors.grey.shade200,
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle('Frequency'),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedFrequency,
                            isExpanded: true,
                            icon: const Icon(Icons.keyboard_arrow_down, color: Colors.green),
                            items: _frequencies.map((String value) {
                              return DropdownMenuItem<String>(value: value, child: Text(value));
                            }).toList(),
                            onChanged: (newValue) => setState(() => _selectedFrequency = newValue!),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle('Reminder'),
                      GestureDetector(
                        onTap: _pickTime,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.access_time, size: 20, color: Colors.green[700]),
                              const SizedBox(width: 8),
                              Text(
                                _selectedTime.format(context),
                                style: const TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _isSaving 
                  ? null 
                  : () async {
                    if (_titleController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please enter a habit name')),
                      );
                      return;
                    }

                    setState(() => _isSaving = true);

                    try {
                      await Provider.of<HabitManager>(context, listen: false).addHabit(
                        title: _titleController.text,
                        description: _descController.text,
                        category: _selectedCategory,
                        frequency: _selectedFrequency,
                        reminderTime: _selectedTime,
                      );

                      if (!mounted) return;
                      
                      // ignore: use_build_context_synchronously
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('New habit created! 🌱'),
                          backgroundColor: Colors.green,
                        ),
                      );
                      
                      // Reset form
                      _titleController.clear();
                      _descController.clear();
                      setState(() {
                         _selectedCategory = 'General';
                         _selectedTime = const TimeOfDay(hour: 8, minute: 0);
                      });

                    } catch (e) {
                      // ignore: use_build_context_synchronously
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
                      );
                    } finally {
                      if (mounted) setState(() => _isSaving = false);
                    }
                  },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[700],
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 5,
                  shadowColor: Colors.green.withValues(alpha: 0.4),
                ),
                child: _isSaving 
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text(
                      'Create Habit',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(
        title,
        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.green[900]),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey[400]),
        prefixIcon: maxLines > 1
            ? Padding(padding: const EdgeInsets.only(bottom: 25), child: Icon(icon, color: Colors.green[600]))
            : Icon(icon, color: Colors.green[600]),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.green.shade400, width: 1.5)),
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      ),
    );
  }
}