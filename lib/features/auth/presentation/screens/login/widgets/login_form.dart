import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../../../common/preferences/preferences_manager.dart';
import '../../../../../../common/widgets/buttons/clickable_richtext_widget.dart';
import '../../../../../../common/widgets/buttons/primary_button.dart';
import '../../../../../../common/widgets/form/custom_form_field.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../../../utils/constants/text_strings.dart';
import '../../../../../../utils/popups/loaders.dart';
import '../../../bloc/email_auth_bloc/email_auth_bloc.dart';
import '../../signup/signup_screen.dart';
import '../../signup/verify_email.dart';
import 'remember_me_widget.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final email = TextEditingController();
  final password = TextEditingController();
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();

  bool rememberMe = false;
  bool hidePassword = true;

  @override
  void initState() {
    super.initState();
    _loadRememberedData();
  }

  void _loadRememberedData() {
    final prefs = PreferencesManager();
    final savedRememberMe = prefs.getBool('rememberMe') ?? false;
    if (savedRememberMe) {
      final savedEmail = prefs.getString('remembered_email') ?? '';
      setState(() {
        rememberMe = true;
        email.text = savedEmail;
      });
    }
  }

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EmailAuthBloc, EmailAuthState>(
      listener: (context, state) async {
        if (state is EmailAuthFailure) {
          TLoaders.errorSnackBar(
            title: 'Error',
            message: state.errorMessage,
            context: context,
          );
        }

        if (state is EmailNotVerified) {
          TLoaders.warningSnackBar(
            title: 'Warning',
            message: 'You must verify your email',
            context: context,
          );

          context.pushNamed(
            VerifyEmailScreen.routeName,
            queryParameters: {'email': email.text.trim()},
          );
        }

        if (state is EmailAuthSuccess) {
          final prefs = PreferencesManager();
          await prefs.setBool('rememberMe', rememberMe);

          if (rememberMe) {
            await prefs.setString('remembered_email', email.text.trim());
          } else {
            await prefs.remove('remembered_email');
          }

          TLoaders.successSnackBar(
            title: 'Success',
            message: 'Your account has been logged in successfully!',
            context: context,
          );

          context.goNamed('dashboard');
        }
      },
      child: Form(
        key: _loginFormKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: Sizes.spaceBtwSections),
          child: Column(
            children: [
              CustomFormfieldWidget.withdownEar(
                label: AppTexts.email,
                controller: email,
                prefixIcon: const Icon(Iconsax.direct_right),
                validator: (String? value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Email is required';
                  }
                  final emailRegex = RegExp(
                    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                  );
                  if (!emailRegex.hasMatch(value.trim())) {
                    return 'Enter a valid email address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: Sizes.spaceBtwInputFields),

              TextFormField(
                controller: password,
                obscureText: hidePassword,
                decoration: InputDecoration(
                  labelText: AppTexts.password,
                  prefixIcon: const Icon(Iconsax.password_check),
                  suffixIcon: IconButton(
                    onPressed: () =>
                        setState(() => hidePassword = !hidePassword),
                    icon: Icon(
                      hidePassword ? Iconsax.eye_slash : Iconsax.eye,
                    ),
                  ),
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Password is required';
                  }
                  if (value.length < 8) {
                    return 'Password must be at least 8 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: Sizes.spaceBtwInputFields / 2),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RememberMe(
                    value: rememberMe,
                    onChanged: (value) {
                      setState(() {
                        rememberMe = value ?? false;
                      });
                    },
                  ),
                  TextButton(
                    onPressed: () => context.push('/forget'),
                    child: const Text(AppTexts.forgetPassword),
                  ),
                ],
              ),
              const SizedBox(height: Sizes.spaceBtwSections),

              BlocBuilder<EmailAuthBloc, EmailAuthState>(
                builder: (context, state) {
                  return PrimaryButton(
                    isLoading: state is EmailAuthLoading,
                    text: AppTexts.login.tr,
                    onPressed: (state is EmailAuthLoading)
                        ? () {}
                        : () async {
                      if (_loginFormKey.currentState!.validate()) {
                        context.read<EmailAuthBloc>().add(
                          SignInWithEmailEvent(
                            email: email.text.trim(),
                            password: password.text.trim(),
                          ),
                        );
                      }
                    },
                  );
                },
              ),
              const SizedBox(height: Sizes.spaceBtwItems),

              ClickableRichTextWidget(
                text1: "Don't have an account? ",
                text2: AppTexts.signup,
                onPressed: () =>
                    context.pushNamed(SignupScreen.routeName),
              ),
            ],
          ),
        ),
      ),
    );
  }
}