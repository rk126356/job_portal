import 'package:flutter/material.dart';
import 'package:job_portal/const/const.dart';
import 'package:job_portal/const/url.dart';
import 'package:job_portal/navigation/provider_bottom_navigation.dart';
import 'package:job_portal/screens/auth/register_login_screen.dart';
import 'package:job_portal/utils/basic/navigate_tool.dart';
import 'package:job_portal/widgets/gradient_background.dart';
import 'package:provider/provider.dart';

import '../../controllers/basic/get_post_api.dart';
import '../../models/user/user_model.dart';
import '../../providers/user_provider.dart';
import '../../widgets/text_field.dart';

class ProviderRegisterLoginScreen extends StatefulWidget {
  const ProviderRegisterLoginScreen({super.key});

  @override
  State<ProviderRegisterLoginScreen> createState() =>
      _ProviderRegisterLoginScreenState();
}

class _ProviderRegisterLoginScreenState
    extends State<ProviderRegisterLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLogin = true;
  bool _acceptTerms = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  bool _isEmailVerified = false;
  bool _isButtonLoading = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  void _register() async {
    final provider = Provider.of<UserProvider>(context, listen: false);
    setState(() {
      _isButtonLoading = true;
    });

    final result = await postApi(
      url: '$providerBaseUrl/register.php',
      body: {
        'name': _nameController.text,
        'phone': _phoneController.text,
        'email': _emailController.text,
        'password': _passwordController.text,
      },
      showPopup: true,
    );

    if (result != null) {
      print(result);
      final user = UserModel.fromJson(result['data']);
      user.userType = UserType.provider;
      provider.setUserData(user);
      isUser = false;
      isProvider = true;
      push(context, const ProviderBottomNavigation());
    }

    setState(() {
      _isButtonLoading = false;
    });
  }

  void _login() async {
    final provider = Provider.of<UserProvider>(context, listen: false);
    setState(() {
      _isButtonLoading = true;
    });

    final result = await postApi(
      url: '$providerBaseUrl/login.php',
      body: {
        'email': _emailController.text,
        'password': _passwordController.text,
      },
      shouldPrint: true,
    );

    if (result != null) {
      print(result);
      final user = UserModel.fromJson(result['data']);
      user.userType = UserType.provider;
      provider.setUserData(user);
      isUser = false;
      isProvider = true;
      push(context, const ProviderBottomNavigation());
    }

    setState(() {
      _isButtonLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 40),
                  Text(
                    _isLogin
                        ? 'Welcome Back Provider'
                        : 'Create Service Provider Account',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade800,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  if (_isLogin) ...[
                    buildTextField(
                      controller: _emailController,
                      label: 'Email',
                      icon: Icons.email,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),
                    buildTextField(
                      controller: _passwordController,
                      label: 'Password',
                      icon: Icons.lock,
                      obscureText: _obscurePassword,
                      suffix: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.blue.shade800,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                  ] else ...[
                    buildTextField(
                      controller: _nameController,
                      label: 'Name',
                      icon: Icons.person,
                    ),
                    const SizedBox(height: 16),
                    buildTextField(
                      controller: _phoneController,
                      label: 'Phone',
                      icon: Icons.phone,
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 16),
                    buildTextField(
                      controller: _emailController,
                      label: 'Email',
                      icon: Icons.email,
                      keyboardType: TextInputType.emailAddress,
                      suffix: !_isLogin && _isEmailVerified
                          ? Icon(Icons.check_circle,
                              color: Colors.green.shade600)
                          : !_isLogin
                              ? TextButton(
                                  onPressed: _verifyEmail,
                                  child: Text('Verify',
                                      style: TextStyle(
                                          color: Colors.blue.shade800)),
                                )
                              : null,
                    ),
                    const SizedBox(height: 16),
                    buildTextField(
                      controller: _passwordController,
                      label: 'Password',
                      icon: Icons.lock,
                      obscureText: _obscurePassword,
                      suffix: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.blue.shade800,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    buildTextField(
                      controller: _confirmPasswordController,
                      label: 'Confirm Password',
                      icon: Icons.lock_outline,
                      obscureText: _obscureConfirmPassword,
                      suffix: IconButton(
                        icon: Icon(
                          _obscureConfirmPassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.blue.shade800,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureConfirmPassword = !_obscureConfirmPassword;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Checkbox(
                          value: _acceptTerms,
                          onChanged: (value) {
                            setState(() {
                              _acceptTerms = value ?? false;
                            });
                          },
                          activeColor: Colors.blue.shade800,
                        ),
                        Expanded(
                          child: Text(
                            'I accept the Terms & Conditions',
                            style: TextStyle(color: Colors.blue.shade800),
                          ),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 32),
                  _isButtonLoading
                      ? const Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                          onPressed: _submitForm,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade800,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            _isLogin ? 'Login' : 'Register',
                            style: const TextStyle(
                                fontSize: 18, color: Colors.white),
                          ),
                        ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _isLogin = !_isLogin;
                      });
                    },
                    child: Text(
                      _isLogin
                          ? 'Create an account'
                          : 'Already have an account? Login',
                      style: TextStyle(color: Colors.blue.shade800),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      push(context, const RegisterLoginScreen());
                    },
                    child: Text(
                      'Login as user',
                      style: TextStyle(color: Colors.blue.shade800),
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

  void _verifyEmail() {
    // Implement email verification logic here
    setState(() {
      _isEmailVerified = true;
    });
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (!_isLogin && !_acceptTerms) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please accept the Terms & Conditions')),
        );
        return;
      }
      if (_isLogin) {
        _login();
      }
      if (!_isLogin) {
        _register();
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
