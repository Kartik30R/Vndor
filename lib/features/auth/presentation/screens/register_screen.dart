import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vndor/core/utils/validator.dart';
import 'package:vndor/core/widgets/app_shell.dart';
import 'package:vndor/features/auth/presentation/view_models/auth_viewmodel.dart';
import '../../../../core/widgets/common_widgets.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  static const Color meeshoPink = Color(0xFFF43397);

  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<AuthViewModel>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
  if (!mounted) return;

  if (vm.state == AuthState.authenticated && vm.user != null) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (_) => AppShell(
          vendorId: vm.user!.uid,
        ),
      ),
      (route) => false, 
    );
  }
});
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      appBar: AppBar(
        title: const Text('Create Account'),
        backgroundColor: meeshoPink,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Create your account',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Start selling with vndor',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),

                  const SizedBox(height: 24),

                  TextFormField(
                    controller: emailController,
                    validator: Validators.email,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                  ),

                  const SizedBox(height: 16),

                  TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    validator: Validators.required,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.lock_outline),
                    ),
                  ),

                  const SizedBox(height: 24),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: meeshoPink,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: vm.state == AuthState.loading
                        ? null
                        : () {
                            if (_formKey.currentState!.validate()) {
                              vm.register(
                                emailController.text.trim(),
                                passwordController.text.trim(),
                              );
                              
                            }
                          },
                    child: vm.state == AuthState.loading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'Register',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),

                  if (vm.state == AuthState.error) ...[
                    const SizedBox(height: 16),
                    AppError(
                      message: vm.errorMessage ?? 'Registration failed',
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
