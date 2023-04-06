import 'package:docs_clone_with_nodejs_socket_io/screens/home/home_screen.dart';
import 'package:docs_clone_with_nodejs_socket_io/screens/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

final loggedOutRoute = RouteMap(
  routes: {
    "/": (route) => const MaterialPage(
          child: LoginScreen(),
        ),
  },
);

final loggedInRoute = RouteMap(
  routes: {
    "/": (route) => const MaterialPage(
          child: HomeScreen(),
        ),
  },
);
