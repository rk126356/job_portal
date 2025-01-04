import 'package:flutter/material.dart';
import 'package:job_portal/const/url.dart';
import 'package:job_portal/controllers/basic/get_post_api.dart';
import 'package:job_portal/providers/user_provider.dart';

import 'package:job_portal/widgets/gradient_background.dart';
import 'package:job_portal/widgets/text_field.dart';

import '../../controllers/basic/extra.dart';
import '../../models/basic/category_model.dart';

class PostJobScreen extends StatefulWidget {
  const PostJobScreen({super.key});

  @override
  State<PostJobScreen> createState() => _PostJobScreenState();
}

class _PostJobScreenState extends State<PostJobScreen> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _jobNameController = TextEditingController();
  final TextEditingController _jobRoleController = TextEditingController();
  final TextEditingController _jobDescriptionController =
      TextEditingController();
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _vehicleTypeController = TextEditingController();
  final TextEditingController _salaryController = TextEditingController();
  final TextEditingController _jobOpeningsController = TextEditingController();
  bool _isButtonLoading = false;
  List<CategoryModel> _categories = [];
  String? _selectedCategory;

  String _salaryType = 'Fixed';
  bool _vehicleNeeds = false;
  DateTime _jobDate = DateTime.now();

  Future<void> _loadCategories() async {
    setState(() {
      _isLoading = true;
    });
    _categories = await getCategories();
    setState(() {
      _isLoading = false;
      if (_categories.isNotEmpty) {
        _selectedCategory = _categories[0].categoryName;
      }
    });
  }

  void _postJob() async {
    setState(() {
      _isButtonLoading = true;
    });
    final data = await postApi(
      url: '$providerBaseUrl/post_job.php',
      body: {
        'user_id': globalUserId,
        'job_name': _jobNameController.text,
        'job_role': _jobRoleController.text,
        'job_description': _jobDescriptionController.text,
        'company_name': _companyNameController.text,
        'location': _locationController.text,
        'vehicle_type': _vehicleTypeController.text.isEmpty
            ? 'not required'
            : _vehicleTypeController.text,
        'salary': _salaryController.text,
        'job_openings': _jobOpeningsController.text,
        'job_date': _jobDate.toUtc().millisecondsSinceEpoch.toString(),
        'salary_type': _salaryType,
        'vehicle_needs': _vehicleNeeds ? 'required' : 'not required',
        'category': _selectedCategory,
      },
      showPopup: true,
      shouldPrint: true,
    );
    if (data != null) {
      print(data);
      Navigator.pop(context);
    }
    setState(() {
      _isButtonLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Post a Job',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue.shade800,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : GradientBackground(
              child: SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildTextField(
                          controller: _jobNameController,
                          label: 'Job Name',
                          icon: Icons.work,
                        ),
                        const SizedBox(height: 16),
                        buildTextField(
                          controller: _jobRoleController,
                          label: 'Job Role',
                          icon: Icons.person,
                        ),
                        const SizedBox(height: 16),
                        buildTextField(
                          controller: _jobDescriptionController,
                          label: 'Job Description',
                          icon: Icons.description,
                        ),
                        const SizedBox(height: 16),
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
                        _buildCategoryDropdown(),
                        const SizedBox(height: 16),
                        _buildSwitchField('Vehicle Needs', _vehicleNeeds,
                            (value) {
                          setState(() {
                            _vehicleNeeds = value;
                          });
                        }),
                        if (_vehicleNeeds) ...[
                          const SizedBox(height: 16),
                          buildTextField(
                            controller: _vehicleTypeController,
                            label: 'Vehicle Type',
                            icon: Icons.directions_car,
                          ),
                        ],
                        const SizedBox(height: 16),
                        _buildDropdownField(
                            'Salary Type', _salaryType, ['Fixed', 'Hourly'],
                            (value) {
                          setState(() {
                            _salaryType = value!;
                          });
                        }),
                        const SizedBox(height: 16),
                        buildTextField(
                          controller: _salaryController,
                          label: 'Salary',
                          icon: Icons.euro,
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(height: 16),
                        _buildDateField('Job Date', _jobDate, () async {
                          final DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: _jobDate,
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2025),
                          );
                          if (picked != null && picked != _jobDate) {
                            setState(() {
                              _jobDate = picked;
                            });
                          }
                        }),
                        const SizedBox(height: 16),
                        buildTextField(
                          controller: _jobOpeningsController,
                          label: 'Job Openings',
                          icon: Icons.people,
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(height: 24),
                        _isButtonLoading
                            ? const Center(child: CircularProgressIndicator())
                            : SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: _submitForm,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue.shade800,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: const Text(
                                    'Post Job',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
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

  Widget _buildCategoryDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedCategory,
      decoration: InputDecoration(
        labelText: 'Category',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.blue.shade200),
        ),
        filled: true,
        fillColor: Colors.white,
        prefixIcon: Icon(Icons.category, color: Colors.blue.shade800),
      ),
      style: TextStyle(color: Colors.blue.shade800),
      items: _categories
          .map((category) => DropdownMenuItem(
                value: category.categoryName,
                child: Text(category.categoryName),
              ))
          .toList(),
      onChanged: (value) {
        setState(() {
          _selectedCategory = value;
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select a category';
        }
        return null;
      },
    );
  }

  Widget _buildSwitchField(String label, bool value, Function(bool) onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.black, fontSize: 16)),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: Colors.blue,
        ),
      ],
    );
  }

  Widget _buildDropdownField(String label, String value, List<String> items,
      Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.blue.shade200),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      style: TextStyle(color: Colors.blue.shade800),
      items: items
          .map((type) => DropdownMenuItem(value: type, child: Text(type)))
          .toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildDateField(String label, DateTime value, Function() onTap) {
    return GestureDetector(
      onTap: onTap,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.blue.shade200),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "${value.toLocal()}".split(' ')[0],
              style: TextStyle(color: Colors.blue.shade800),
            ),
            Icon(Icons.calendar_today, color: Colors.blue.shade800),
          ],
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _postJob();
    }
  }

  @override
  void dispose() {
    _jobNameController.dispose();
    _jobRoleController.dispose();
    _jobDescriptionController.dispose();
    _companyNameController.dispose();
    _locationController.dispose();
    _vehicleTypeController.dispose();
    _salaryController.dispose();
    _jobOpeningsController.dispose();
    super.dispose();
  }
}
