import 'package:flutter/material.dart';
import 'package:job_portal/const/const.dart';
import 'package:job_portal/navigation/provider_bottom_navigation.dart';
import 'package:job_portal/screens/auth/register_login_screen.dart';
import 'package:job_portal/utils/basic/navigate_tool.dart';
import 'package:job_portal/widgets/gradient_background.dart';
import 'package:provider/provider.dart';

import '../../models/user/user_model.dart';
import '../../providers/user_provider.dart';
import '../../widgets/text_field.dart';

class ProviderAccountSetupScreen extends StatefulWidget {
  const ProviderAccountSetupScreen({super.key});

  @override
  State<ProviderAccountSetupScreen> createState() =>
      _ProviderAccountSetupScreenState();
}

class _ProviderAccountSetupScreenState
    extends State<ProviderAccountSetupScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _companyPhoneController = TextEditingController();
  final TextEditingController _designationController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Account Setup',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue.shade800,
      ),
      body: GradientBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ...[
                    buildTextField(
                      controller: _companyNameController,
                      label: 'Company Name',
                      icon: Icons.business,
                    ),
                    const SizedBox(height: 16),
                    buildTextField(
                      controller: _locationController,
                      label: 'Location',
                      icon: Icons.location_on,
                    ),
                    const SizedBox(height: 16),
                    buildTextField(
                      controller: _companyPhoneController,
                      label: 'Company Phone Number',
                      icon: Icons.mobile_friendly,
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 16),
                    buildTextField(
                      controller: _designationController,
                      label: 'Your Designation',
                      icon: Icons.work,
                    ),
                    const SizedBox(height: 16),
                  ],
                  const SizedBox(height: 32),
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
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _submitForm() {
    final provider = Provider.of<UserProvider>(context, listen: false);
    provider.setTempUser(UserType.provider);
    if (_formKey.currentState!.validate()) {}
    isUser = false;
    isProvider = true;
    push(context, const ProviderBottomNavigation());
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
