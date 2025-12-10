import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dine_ease/pages/login.dart';
import 'package:dine_ease/widgets/bottom_navigation.dart';
import 'package:dine_ease/providers/auth/auth_controller.dart'
    show authControllerProvider;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/foundation.dart';

class SignUp extends ConsumerStatefulWidget {
  const SignUp({super.key});

  @override
  ConsumerState<SignUp> createState() => _SignUpState();
}

class _SignUpState extends ConsumerState<SignUp> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final rawEmail = emailController.text;
    final password = passwordController.text;

    // Sanitize email: remove zero-width and control chars and trim
    String sanitizeEmail(String e) {
      var s = e.replaceAll(RegExp(r'[\u200B\u200C\u200D\uFEFF\u2060]'), '');
      s = s.replaceAll(RegExp(r'[\x00-\x1F\x7F]'), '');
      return s.trim();
    }

    // Helper: hex and percent-encoded diagnostics
    String toHex(List<int> bytes) =>
        bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join(' ');
    final rawBytes = rawEmail.codeUnits;
    final sanitizedRaw = sanitizeEmail(rawEmail);
    final sanitizedBytes = sanitizedRaw.codeUnits;
    final percentRaw = Uri.encodeComponent(rawEmail);
    final percentSan = Uri.encodeComponent(sanitizedRaw);

    debugPrint(
      'SignUp: raw email="$rawEmail" bytes=${rawBytes.length} hex=${toHex(rawBytes)} percent="$percentRaw"',
    );
    debugPrint(
      'SignUp: sanitized email="$sanitizedRaw" bytes=${sanitizedBytes.length} hex=${toHex(sanitizedBytes)} percent="$percentSan"',
    );

    final email = sanitizeEmail(rawEmail).toLowerCase();

    // Debug: show raw and sanitized bytes to catch hidden chars (only in debug)
    if (kDebugMode) {
      debugPrint('SignUp: raw email="$rawEmail" bytes=${rawEmail.codeUnits}');
      debugPrint('SignUp: sanitized email="$email" bytes=${email.codeUnits}');
    }

    if (email.isEmpty || password.isEmpty) {
      Fluttertoast.showToast(
        msg: 'Please enter email and password',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black87,
        textColor: Colors.white,
      );
      return;
    }

    if (email != rawEmail) {
      // Inform user we changed the input (short message)
      Fluttertoast.showToast(
        msg: 'Using sanitized email: $email',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black87,
        textColor: Colors.white,
      );
    }

    // New: client-side email format validation
    bool isValidEmail(String e) {
      final emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
      return emailRegex.hasMatch(e);
    }

    if (!isValidEmail(email)) {
      debugPrint(
        'SignUp: client-side validation failed: invalid email "$email"',
      );
      Fluttertoast.showToast(
        msg: 'Please enter a valid email address',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black87,
        textColor: Colors.white,
      );
      return;
    }

    final controller = ref.read(authControllerProvider.notifier);
    if (kDebugMode) debugPrint('SignUp: submitting for email=$email');

    await controller.signup(email, password);

    final state = ref.read(authControllerProvider);
    if (kDebugMode)
      debugPrint(
        'SignUp: state after signup -> loading=${state.loading} error=${state.error}',
      );

    if (state.error == null) {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const BottomNavigation()),
      );
    } else {
      // print error to console for easier debugging (only in debug)
      if (kDebugMode) debugPrint('SignUp failed: ${state.error}');
      final errorText = state.error?.toString() ?? 'Signup failed';
      if (!mounted) return;
      Fluttertoast.showToast(
        msg: errorText,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red.shade700,
        textColor: Colors.white,
      );
      // Note: detailed error shown via toast. If you need a tappable/expandable
      // UI for very long errors, consider another_flushbar or a dedicated page.
    }
  }

  @override
  Widget build(BuildContext context) {
    final loading = ref.watch(authControllerProvider).loading;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Stack(
            children: [
              Image.asset('assets/images/shapes/shape8.png'),
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.only(top: 48.0, right: 24),
                  child: InkWell(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const BottomNavigation(),
                      ),
                    ),
                    child: const Text(
                      'Skip',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          Center(
            child: Column(
              children: [
                const Text(
                  'Welcome ',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 32.0),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.black54),
                  ),
                  child: TextField(
                    controller: usernameController,
                    decoration: const InputDecoration(
                      hintText: 'username',
                      hintStyle: TextStyle(color: Colors.black26),
                      contentPadding: EdgeInsets.symmetric(vertical: 16),
                      prefixIcon: SizedBox(
                        height: 10,
                        width: 10,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Icon(
                            Icons.person_outline,
                            color: Color.fromARGB(205, 0, 0, 0),
                            size: 25,
                          ),
                        ),
                      ),
                      disabledBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 32.0),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1,
                      color: const Color.fromARGB(136, 0, 0, 0),
                    ),
                  ),
                  child: TextField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      hintText: 'email',
                      hintStyle: TextStyle(color: Colors.black26),
                       contentPadding: EdgeInsets.symmetric(vertical: 16),
                      prefixIcon: SizedBox(
                        height: 10,
                        width: 10,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Icon(
                            Icons.email_outlined,
                            color: Color.fromARGB(205, 0, 0, 0),
                            size: 25,
                          ),
                        ),
                      ),
                      disabledBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 32.0),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1,
                      color: const Color.fromARGB(136, 0, 0, 0),
                    ),
                  ),
                  child: TextField(
                    controller: phoneController,
                    decoration: const InputDecoration(
                      hintText: 'phone ',
                      hintStyle: TextStyle(color: Colors.black26),
                       contentPadding: EdgeInsets.symmetric(vertical: 16),
                      prefixIcon: SizedBox(
                        height: 10,
                        width: 10,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Icon(
                            Icons.phone_outlined,
                            color: Color.fromARGB(205, 0, 0, 0),
                            size: 25,
                          ),
                        ),
                      ),
                      disabledBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 32.0),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1,
                      color: const Color.fromARGB(136, 0, 0, 0),
                    ),
                  ),
                  child: TextField(
                    controller: passwordController,
                    decoration: const InputDecoration(
                      hintText: 'password',
                      hintStyle: TextStyle(color: Colors.black26),
                       contentPadding: EdgeInsets.symmetric(vertical: 16),
                      prefixIcon: SizedBox(
                        height: 10,
                        width: 10,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Icon(
                            Icons.lock_outline_rounded,
                            color: Color.fromARGB(205, 0, 0, 0),
                            size: 25,
                          ),
                        ),
                      ),
                      disabledBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  height: 50,
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 32),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: const Color(0xfff7B43f),
                    ),
                    onPressed: loading ? null : _submit,
                    child: loading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.black,
                            ),
                          )
                        : const Text(
                            'Create',
                            style: TextStyle(
                              color: Color.fromARGB(210, 0, 0, 0),
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.2,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 10),
                RichText(
                  text: TextSpan(
                    text: 'already have an account? ',
                    style: const TextStyle(color: Colors.black54, fontSize: 14),
                    children: [
                      TextSpan(
                        text: 'signIn',
                        style: const TextStyle(
                          color: Colors.orange,
                          letterSpacing: 1.2,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Login(),
                              ),
                            );
                          },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          Image.asset('assets/images/shapes/shape6.png'),
        ],
      ),
    );
  }
}
