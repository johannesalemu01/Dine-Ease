import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dine_ease/providers/user/user_repository.dart';

class ReferFriend extends ConsumerStatefulWidget {
  const ReferFriend({super.key});

  @override
  ConsumerState<ReferFriend> createState() => _ReferFriendState();
}

class _ReferFriendState extends ConsumerState<ReferFriend> {
  final TextEditingController _controller = TextEditingController();
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadReferralCode();
  }

  Future<void> _loadReferralCode() async {
    final userRepo = ref.read(userRepositoryProvider);
    final profile = await userRepo.getProfile();
    if (profile != null) {
      setState(() {
        _controller.text = (profile['referralCode'] ?? 'DINEEASE').toString().toUpperCase();
        _loading = false;
      });
    } else {
      setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                margin: const EdgeInsets.only(left: 30, top: 50),
                child: const Icon(Icons.arrow_back, color: Colors.white),
              ),
            ),
            const SizedBox(height: 30),
            Image.asset(
              'assets/images/illustrations/refer_friends3.jpeg',
              height: 350,
              width: double.infinity,
              fit: BoxFit.contain,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10),
              child: Column(
                children: [
                  const Text(
                    textAlign: TextAlign.center,
                    'Share your code with a friend and claim 500 points as a reward 🔥🔥',
                    style: TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    style: const TextStyle(color: Colors.white),
                    controller: _controller,
                    readOnly: true,
                    showCursor: false,
                    decoration: InputDecoration(
                      labelStyle: const TextStyle(color: Colors.white60),
                      labelText: 'Your code',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      floatingLabelStyle: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Color.fromARGB(255, 29, 144, 94),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 0.5),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromARGB(255, 29, 144, 94),
                          width: 1.5,
                        ),
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: _controller.text))
                              .then((_) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Text copied to clipboard!')),
                            );
                          });
                        },
                        icon: const Icon(Icons.copy_all),
                        color: const Color.fromARGB(255, 29, 144, 94),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    textAlign: TextAlign.center,
                    'Your friend will earn 500 points as a reward when they use your code for their first booking.',
                    style: TextStyle(color: Color.fromARGB(224, 255, 255, 255)),
                  ),
                  const SizedBox(height: 35),
                  Container(
                    height: 45,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7),
                      color: const Color.fromARGB(255, 42, 158, 144),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.share, color: Colors.white, size: 20),
                        SizedBox(width: 5),
                        Text(
                          'SHARE CODE',
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
