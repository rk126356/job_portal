import 'package:flutter/material.dart';
import 'package:job_portal/controllers/user/user_controller.dart';
import 'package:job_portal/navigation/bottom_navigation.dart';
import 'package:job_portal/utils/basic/navigate_tool.dart';
import 'package:job_portal/widgets/gradient_background.dart';
import '../../models/user/user_model.dart';
import '../../providers/user_provider.dart';

class AccountSetupScreen extends StatefulWidget {
  const AccountSetupScreen({super.key});

  @override
  State<AccountSetupScreen> createState() => _AccountSetupScreenState();
}

class _AccountSetupScreenState extends State<AccountSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _vehicleRegNumberController = TextEditingController();
  bool _isLoading = false;

  String? _selectedVehicleType;
  final List<String> _vehicleTypes = ['Cycle', 'Bike', 'Van', 'Others'];

  void _load() async {
    setState(() {
      _isLoading = true;
    });
    UserModel? user = await reloadUser(context, globalUserId);
    if (user != null) {
      _nameController.text = user.name;
      _phoneController.text = user.phone;
      _emailController.text = user.email;
      _vehicleRegNumberController.text = user.vehicleRegNo;
      if (_vehicleTypes.contains(user.vehicleType)) {
        _selectedVehicleType = user.vehicleType;
      }
    }
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
          'Account Setup',
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
                        _buildDropdownField(
                          label: 'Vehicle Type',
                          icon: Icons.directions_car,
                          value: _selectedVehicleType,
                          items: _vehicleTypes.map((String type) {
                            return DropdownMenuItem<String>(
                              value: type,
                              child: Text(type),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedVehicleType = newValue;
                            });
                          },
                        ),
                        const SizedBox(height: 16),
                        if (_selectedVehicleType != 'Cycle') ...[
                          _buildTextField(
                            controller: _vehicleRegNumberController,
                            label: 'Vehicle Registration Number',
                            icon: Icons.pin,
                          ),
                          const SizedBox(height: 16),
                          _buildFileUpload('Vehicle Registration Document'),
                          const SizedBox(height: 16),
                        ],
                        _buildPhotoUpload('Candidate Photo'),
                        const SizedBox(height: 16),
                        _buildFileUpload('CV'),
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

  Widget _buildDropdownField({
    required String label,
    required IconData icon,
    required String? value,
    required List<DropdownMenuItem<String>> items,
    required void Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
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
      value: value,
      items: items,
      onChanged: onChanged,
      style: const TextStyle(color: Colors.black),
      validator: (value) =>
          value == null ? 'Please select a vehicle type' : null,
      dropdownColor: Colors.white,
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

  Widget _buildPhotoUpload(String label) {
    return OutlinedButton.icon(
      onPressed: () {
        // Implement photo upload logic
      },
      icon: const Icon(Icons.camera_alt),
      label: Text('Upload $label'),
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: Colors.blue.shade800),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget _buildFileUpload(String label) {
    return OutlinedButton.icon(
      onPressed: () {
        // Implement file upload logic
      },
      icon: const Icon(Icons.upload_file),
      label: Text('Upload $label'),
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: Colors.blue.shade800),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
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
    _vehicleRegNumberController.dispose();
    super.dispose();
  }
}
