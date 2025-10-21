import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../data/response/api_response.dart';
import '../../utils/app_styles.dart';
import '../../utils/validation.dart';
import '../../view_model/auth_view_model.dart';
import '../../view_model/form_state_provider.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final formProvider = Provider.of<FormStateProvider>(context, listen: false);
    _nameController.text = formProvider.formData['register']?['name'] ?? '';
    _emailController.text = formProvider.formData['register']?['email'] ?? '';
    _passwordController.text = formProvider.formData['register']?['password'] ?? '';
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _register(BuildContext context) {
    final formProvider = Provider.of<FormStateProvider>(context, listen: false);
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    context.go('/screen_selection');
    // if (_formKey.currentState!.validate() && formProvider.validateSection('register')) {
    //   authViewModel.register(
    //     _emailController.text.trim(),
    //     _passwordController.text.trim(),
    //     _nameController.text.trim(),
    //     onError: (message) {
    //       ScaffoldMessenger.of(context).showSnackBar(
    //         SnackBar(
    //           content: Text(message),
    //           backgroundColor: AppStyles.errorColor,
    //         ),
    //       );
    //     },
    //   ).then((_) {
    //     if (authViewModel.registrationState.status == Status.completed) {
    //
    //     }
    //   });
    //   formProvider.submitForm();
    // } else {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(
    //       content: const Text('Please correct the errors in the form'),
    //       backgroundColor: AppStyles.errorColor,
    //     ),
    //   );
    // }
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    final formProvider = Provider.of<FormStateProvider>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: AppStyles.screenPadding,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildTextField(
                  context,
                  controller: _nameController,
                  labelText: 'Full Name',
                  hintText: 'Enter your full name',
                  icon: Icons.person_outline,
                  validator: (value) {
                    final error = checkFieldValidation(
                      context: context,
                      val: value,
                      fieldName: 'Full Name',
                      fieldType: VALIDATION_TYPE.TEXT,
                    );
                    formProvider.setValidationError('register', 'name', error);
                    return error;
                  },
                  onChanged: (value) {
                    formProvider.updateField('register', 'name', value);
                  },
                ),
                _buildTextField(
                  context,
                  controller: _emailController,
                  labelText: 'Email',
                  hintText: 'Enter your email',
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    final error = checkFieldValidation(
                      context: context,
                      val: value,
                      fieldName: 'Email',
                      fieldType: VALIDATION_TYPE.EMAIL,
                    );
                    formProvider.setValidationError('register', 'email', error);
                    return error;
                  },
                  onChanged: (value) {
                    formProvider.updateField('register', 'email', value);
                  },
                ),
                _buildTextField(
                  context,
                  controller: _passwordController,
                  labelText: 'Password',
                  hintText: 'Enter your password',
                  icon: Icons.lock_outline,
                  obscureText: true,
                  validator: (value) {
                    final error = checkFieldValidation(
                      context: context,
                      val: value,
                      fieldName: 'Password',
                      fieldType: VALIDATION_TYPE.PASSWORD,
                    );
                    formProvider.setValidationError('register', 'password', error);
                    return error;
                  },
                  onChanged: (value) {
                    formProvider.updateField('register', 'password', value);
                  },
                ),
                CustomButton(
                  text: authViewModel.registrationState.status == Status.loading
                      ? 'Registering...'
                      : 'Register',
                  onPressed: authViewModel.registrationState.status == Status.loading
                      ? () {}
                      : () => _register(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      BuildContext context, {
        required TextEditingController controller,
        required String labelText,
        required String hintText,
        required IconData icon,
        TextInputType? keyboardType,
        bool obscureText = false,
        String? Function(String?)? validator,
        ValueChanged<String>? onChanged,
      }) {
    return Padding(
      padding: AppStyles.fieldPadding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppStyles.inputFillColor(context),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppStyles.secondaryTextColor),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: CustomTextField(
              controller: controller,
              labelText: labelText,
              hintText: hintText,
              keyboardType: keyboardType,
              // obscureText: obscureText,
              validator: validator,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}