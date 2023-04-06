import 'package:docs_clone_with_nodejs_socket_io/repository/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../utils/colors.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});
  void signOut(WidgetRef ref) {
    ref.read(authRepositoryProvider).signOut();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(elevation: 0, backgroundColor: cWhiteColor, actions: [
        IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.add,
              color: cBlackColor,
            )),
        IconButton(
            onPressed: () {
              signOut(ref);
            },
            icon: const Icon(
              Icons.logout,
              color: cRedColor,
            )),
      ]),
      body: Center(child: Text(ref.watch(userProvider)!.email)),
    );
  }
}
