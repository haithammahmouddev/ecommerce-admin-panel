import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../common/di/injection_container.dart';
import '../../../../../../utils/constants/colors.dart';
import '../../../../../../utils/constants/image_strings.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../../../utils/helpers/helper_functions.dart';
import '../../../../../../utils/popups/loaders.dart';
import '../../../cubit/social_auth-bloc/social_auth_cubit.dart';

class TSocialButtons extends StatelessWidget {
  const TSocialButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = HelperFunctions.isDarkMode(context);

    return BlocProvider(
      create: (context) => sl<SocialAuthCubit>(),
      child: BlocConsumer<SocialAuthCubit, SocialAuthState>(
        listener: (context, state) {
          if (state is SocialAuthFailure) {
            TLoaders.errorSnackBar(
              title: 'خطأ في تسجيل الدخول',
              message: state.errorMessage,
              context: context,
            );
          }

          if (state is SocialAuthSuccess) {
            TLoaders.successSnackBar(
              title: 'تم بنجاح',
              message: 'تم تسجيل الدخول باستخدام حساب جوجل بنجاح',
              context: context,
            );
            context.goNamed('dashboard');
          }
        },
        builder: (context, state) {
          final isLoading = state is SocialAuthLoading;

          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: dark ? AppColors.darkGrey : AppColors.grey,
                  ),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: IconButton(
                  onPressed: isLoading
                      ? null
                      : () {
                    context.read<SocialAuthCubit>().signInWithGoogle();
                  },
                  icon: isLoading
                      ? const SizedBox(
                    width: Sizes.iconMd,
                    height: Sizes.iconMd,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                      : const Image(
                    width: Sizes.iconMd,
                    height: Sizes.iconMd,
                    image: AssetImage(AppImages.googleLogo),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}