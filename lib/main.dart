import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:vndor/core/widgets/app_shell.dart';
import 'package:vndor/firebase_options.dart';
import 'package:vndor/features/auth/presentation/screens/auth_landing_screen.dart';
import 'di/service_locator.dart'; 

import 'features/auth/presentation/view_models/auth_viewmodel.dart';
import 'features/dashboard/presentation/viewmodels/dashboard_viewmodel.dart';
import 'features/order/presentation/viewmodel/order_viewmodel.dart';
import 'features/product/presentation/viewmodel/product_viewmodel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

   await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

   await init(); 

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
         ChangeNotifierProvider<AuthViewModel>(
          create: (_) => sl<AuthViewModel>(),
        ),

         ChangeNotifierProvider<DashboardViewModel>(
          create: (_) => sl<DashboardViewModel>(),
        ),

         ChangeNotifierProvider<OrderViewModel>(
          create: (_) => sl<OrderViewModel>(),
        ),

         ChangeNotifierProvider<ProductViewModel>(
          create: (_) => sl<ProductViewModel>(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Vendor Panel',
        theme: ThemeData(
          primarySwatch: Colors.purple,
        ),
        home: const RootScreen(),
      ),
    );
  }
}
class RootScreen extends StatelessWidget {
  const RootScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authVM = context.watch<AuthViewModel>();

    if (authVM.state == AuthState.loading ||
        authVM.state == AuthState.initial) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (authVM.state == AuthState.authenticated &&
        authVM.user != null) {
      return AppShell(
        vendorId: authVM.user!.uid,
      );
    }

    return const AuthLandingScreen();
  }
}
