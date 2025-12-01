import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dine_ease/pages/signup.dart';
import 'package:dine_ease/widgets/bottom_navigation.dart';
import 'package:dine_ease/pages/forgot_password.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show Colors;
import 'package:dine_ease/providers/auth/auth_controller.dart'; // for state type (optional)
import 'package:dine_ease/providers/auth/auth_repository.dart'; // not used directly, kept if needed
import 'package:dine_ease/providers/auth/auth_controller.dart' as ac;
import 'package:dine_ease/providers/auth/auth_controller.dart'
    show authControllerProvider;

class Login extends ConsumerStatefulWidget {
  const Login({super.key});

  @override
  ConsumerState<Login> createState() => _LoginState();
}

class _LoginState extends ConsumerState<Login> {
  bool? isChecked = false;
  bool isHidden = true;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final rawEmail = emailController.text;
    final password = passwordController.text;

    String sanitizeEmail(String e) {
      var s = e.replaceAll(RegExp(r'[\u200B\u200C\u200D\uFEFF\u2060]'), '');
      s = s.replaceAll(RegExp(r'[\x00-\x1F\x7F]'), '');
      return s.trim();
    }

    final email = sanitizeEmail(rawEmail).toLowerCase();

    if (email.isEmpty || password.isEmpty) {
      Fluttertoast.showToast(
        msg: 'Please enter email and password',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        backgroundColor: const Color(0x00f7b43f),
        textColor: Colors.white,
      );
      return;
    }

    if (email != rawEmail) {
      Fluttertoast.showToast(
        msg: 'Using sanitized email: $email',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        backgroundColor: const Color(0x00f7b43f),
        textColor: Colors.white,
      );
    }

    // New: client-side email format validation (same regex)
    bool isValidEmail(String e) {
      final emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
      return emailRegex.hasMatch(e);
    }

    if (!isValidEmail(email)) {
      if (kDebugMode)
        debugPrint(
          'Login: client-side validation failed: invalid email "$email"',
        );
      Fluttertoast.showToast(
        msg: 'Please enter a valid email address',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        backgroundColor: const Color(0x00f7b43f),
        textColor: Colors.white,
      );
      return;
    }

    // call controller
    final controller = ref.read(authControllerProvider.notifier);
    await controller.login(email, password);

    final state = ref.read(authControllerProvider);
    if (state.error == null) {
      // success
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const BottomNavigation()),
      );
    } else {
      // log and show user-friendly + full error dialog (log only in debug)
      if (kDebugMode) debugPrint('Login failed: ${state.error}');
      final errorText = state.error?.toString() ?? 'Login failed';

      if (!mounted) return;

      Fluttertoast.showToast(
        msg: errorText,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red.shade700,
        textColor: Colors.white,
      );

      // Detailed error now shown via toast. For longer/interactable errors,
      // consider using another_flushbar or a full-screen error page.
    }
  }

  @override
  Widget build(BuildContext context) {
    final loading = ref.watch(authControllerProvider).loading;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Column(
          children: [
            Image.asset('assets/images/shapes/shape7.png'),
            const Spacer(),
            Center(
              child: Column(
                children: [
                  const Text(
                    'Welcome Back',
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
                      controller: emailController,
                      decoration: const InputDecoration(
                        hintText: 'email address',
                        hintStyle: TextStyle(color: Colors.black26),
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
                      controller: passwordController,
                      obscureText: isHidden,
                      obscuringCharacter: '*',
                      decoration: InputDecoration(
                        hintText: 'password',
                        hintStyle: const TextStyle(color: Colors.black26),
                        prefixIcon: const SizedBox(
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
                        suffixIcon: SizedBox(
                          height: 10,
                          width: 10,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  isHidden = !isHidden;
                                });
                              },
                              child: Icon(
                                (!isHidden)
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: const Color.fromARGB(193, 0, 0, 0),
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Padding(
                    padding: const EdgeInsets.only(right: 32.0),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ForgotPasswordPage(),
                            ),
                          );
                        },
                        child: const Text(
                          'Forgot Password',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: [
                        Checkbox(
                          checkColor: Colors.white,
                          activeColor: Colors.orange,
                          side: const BorderSide(
                            width: 1,
                            color: Colors.orange,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          value: isChecked,
                          onChanged: (value) {
                            setState(() {
                              isChecked = value;
                            });
                          },
                        ),
                        const Text(
                          'Remember me',
                          style: TextStyle(
                            color: Colors.orange,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
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
                              'SignIn',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1.2,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 32.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Divider(thickness: 0, color: Colors.black),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text('Or continue with'),
                        ),
                        Expanded(
                          child: Divider(thickness: 0, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          final controller = ref.read(
                            authControllerProvider.notifier,
                          );
                          // Provide the iOS client id you gave
                          await controller.googleSignIn(
                            webClientId:
                                '27541323707-1h0028ed8clturai8ql1jcvdldti8tod.apps.googleusercontent.com',
                            iosClientId:
                                '27541323707-fi8lsf9djjki4cqcgfpg2tfe2tr6qem0.apps.googleusercontent.com',
                          );
                          final state = ref.read(authControllerProvider);
                          if (state.error != null) {
                            Fluttertoast.showToast(
                              msg: state.error!,
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.BOTTOM,
                              backgroundColor: Colors.red.shade700,
                              textColor: Colors.white,
                            );
                          } else {
                            // success -> navigate
                            if (!mounted) return;
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const BottomNavigation(),
                              ),
                            );
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(35, 187, 172, 166),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Image.asset(
                            'assets/images/signIn-brands/google.png',
                            width: 30,
                            height: 30,
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(35, 187, 172, 166),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Image.asset(
                          'assets/images/signIn-brands/apple.png',
                          width: 30,
                          height: 30,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  RichText(
                    text: TextSpan(
                      text: 'Not a member? ',
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 14,
                      ),
                      children: [
                        TextSpan(
                          text: 'Register now',
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
                                  builder: (context) => const SignUp(),
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
      ),
    );
  }
}
