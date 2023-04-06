import 'package:docs_clone_with_nodejs_socket_io/models/error_model.dart';
import 'package:docs_clone_with_nodejs_socket_io/repository/auth_repository.dart';
import 'package:docs_clone_with_nodejs_socket_io/screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

import 'routers/router.dart';
import 'screens/login/login_screen.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  ErrorModel? errorModel;
  @override
  void initState() {
    getUserData();
    super.initState();
  }

  getUserData() async {
    errorModel = await ref.read(authRepositoryProvider).getUserData();

    if (errorModel != null && errorModel!.data != null) {
      ref.read(userProvider.notifier).update((state) => errorModel!.data);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'google docks',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routerDelegate: RoutemasterDelegate(
        routesBuilder: (context) {
          final user = ref.watch(userProvider);

          if (user != null && user.token.isNotEmpty) {
            return loggedInRoute;
          } else {
            return loggedOutRoute;
          }
        },
      ),
      routeInformationParser: const RoutemasterParser(),
    );
  }
}
