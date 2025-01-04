import 'package:flutter/material.dart';
import 'package:job_portal/const/const.dart';
import 'package:job_portal/const/url.dart';
import 'package:job_portal/controllers/basic/get_post_api.dart';
import 'package:job_portal/models/user/user_model.dart';
import 'package:job_portal/screens/auth/provider_register_login_screen.dart';
import 'package:job_portal/utils/basic/navigate_tool.dart';
import 'package:job_portal/utils/basic/toast.dart';
import 'package:job_portal/widgets/gradient_background.dart';
import 'package:provider/provider.dart';

import '../../navigation/bottom_navigation.dart';
import '../../providers/user_provider.dart';
import '../../widgets/text_field.dart';

class RegisterLoginScreen extends StatefulWidget {
  const RegisterLoginScreen({super.key});

  @override
  State<RegisterLoginScreen> createState() => _RegisterLoginScreenState();
}

class _RegisterLoginScreenState extends State<RegisterLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLogin = false;
  bool _acceptTerms = false;

  bool _isEmailVerified = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isButtonLoading = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  void _register() async {
    final provider = Provider.of<UserProvider>(context, listen: false);
    setState(() {
      _isButtonLoading = true;
    });

    final result = await postApi(
      url: '$userBaseUrl/register.php',
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
      provider.setUserData(user);
      isUser = true;
      isProvider = false;
      push(context, const BottomNavigation());
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
      url: '$userBaseUrl/login.php',
      body: {
        'email': _emailController.text,
        'password': _passwordController.text,
      },
      shouldPrint: true,
    );

    if (result != null) {
      print(result);
      final user = UserModel.fromJson(result['data']);
      provider.setUserData(user);
      isUser = true;
      isProvider = false;
      push(context, const BottomNavigation());
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
                    _isLogin ? 'Welcome Back' : 'Create Account',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade800,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  if (!_isLogin) ...[
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
                  ],
                  buildTextField(
                    controller: _emailController,
                    label: 'Email',
                    icon: Icons.email,
                    keyboardType: TextInputType.emailAddress,
                    suffix: !_isLogin && _isEmailVerified
                        ? Icon(Icons.check_circle, color: Colors.green.shade600)
                        : !_isLogin
                            ? TextButton(
                                onPressed: _verifyEmail,
                                child: Text('Verify',
                                    style:
                                        TextStyle(color: Colors.blue.shade800)),
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
                  if (!_isLogin) ...[
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
                      ? const Center(
                          child: CircularProgressIndicator.adaptive())
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
                      push(context, const ProviderRegisterLoginScreen());
                    },
                    child: Text(
                      'Login as service provider',
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
    // final provider = Provider.of<UserProvider>(context, listen: false);
    // provider.setTempUser(UserType.user);
    if (_formKey.currentState!.validate()) {
      if (!_isLogin && !_acceptTerms) {
        showError('Please accept the Terms & Conditions');

        return;
      }
      if (!_isLogin) {
        _register();
      }

      if (_isLogin) {
        _login();
      }
      // Implement login or registration logic here
      print(_isLogin ? 'Logging in...' : 'Registering...');
    }
    // isProvider = false;
    // isUser = true;
    // push(context, const AccountSetupScreen());
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
