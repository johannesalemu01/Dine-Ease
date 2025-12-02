import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:dine_ease/pages/login.dart';

class NewPasswordPage extends StatefulWidget {
  const NewPasswordPage({super.key});

  @override
  State<NewPasswordPage> createState() => _NewPasswordPageState();
}

class _NewPasswordPageState extends State<NewPasswordPage> {
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirm = TextEditingController();
  bool _loading = false;

  Future<void> _submit() async {
    final pass = _password.text.trim();
    final conf = _confirm.text.trim();
    if (pass.isEmpty || conf.isEmpty) {
      Fluttertoast.showToast(
        msg: 'Please fill both fields',
        backgroundColor: Colors.black87,
        textColor: Colors.white,
      );
      return;
    }
    if (pass.length < 6) {
      Fluttertoast.showToast(
        msg: 'Password must be >= 6 chars',
        backgroundColor: Colors.black87,
        textColor: Colors.white,
      );
      return;
    }
    if (pass != conf) {
      Fluttertoast.showToast(
        msg: 'Passwords do not match',
        backgroundColor: Colors.black87,
        textColor: Colors.white,
      );
      return;
    }

    setState(() => _loading = true);
    try {
      // Use Supabase auth updateUser to set the new password.
      final res = await Supabase.instance.client.auth.updateUser(
        UserAttributes(password: pass),
      );

      // Inspect response for errors
      try {
        final dyn = res as dynamic;
        final error = dyn.error ?? dyn['error'];
        if (error != null) {
          final msg = error.message ?? error.toString();
          Fluttertoast.showToast(
            msg: msg,
            backgroundColor: Colors.red.shade700,
            textColor: Colors.white,
          );
          return;
        }
      } catch (_) {}

      // success
      Fluttertoast.showToast(
        msg: 'Password updated. Please sign in.',
        backgroundColor: Colors.green.shade700,
        textColor: Colors.white,
      );
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const Login()),
        (r) => false,
      );
    } catch (e, st) {
      if (kDebugMode) debugPrint('NewPassword error: $e\n$st');
      Fluttertoast.showToast(
        msg: e.toString(),
        backgroundColor: Colors.red.shade700,
        textColor: Colors.white,
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Set new password'),
        backgroundColor: const Color(0xff162236),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(height: 12),
            TextField(
              controller: _password,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'New password'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _confirm,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Confirm password'),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _loading ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xfff7B43f),
                ),
                child: _loading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(color: Colors.black),
                      )
                    : const Text(
                        'Update password',
                        style: TextStyle(color: Colors.black),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
