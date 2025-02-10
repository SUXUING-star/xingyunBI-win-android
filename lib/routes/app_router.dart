// lib/routes/app_router.dart
import 'package:flutter/material.dart';
import '../screens/common/home_screen.dart';
import '../screens/common/about_screen.dart';
import '../screens/datasource/datasource_screen.dart';
import '../screens/dashboard/dashboard_screen.dart';
import '../layouts/main_layout.dart';
import '../models/models.dart';


class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (_) => MainLayout(
            currentPath: '/',
            child: const HomeScreen(),
          ),
        );
      case '/about':
        return MaterialPageRoute(
          builder: (_) => MainLayout(
            currentPath: '/about',
            child: const AboutScreen(),
          ),
        );

      case '/datasources':
        return MaterialPageRoute(
          builder: (_) => MainLayout(
            currentPath: '/datasources',
            child: const DataSourceScreen(),
          ),
        );

      case '/dashboard':
        return MaterialPageRoute(
          builder: (_) => MainLayout(
            currentPath: '/dashboard',
            child: DashboardScreen(
              dashboard: settings.arguments as Dashboard?,
            ),
          ),
        );


      default:
        return MaterialPageRoute(
          builder: (_) => MainLayout(
            currentPath: '/',
            child: const HomeScreen(),
          ),
        );
    }
  }
}