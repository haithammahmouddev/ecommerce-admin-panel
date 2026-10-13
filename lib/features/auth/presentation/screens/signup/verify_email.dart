import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../common/di/injection_container.dart';
import '../../../../../common/widgets/appbar/appbar.dart';
import '../../../../../utils/constants/image_strings.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/text_strings.dart';
import '../../../../../utils/popups/loaders.dart';
import '../../cubit/session_cubit/session_cubit.dart';
import '../../cubit/verify_email_cubit/verify_email_cubit.dart';

class VerifyEmailScreen extends StatelessWidget {
  const VerifyEmailScreen({super.key, required this.email});
  final String email;
  static const routeName = 'verify-email';

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<VerifyEmailCubit>()..sendVerificationEmail(),
        ),
        BlocProvider(
          create: (context) => sl<SessionCubit>(),
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<VerifyEmailCubit, VerifyEmailState>(
            listener: (context, state) {
              if (state.status == VerifyEmailStatus.failure) {
                TLoaders.errorSnackBar(
                  title: 'Oh Snap!',
                  context: context,
                  message: state.message ?? 'Failed to send verification email.',
                );
              }
              if (state.status == VerifyEmailStatus.sent) {
                TLoaders.successSnackBar(
                  title: 'Sent',
                  context: context,
                  message: state.message ?? 'Verification email sent successfully!',
                );
              }
              if (state.status == VerifyEmailStatus.verified) {
                context.pushReplacementNamed(
                  'success-screen',
                  queryParameters: {
                    'image': AppImages.successfullyRegisterAnimation,
                    'title': AppTexts.yourAccountCreatedTitle,
                    'subTitle': AppTexts.yourAccountCreatedSubTitle,
                  },
                  extra: context.read<VerifyEmailCubit>(),
                );
              }
            },
          ),
          BlocListener<SessionCubit, SessionState>(
            listener: (context, state) {
              if (state is Unauthenticated) {
                TLoaders.warningSnackBar(
                  title: 'Session Expired',
                  message: 'You have been logged out. Please log in again.',
                  context: context,
                );
                context.pushReplacementNamed('login');
              }
              if (state is SessionError) {
                TLoaders.errorSnackBar(
                  title: 'Oh Snap!',
                  context: context,
                  message: state.message,
                );
              }
            },
          ),
        ],
        child: Builder(
          builder: (context) {
            final controller = context.read<VerifyEmailCubit>();
            return Scaffold(
              appBar: AppBarCustom(
                actions: [
                  IconButton(
                    onPressed: () {
                      context.read<SessionCubit>().SignOut();
                    },
                    icon: const Icon(CupertinoIcons.clear),
                  ),
                ],
                showActions: true,
                showSkipButton: false,
              ),
              body: Center(
                child: SingleChildScrollView(
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 550),
                    padding: const EdgeInsets.all(Sizes.defaultSpace),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Image(
                          image: AssetImage(AppImages.deliveredEmailIllustration),
                          width: 260,
                          height: 260,
                        ),
                        const SizedBox(height: Sizes.spaceBtwSections),

                        Text(
                          AppTexts.confirmEmail,
                          style: Theme.of(context).textTheme.headlineMedium,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: Sizes.spaceBtwItems),
                        Text(
                          email,
                          style: Theme.of(context).textTheme.labelLarge,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: Sizes.spaceBtwItems),
                        Text(
                          AppTexts.confirmEmailSubTitle,
                          style: Theme.of(context).textTheme.labelMedium,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: Sizes.spaceBtwSections),

                        SizedBox(
                          width: double.infinity,
                          child: BlocSelector<VerifyEmailCubit, VerifyEmailState, bool>(
                            selector: (state) => state.status == VerifyEmailStatus.checkLoading,
                            builder: (context, isLoading) {
                              return ElevatedButton(
                                onPressed: isLoading
                                    ? null
                                    : () {
                                  controller.checkEmailVerificationStatus(
                                    context,
                                    controller,
                                  );
                                },
                                child: isLoading
                                    ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                                    : const Text(AppTexts.continueText),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: Sizes.spaceBtwItems),

                        SizedBox(
                          width: double.infinity,
                          child: BlocSelector<VerifyEmailCubit, VerifyEmailState, bool>(
                            selector: (state) => state.status == VerifyEmailStatus.resendLoading,
                            builder: (context, isLoading) {
                              return TextButton(
                                onPressed: isLoading
                                    ? null
                                    : () {
                                  controller.resendVerificationEmail();
                                },
                                child: isLoading
                                    ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                                    : const Text(AppTexts.resendEmail),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}