import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:dine_ease/pages/profile/update_password.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dine_ease/providers/user/user_repository.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:dine_ease/pages/login.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AppSettings extends ConsumerStatefulWidget {
  const AppSettings({super.key});

  @override
  ConsumerState<AppSettings> createState() => _AppSettingsState();
}

class _AppSettingsState extends ConsumerState<AppSettings> {
  String _displayName = 'User';
  int _themeIndex = 1; // 0 for Dark, 1 for Light (initial)
  bool _notificationsEnabled = true;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final userRepo = ref.read(userRepositoryProvider);
    final profile = await userRepo.getProfile();
    if (profile != null) {
      setState(() {
        _displayName = profile['fullName'] ?? 'User';
        _themeIndex = profile['preferences']?['theme'] == 'dark' ? 0 : 1;
        _notificationsEnabled = profile['preferences']?['notifications'] ?? true;
        _loading = false;
      });
    } else {
      setState(() => _loading = false);
    }
  }

  Future<void> _handleDeleteAccount() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF162236),
        title: const Text('Delete Account', style: TextStyle(color: Colors.white)),
        content: const Text(
          'Are you sure you want to delete your account? This action cannot be undone.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete', style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final success = await ref.read(userRepositoryProvider).deleteAccount();
      if (success) {
        await Supabase.instance.client.auth.signOut();
        if (!mounted) return;
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const Login()),
          (route) => false,
        );
      } else {
        Fluttertoast.showToast(msg: 'Failed to delete account');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        backgroundColor: Color.fromARGB(255, 10, 24, 39),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 10, 24, 39),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 40,
              color: const Color.fromARGB(255, 31, 43, 43),
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                ),
                const SizedBox(width: 30),
                const Text(
                  'Settings',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const CircleAvatar(
              backgroundImage: AssetImage('assets/images/mesob.png'),
              radius: 45,
            ),
            const SizedBox(height: 10),
            Text(
              _displayName,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Color.fromARGB(255, 223, 166, 73),
              ),
            ),
            const SizedBox(height: 15),
            Container(
              width: 200,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color.fromARGB(255, 58, 36, 18),
                    Color.fromARGB(255, 41, 37, 33),
                  ],
                ),
                border: Border.all(
                  color: Colors.white10,
                  width: 0.7,
                  strokeAlign: BorderSide.strokeAlignOutside,
                ),
                borderRadius: BorderRadius.circular(7),
              ),
              child: const Padding(
                padding: EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      'Mesob Website',
                      style: TextStyle(
                        color: Color.fromARGB(220, 255, 255, 255),
                      ),
                    ),
                    Icon(
                      Icons.arrow_outward_outlined,
                      color: Color.fromARGB(255, 219, 157, 56),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            ListTile(
              leading: const Icon(
                Icons.light_mode,
                color: Color.fromARGB(255, 199, 162, 102),
              ),
              title: const Text(
                'Theme Mode',
                style: TextStyle(color: Color.fromARGB(217, 255, 255, 255)),
              ),
              trailing: ToggleSwitch(
                animate: true,
                animationDuration: 150,
                minWidth: 50.0,
                minHeight: 43.0,
                cornerRadius: 10.0,
                initialLabelIndex: _themeIndex,
                activeBgColors: const [
                  [Color.fromARGB(187, 255, 255, 255)],
                  [Color.fromARGB(187, 255, 255, 255)],
                ],
                activeFgColor: Colors.black,
                inactiveBgColor: const Color.fromARGB(255, 53, 50, 47),
                inactiveFgColor: Colors.grey,
                totalSwitches: 2,
                icons: const [Icons.dark_mode, Icons.light_mode],
                radiusStyle: true,
                onToggle: (index) async {
                  if (index != null) {
                    final theme = index == 0 ? 'dark' : 'light';
                    await ref.read(userRepositoryProvider).updatePreferences({
                      'theme': theme,
                    });
                    setState(() => _themeIndex = index);
                  }
                },
              ),
            ),
            ListTile(
              leading: const Icon(
                Icons.notifications,
                color: Color.fromARGB(255, 199, 162, 102),
              ),
              title: const Text(
                'Notification',
                style: TextStyle(color: Colors.white70),
              ),
              trailing: Switch(
                value: _notificationsEnabled,
                activeColor: const Color.fromARGB(255, 236, 196, 133),
                onChanged: (val) async {
                  await ref.read(userRepositoryProvider).updatePreferences({
                    'notifications': val,
                  });
                  setState(() => _notificationsEnabled = val);
                },
              ),
            ),
            ListTile(
              leading: const Icon(
                Icons.password,
                color: Color.fromARGB(255, 199, 162, 102),
              ),
              title: const Text(
                'Change Password',
                style: TextStyle(color: Colors.white70),
              ),
              trailing: const Icon(
                Icons.chevron_right_outlined,
                color: Color.fromARGB(255, 236, 196, 133),
                size: 24,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const UpdatePasswordPage()),
                );
              },
            ),
            const SizedBox(height: 25),
            const Divider(thickness: 0.1),
            const ListTile(
              leading: Icon(
                Icons.share,
                color: Color.fromARGB(255, 199, 162, 102),
              ),
              title: Text('Share', style: TextStyle(color: Colors.white70)),
              trailing: Icon(
                Icons.chevron_right_outlined,
                color: Color.fromARGB(255, 236, 196, 133),
                size: 24,
              ),
            ),
            const ListTile(
              leading: Icon(
                Icons.star,
                color: Color.fromARGB(255, 199, 162, 102),
              ),
              title: Text('RateUs', style: TextStyle(color: Colors.white70)),
              trailing: Icon(
                Icons.chevron_right_outlined,
                color: Color.fromARGB(255, 236, 196, 133),
                size: 24,
              ),
            ),
            const ListTile(
              leading: Icon(
                Icons.person,
                color: Color.fromARGB(255, 199, 162, 102),
              ),
              title: Text('AboutUs', style: TextStyle(color: Colors.white70)),
              trailing: Icon(
                Icons.chevron_right_outlined,
                color: Color.fromARGB(255, 236, 196, 133),
                size: 24,
              ),
            ),
            const SizedBox(height: 25),
            const SizedBox(
              width: double.infinity,
              child: Padding(
                padding: EdgeInsets.only(left: 25.0),
                child: Text(
                  'PRIVACY SETTINGS',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color.fromARGB(240, 224, 220, 220),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 4),
            const Divider(thickness: 0.1),
            const SizedBox(height: 8),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                children: [
                  Text('Terms of use', style: TextStyle(color: Colors.white)),
                  Spacer(),
                  Icon(
                    Icons.chevron_right_outlined,
                    size: 24,
                    color: Color.fromARGB(255, 236, 196, 133),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                children: [
                  Text('Privacy policy', style: TextStyle(color: Colors.white)),
                  Spacer(),
                  Icon(
                    Icons.chevron_right_outlined,
                    size: 24,
                    color: Color.fromARGB(255, 236, 196, 133),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: GestureDetector(
                onTap: _handleDeleteAccount,
                child: const Row(
                  children: [
                    Text(
                      'DELETE MY ACCOUNT',
                      style: TextStyle(color: Color.fromARGB(255, 222, 38, 38)),
                    ),
                    Spacer(),
                    Icon(
                      Icons.chevron_right_outlined,
                      size: 24,
                      color: Color.fromARGB(255, 236, 196, 133),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
