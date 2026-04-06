import 'package:dine_ease/providers/user/user_repository.dart';
import 'package:dine_ease/providers/auth/auth_controller.dart';
import 'package:dine_ease/providers/supabase_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:dine_ease/pages/login.dart';
import 'package:dine_ease/pages/profile/loyality_points.dart';
import 'package:dine_ease/pages/profile/personal_info.dart';
import 'package:dine_ease/pages/profile/refer_friend.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});
  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  String? _profileUsername;
  bool _loadingProfile = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    if (!mounted) return;
    setState(() { _loadingProfile = true; });
    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;
    setState(() {
      _profileUsername = 'Guest User';
      _loadingProfile = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(supabaseProvider).auth.currentUser;

    // keep layout consistent with other pages: dark background, card-like content area
    const themeBg = Color.fromARGB(255, 11, 23, 36);
    const headerBg = Color.fromARGB(255, 15, 31, 48);
    const textWhite = Colors.white;
    const textMuted = Colors.white70;
    // placeholder values; replace with real user data if available
    final userEmail = user?.email ?? 'jo@gmail.com';
    final displayName = _loadingProfile
        ? 'Loading...'
        : (_profileUsername ??
              (userEmail.contains('@') ? userEmail.split('@').first : 'User'));
    const rewardPoints = 0;

    return Scaffold(
      backgroundColor: headerBg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Profile'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // top user header
            Container(
              width: double.infinity,
              color: headerBg,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 42,
                    backgroundImage: AssetImage('assets/images/mesob.png'),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          displayName,
                          style: const TextStyle(
                            color: textWhite,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          userEmail,
                          style: const TextStyle(
                            color: textMuted,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      // navigate to edit profile (if implemented)
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const PersonalInformation(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.edit_note, color: Colors.white70),
                  ),
                ],
              ),
            ),

            // content area
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: themeBg,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Rewards',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const LoyalityPoint()),
                    ),
                    child: const ProfileTile(
                      labelText: 'Loyalty Points',
                      icon: Icons.loyalty_rounded,
                      trailingText: '$rewardPoints points',
                    ),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ReferFriend()),
                    ),
                    child: const ProfileTile(
                      labelText: 'Refer a friend',
                      icon: Icons.person_add_alt_1_outlined,
                    ),
                  ),

                  const SizedBox(height: 20),
                  const Text(
                    'Your Activity',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const ProfileTile(labelText: 'History', icon: Icons.history),

                  const SizedBox(height: 20),
                  const Text(
                    'TheMosob Pay',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const ProfileTile(labelText: 'Payment', icon: Icons.payments),

                  const SizedBox(height: 20),
                  const Text(
                    'Settings',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/settings_page'),
                    child: const ProfileTile(
                      labelText: 'App settings',
                      icon: Icons.settings,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // logout row
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            final controller = ref.read(
                              authControllerProvider.notifier,
                            );
                            await controller.logout();
                            if (!mounted) return;
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (_) => const Login()),
                              (route) => false,
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            decoration: BoxDecoration(
                              color: Colors.deepOrange,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            alignment: Alignment.center,
                            child: const Text(
                              'Log out',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),
                  const Center(
                    child: Text(
                      'App version 1.0.0',
                      style: TextStyle(color: Colors.white54),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Small reusable tile to match other pages' simple layout
class ProfileTile extends StatelessWidget {
  const ProfileTile({
    super.key,
    this.trailingText,
    required this.labelText,
    required this.icon,
  });

  final String labelText;
  final IconData icon;
  final String? trailingText;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Icon(icon, color: Colors.white70),
          const SizedBox(width: 12),
          Text(
            labelText,
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const Spacer(),
          if (trailingText != null)
            Text(trailingText!, style: const TextStyle(color: Colors.white70)),
          const SizedBox(width: 8),
          const Icon(Icons.chevron_right, color: Colors.white24),
        ],
      ),
    );
  }
}
