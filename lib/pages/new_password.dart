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
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;
  bool _obscurePass = true;
  bool _obscureConfirm = true;
  double _strength = 0.0;

  int _computeStrength(String p) {
    var score = 0;
    if (p.length >= 6) score++;
    if (p.length >= 10) score++;
    if (RegExp(r'[A-Z]').hasMatch(p)) score++;
    if (RegExp(r'[0-9]').hasMatch(p)) score++;
    if (RegExp(r'[^A-Za-z0-9]').hasMatch(p)) score++;
    return score; // 0..5
  }

  Color _strengthColor(double s) {
    if (s < 0.4) return Colors.redAccent;
    if (s < 0.7) return Colors.orangeAccent;
    return const Color.fromARGB(255, 29, 144, 94); // green
  }

  String _strengthLabel(double s) {
    if (s < 0.4) return 'Weak';
    if (s < 0.7) return 'Medium';
    return 'Strong';
  }

  void _onPasswordChanged(String v) {
    final score = _computeStrength(v);
    setState(() {
      _strength = (score / 5);
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final pass = _password.text.trim();

    setState(() => _loading = true);
    try {
      final res = await Supabase.instance.client.auth.updateUser(
        UserAttributes(password: pass),
      );

      // Inspect response for errors
      try {
        final dyn = res as dynamic;
        final error = dyn.error ?? dyn['error'];
        if (error != null) {
          final msg = error.message ?? error.toString();
          if (mounted) {
            Fluttertoast.showToast(
              msg: msg,
              gravity: ToastGravity.TOP,
              backgroundColor: Colors.red.shade700,
              textColor: Colors.white,
            );
          }
          return;
        }
      } catch (_) {}

      // polished success feedback
      if (mounted) {
        await showDialog(
          context: context,
          builder: (_) => AlertDialog(
            backgroundColor: const Color(0xff162236),
            title: const Text(
              'Password updated',
              style: TextStyle(color: Colors.white),
            ),
            content: const Text(
              'Your password has been updated. Please sign in again.',
              style: TextStyle(color: Colors.white70),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
        );

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const Login()),
          (r) => false,
        );
      }
    } catch (e, st) {
      if (kDebugMode) debugPrint('NewPassword error: $e\n$st');
      if (mounted) {
        Fluttertoast.showToast(
          msg: e.toString(),
          gravity: ToastGravity.TOP,
          backgroundColor: Colors.red.shade700,
          textColor: Colors.white,
        );
      }
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
    // Styled to match app's dark UI
    return Scaffold(
      backgroundColor: const Color(0xFF0E131E),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Set New Password',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: SizedBox.expand(
          child: Container(
            color: const Color(0xff162236),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  // keep min size behavior but allow the column to fill vertically
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 28),
                    const Text(
                      'Create a Strong Password',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Choose a password you can remember but is hard for others to guess.',
                      style: TextStyle(color: Colors.white70),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 48),
                    TextFormField(
                      controller: _password,
                      onChanged: _onPasswordChanged,
                      obscureText: _obscurePass,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFF0B1218),
                        hintText: 'New password',
                        hintStyle: const TextStyle(color: Colors.white38),
                        prefixIcon: const Icon(
                          Icons.lock,
                          color: Colors.white70,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePass
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: Colors.white70,
                          ),
                          onPressed: () =>
                              setState(() => _obscurePass = !_obscurePass),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty)
                          return 'Enter a new password';
                        if (v.length < 6)
                          return 'Password must be at least 6 characters';
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    // strength meter
                    Row(
                      children: [
                        Expanded(
                          child: LinearProgressIndicator(
                            value: _strength,
                            minHeight: 6,
                            color: _strengthColor(_strength),
                            backgroundColor: Colors.white10,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          _strengthLabel(_strength),
                          style: TextStyle(
                            color: _strengthColor(_strength),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),
                    TextFormField(
                      controller: _confirm,
                      obscureText: _obscureConfirm,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFF0B1218),
                        hintText: 'Confirm password',
                        hintStyle: const TextStyle(color: Colors.white38),
                        prefixIcon: const Icon(
                          Icons.check,
                          color: Colors.white70,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirm
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: Colors.white70,
                          ),
                          onPressed: () => setState(
                            () => _obscureConfirm = !_obscureConfirm,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty)
                          return 'Confirm your password';
                        if (v != _password.text)
                          return 'Passwords do not match';
                        return null;
                      },
                    ),
                    const SizedBox(height: 48),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _loading ? null : _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xfff7B43f),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: _loading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.black,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                'Update password',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        'Back to sign in',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
