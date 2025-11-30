import 'package:flutter/material.dart';
import 'package:dine_ease/pages/profile/loyality_points.dart';
import 'package:dine_ease/pages/profile/personal_info.dart';
import 'package:dine_ease/pages/profile/refer_friend.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    int rewardPoints = 0;
    return Scaffold(
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Container(
          width: double.infinity,
          height: height * 1.1,
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 15, 31, 48),
          ),
          child: Column(
            children: [
              const SizedBox(
                height: 60,
              ),
              SizedBox(
                height: height / 5,
                child: const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          // backgroundColor: Color.fromARGB(255, 255, 132, 0),
                          backgroundImage:
                              AssetImage('assets/images/mesob.png'),
                          radius: 45,
                          // child: Image.asset('assets/images/mesob.png'),
                          // child: Text(
                          //   'j',
                          //   style: TextStyle(
                          //       color: Colors.white,
                          //       fontWeight: FontWeight.w500,
                          //       fontSize: 42),
                          // ),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Yohannes Alemu',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            ),
                            Text(
                              'jo@gmail.com',
                              style: TextStyle(color: Colors.white54),
                            ),
                          ],
                        ),
                        Spacer(),
                        Icon(
                          Icons.edit_note,
                          color: Colors.white60,
                          size: 30,
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 11, 23, 36),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //activity
                      Container(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Rewards',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const LoyalityPoint()));
                              },
                              child: ProfileTile(
                                  rewardPoints: rewardPoints,
                                  labelText: 'Loyalty Point',
                                  icon: Icons.loyalty_rounded),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const ReferFriend()));
                              },
                              child: const ProfileTile(
                                  labelText: 'Refer a friend',
                                  icon: Icons.person_add_alt_1_outlined),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(16),
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Your Activity',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                            ProfileTile(
                                labelText: 'History', icon: Icons.history),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(16),
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'TheMosob Pay',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                            ProfileTile(
                                labelText: 'Payment', icon: Icons.payments),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'About You',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                            GestureDetector(
                              onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const PersonalInformation())),
                              child: const ProfileTile(
                                  labelText: 'personal details',
                                  icon: Icons.person_outline_outlined),
                            ),
                            const SizedBox(height: 5),
                            GestureDetector(
                              onTap: () => Navigator.pushNamed(
                                  context, '/settings_page'),
                              child: const ProfileTile(
                                  labelText: 'Settings', icon: Icons.settings),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(16),
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Help center',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                            ProfileTile(
                                labelText: 'Get support',
                                icon: Icons.help_outline),
                            SizedBox(height: 20),
                            SizedBox(
                              child: Text(
                                'Log out',
                                style: TextStyle(color: Colors.deepOrange),
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Align(
                              child: Text(
                                '1.0.00',
                                style: TextStyle(color: Colors.white54),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileTile extends StatelessWidget {
  const ProfileTile({
    super.key,
    this.rewardPoints,
    required this.labelText,
    required this.icon,
  });

  final int? rewardPoints;
  final String labelText;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 15,
        ),
        Row(
          children: [
            Icon(
              icon,
              size: 22,
              color: Colors.white70,
            ),
            const SizedBox(
              width: 12,
            ),
            Text(
              labelText,
              style: const TextStyle(color: Colors.white70, fontSize: 13),
            ),
            const Spacer(),
            if (rewardPoints != null)
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(222, 255, 86, 34),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Text(
                  '$rewardPoints points',
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            const Icon(
              Icons.chevron_right,
              color: Colors.white,
              size: 20,
            ),
          ],
        ),
      ],
    );
  }
}
