import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:go_router/go_router.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import '../../../../../../common/widgets/buttons/primary_button.dart';
import '../../../../../../common/widgets/form/custom_form_field.dart';
import '../../../../../../utils/constants/image_strings.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../../../utils/constants/text_strings.dart';
import '../../../../../../utils/popups/full_screen_loader.dart';
import '../../../../../../utils/popups/loaders.dart';
import '../../../bloc/email_auth_bloc/email_auth_bloc.dart';
import '../verify_email.dart';
import 'terms_and_condition_oncheckbox.dart';

class SignUpFormWidget extends StatefulWidget {
  const SignUpFormWidget({super.key});

  @override
  State<SignUpFormWidget> createState() => _SignUpFormWidgetState();
}

class _SignUpFormWidgetState extends State<SignUpFormWidget> {
  final email = TextEditingController();
  final fullName = TextEditingController();
  final password = TextEditingController();
  final phoneNumber = TextEditingController();
  final GlobalKey<FormState> _signupFormKey = GlobalKey<FormState>();

  bool privacyPolicy = false;
  bool hidePassword = true;

  @override
  void dispose() {
    email.dispose();
    fullName.dispose();
    password.dispose();
    phoneNumber.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EmailAuthBloc, EmailAuthState>(
      listener: (context, state) {
        if (state is EmailAuthLoading) {
          TFullScreenLoader.openLoadingDialog(
            'We are processing your information....',
            AppImages.docerAnimation,
            context,
          );
        }

        if (state is EmailAuthFailure) {
          TFullScreenLoader.stopLoading(context);
          TLoaders.errorSnackBar(
            title: 'Error',
            message: state.errorMessage,
            context: context,
          );
        }

        if (state is EmailAuthSuccess) {
          TFullScreenLoader.stopLoading(context);
          TLoaders.successSnackBar(
            title: 'Success',
            message:
            'Your account has been created successfully! Please verify your email.',
            context: context,
          );
          context.pushNamed(
            VerifyEmailScreen.routeName,
            queryParameters: {'email': email.text.trim()},
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.only(
          top: Sizes.xl,
          bottom: Sizes.xl,
        ),
        child: Form(
          key: _signupFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Full Name Field
              CustomFormfieldWidget.withdownEar(
                label: AppTexts.fullName,
                controller: fullName,
                prefixIcon: const Icon(LineAwesomeIcons.user),
                validator: (String? value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Full name is required';
                  }
                  if (value.trim().length < 3) {
                    return 'Full name must be at least 3 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: Sizes.spaceBtwInputFields),

              // 2. Email Field
              CustomFormfieldWidget.withdownEar(
                label: AppTexts.email,
                controller: email,
                prefixIcon: const Icon(LineAwesomeIcons.envelope),
                validator: (String? value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Email is required';
                  }
                  final emailRegex =
                  RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                  if (!emailRegex.hasMatch(value.trim())) {
                    return 'Enter a valid email address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: Sizes.spaceBtwInputFields),

              // 3. Phone Number Field
              CustomFormfieldWidget.withdownEar(
                label: AppTexts.phoneNo,
                controller: phoneNumber,
                prefixIcon: const Icon(LineAwesomeIcons.phone_solid),
                validator: (String? value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Phone number is required';
                  }
                  final digitsOnly = value.replaceAll(RegExp(r'\D'), '');
                  if (digitsOnly.length < 10 || digitsOnly.length > 15) {
                    return 'Enter a valid phone number';
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
                  prefixIcon: const Icon(Icons.fingerprint),
                  suffixIcon: IconButton(
                    onPressed: () =>
                        setState(() => hidePassword = !hidePassword),
                    icon: Icon(
                      hidePassword
                          ? LineAwesomeIcons.eye_slash
                          : LineAwesomeIcons.eye,
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

              TermsAndConditionOncheckbox(
                valueChanged: (bool value) => privacyPolicy = value,
              ),
              const SizedBox(height: Sizes.spaceBtwSections),

              // 6. Submit Button
              BlocBuilder<EmailAuthBloc, EmailAuthState>(
                builder: (context, state) {
                  return PrimaryButton(
                    isLoading: state is EmailAuthLoading,
                    text: AppTexts.signup.tr,
                    onPressed: () {
                      if (_signupFormKey.currentState!.validate()) {
                        if (!privacyPolicy) {
                          TLoaders.warningSnackBar(
                            title: 'Accept Privacy Policy',
                            message:
                            'In order to create account, you must have to read and accept the Privacy Policy & Terms of Use.',
                            context: context,
                          );
                          return;
                        }
                        context.read<EmailAuthBloc>().add(
                          SignUpWithEmailEvent(
                            userName: fullName.text.trim(),
                            email: email.text.trim(),
                            password: password.text.trim(),
                            phoneNumber: phoneNumber.text.trim(),
                          ),
                        );
                      }
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}