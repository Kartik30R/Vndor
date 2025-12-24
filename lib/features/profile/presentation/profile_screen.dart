import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vndor/features/auth/presentation/screens/auth_landing_screen.dart';
import 'package:vndor/features/auth/presentation/view_models/auth_viewmodel.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const Color meeshoPink = Color(0xFFF43397);

  @override
  Widget build(BuildContext context) {
    final authVM = context.watch<AuthViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),

      appBar: AppBar(
        title: const Text('Profile', style: TextStyle(color: Colors.white)),
        backgroundColor: meeshoPink,
        elevation: 0,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// PROFILE CARD
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  /// AVATAR
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: meeshoPink.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.person,
                      size: 40,
                      color: meeshoPink,
                    ),
                  ),

                  const SizedBox(height: 16),

                  /// EMAIL
                  Text(
                    authVM.user?.email ?? '',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    'Vendor Account',
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            /// LOGOUT BUTTON
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.logout),
                label: const Text(
                  'Logout',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () async {
                  await authVM.logout();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => AuthLandingScreen()),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
