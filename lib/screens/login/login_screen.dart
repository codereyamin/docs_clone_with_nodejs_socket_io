import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../repository/auth_repository.dart';
import '../../utils/colors.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  void signInWithGoogle(WidgetRef ref) {
    ref.read(authRepositoryProvider).signInWithGoogle();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: ElevatedButton.icon(
          onPressed: () => signInWithGoogle(ref),
          icon: const Icon(
            Icons.g_mobiledata,
            color: cBlackColor,
          ),
          label: const Text(
            "Login with google",
            style: TextStyle(color: cBlackColor),
          ),
          style: ElevatedButton.styleFrom(
              backgroundColor: cWhiteColor, minimumSize: const Size(150, 50)),
        ),
      ),
    );
  }
}
