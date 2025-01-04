import 'package:flutter/material.dart';
import 'package:job_portal/utils/basic/toast.dart';

class AddSkillsScreen extends StatefulWidget {
  const AddSkillsScreen({super.key});

  @override
  State<AddSkillsScreen> createState() => _AddSkillsScreenState();
}

class _AddSkillsScreenState extends State<AddSkillsScreen> {
  final TextEditingController _skillController = TextEditingController();
  final List<String> _skills = ['Flutter', 'Dart'];

  void _addSkill() {
    final skill = _skillController.text.trim();
    if (skill.isNotEmpty) {
      if (!_skills.contains(skill)) {
        setState(() {
          _skills.add(skill);
          _skillController.clear();
        });
      } else {
        showError('This skill is already added.');
      }
    }
  }

  void _removeSkill(String skill) {
    setState(() {
      _skills.remove(skill);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Add Skills',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue.shade800,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _skillController,
                    decoration: InputDecoration(
                      hintText: 'Enter a skill',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onSubmitted: (_) => _addSkill(),
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _addSkill,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade800,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Add'),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _skills
                    .map((skill) => Chip(
                          label: Text(skill),
                          onDeleted: () => _removeSkill(skill),
                          backgroundColor: Colors.blue.shade100,
                          deleteIconColor: Colors.blue.shade800,
                        ))
                    .toList(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                // TODO: Implement saving skills to user profile
                Navigator.pop(context, _skills);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade800,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Save Skills'),
            ),
          ),
        ],
      ),
    );
  }
}
