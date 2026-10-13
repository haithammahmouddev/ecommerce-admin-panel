import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../../utils/constants/sizes.dart';
import '../../../../../../utils/constants/text_strings.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return  SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          ClipOval(
            child: Image(
              width: 100,
              height: 100,
              fit: BoxFit.cover,
              image: AssetImage('assets/images/profile/89a8d3e7-5666-4676-a7b2-8244ced04447.png'),
            ),
          ),
          const SizedBox(height: Sizes.spaceBtwSections),
          Text(AppTexts.loginTitle, style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: Sizes.sm),
          Text(AppTexts.loginSubTitle, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}
