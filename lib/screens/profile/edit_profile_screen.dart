import 'package:flutter/material.dart';
import 'package:job_portal/controllers/user/user_controller.dart';
import 'package:job_portal/navigation/bottom_navigation.dart';
import 'package:job_portal/utils/basic/navigate_tool.dart';
import 'package:job_portal/widgets/gradient_background.dart';
import '../../models/user/user_model.dart';
import '../../providers/user_provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key, required this.user});

  final UserModel user;

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  bool _isLoading = false;

  void _load() async {
    setState(() {
      _isLoading = true;
    });

    _nameController.text = widget.user.name;
    _phoneController.text = widget.user.phone;
    _emailController.text = widget.user.email;
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Edit Profile',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue.shade800,
      ),
      body: GradientBackground(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildTextField(
                          controller: _nameController,
                          label: 'Name',
                          icon: Icons.person,
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          controller: _phoneController,
                          label: 'Phone',
                          icon: Icons.phone,
                          keyboardType: TextInputType.phone,
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          controller: _emailController,
                          label: 'Email',
                          icon: Icons.email,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _submitForm,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade800,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Submit',
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.blue.shade800),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.blue.shade200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.blue.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.blue.shade800),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.black),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'This field is required';
        }
        return null;
      },
    );
  }

  void _submitForm() {
    push(context, const BottomNavigation());
    if (_formKey.currentState!.validate()) {
      // Implement form submission logic
      print('Form submitted');
      // You can access the form data using the controllers
      // e.g., _nameController.text, _phoneController.text, etc.
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}
