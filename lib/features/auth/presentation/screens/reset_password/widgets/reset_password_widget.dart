import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../utils/constants/image_strings.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../../../utils/constants/text_strings.dart';
import '../../../../../../utils/popups/loaders.dart';
import '../../../cubit/reset_password_cubit/reset_password_cubit.dart';

class ResetPasswordWidget extends StatelessWidget {
  const ResetPasswordWidget({super.key, required this.email});
  final String email;

  @override
  Widget build(BuildContext context) {
    return BlocListener<ResetPasswordCubit, ResetPasswordState>(
      listener: (context, state) {
        if (state is ResetPasswordFailure) {
          TLoaders.errorSnackBar(
            title: 'Error',
            message: state.errorMessage,
            context: context,
          );
        }
        if (state is ResetPasswordSuccess) {
          TLoaders.successSnackBar(
            title: 'Email Sent',
            message: 'Password reset link sent again to $email',
            context: context,
          );
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                onPressed: () => context.goNamed('login'),
                icon: const Icon(CupertinoIcons.clear),
              ),
            ],
          ),
          const SizedBox(height: Sizes.spaceBtwItems),

          const Image(
            image: AssetImage(AppImages.deliveredEmailIllustration),
            width: 250,
            height: 250,
          ),
          const SizedBox(height: Sizes.spaceBtwItems),

          Text(
            'Password Reset Email Sent',
            style: Theme.of(context).textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: Sizes.spaceBtwItems / 2),
          Text(
            email,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelLarge,
          ),
          const SizedBox(height: Sizes.spaceBtwItems),

          Text(
            'Your account security is our priority! We have sent you a secure link to safely change your password and keep your account protected.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelMedium,
          ),
          const SizedBox(height: Sizes.spaceBtwSections),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => context.goNamed('login'),
              child: const Text(AppTexts.done),
            ),
          ),
          const SizedBox(height: Sizes.spaceBtwItems),

          BlocBuilder<ResetPasswordCubit, ResetPasswordState>(
            builder: (context, state) {
              return SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: state is ResetPasswordLoading
                      ? null
                      : () {
                    context
                        .read<ResetPasswordCubit>()
                        .sendPasswordResetEmail(email: email);
                  },
                  child: state is ResetPasswordLoading
                      ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                      : const Text(AppTexts.resendEmail),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}