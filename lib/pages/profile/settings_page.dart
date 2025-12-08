import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:dine_ease/pages/profile/update_password.dart';

class AppSettings extends StatefulWidget {
  const AppSettings({super.key});

  @override
  State<AppSettings> createState() => _AppSettingsState();
}

class _AppSettingsState extends State<AppSettings> {
  @override
  Widget build(BuildContext context) {
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
            const Text(
              'Mesob Orders and Delivery',
              style: TextStyle(
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
                    //TODO  Link the website
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
                'Light Mode',
                style: TextStyle(color: Color.fromARGB(217, 255, 255, 255)),
              ),
              trailing: ToggleSwitch(
                animate: true,
                animationDuration: 150,
                minWidth: 50.0,
                minHeight: 43.0,
                cornerRadius: 10.0,
                activeBgColors: const [
                  [Color.fromARGB(187, 255, 255, 255)],
                  [Color.fromARGB(187, 255, 255, 255)],
                ],
                // activeFgColor: const Color.fromARGB(198, 255, 109, 64),
                activeFgColor: Colors.black,
                inactiveBgColor: const Color.fromARGB(255, 53, 50, 47),
                inactiveFgColor: Colors.grey,
                // initialLabelIndex: 1,
                totalSwitches: 2,
                icons: const [Icons.dark_mode, Icons.light_mode],
                radiusStyle: true,
                onToggle: (index) {
                  print('switched to: $index');

                  //Todo change the theme of the app
                },
              ),
            ),
            // const SizedBox(height: 8),
            const ListTile(
              leading: Icon(
                Icons.notifications,
                color: Color.fromARGB(255, 199, 162, 102),
              ),
              title: Text(
                'Notification',
                style: TextStyle(color: Colors.white70),
              ),
              trailing: Icon(
                Icons.chevron_right_outlined,
                color: Color.fromARGB(255, 236, 196, 133),
                size: 24,
              ),
            ),
            // const SizedBox(height: 8),
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
                  // textAlign: TextAlign.left,
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
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
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
          ],
        ),
      ),
    );
  }
}
