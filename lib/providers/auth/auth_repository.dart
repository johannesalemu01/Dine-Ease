import 'package:dine_ease/providers/supabase_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart';

class AuthRepository {
  final Ref _ref;
  AuthRepository(this._ref);

  SupabaseClient get _supabase => _ref.read(supabaseProvider);

  //NOTE - SIGNUP

  Future<String?> signUp(String email, String password) async {
    try {
      await _supabase.auth.signUp(email: email, password: password);
      return null;
    } catch (e, st) {
      // print full error and stacktrace to device logs for debugging
      debugPrint('AuthRepository.signUp error: $e');
      debugPrint('AuthRepository.signUp stack:\n$st');

      // Try to extract a friendly message/code if available on the exception object.
      String message;
      try {
        final dyn = e as dynamic;
        final msg = dyn.message ?? dyn.error_description ?? dyn.toString();
        final code = dyn.code;

        // If server says the email is invalid, attempt a safe ASCII-only retry once.
        if (code == 'email_address_invalid') {
          // filter to printable ASCII (32..126) and common email characters
          String asciiFilter(String s) {
            final buf = StringBuffer();
            for (final r in s.runes) {
              if (r >= 32 && r <= 126) {
                buf.writeCharCode(r);
              }
            }
            return buf.toString();
          }

          final filtered = asciiFilter(email);
          if (filtered != email && filtered.isNotEmpty) {
            debugPrint(
              'AuthRepository: retrying signup with ascii-filtered email="$filtered"',
            );
            try {
              await _supabase.auth.signUp(email: filtered, password: password);
              // success on retry - return null and log original problem
              debugPrint(
                'AuthRepository: signup succeeded with filtered email.',
              );
              return null;
            } catch (e2, st2) {
              debugPrint('AuthRepository.signUp retry error: $e2');
              debugPrint('AuthRepository.signUp retry stack:\n$st2');
              // fall through to compose message including both server responses
              final dyn2 = e2 as dynamic;
              final msg2 =
                  dyn2.message ?? dyn2.error_description ?? dyn2.toString();
              message =
                  'Original: $msg (code: $code)\nRetry with filtered email: $msg2';
              // Append hints below
              message +=
                  '\n\nNote: a filtered retry was attempted. If this fails, check Supabase Auth settings (Allowed email domains / Disable signups) and verify the exact bytes sent (hidden control characters).';
              return message;
            }
          }
        }

        // Add targeted guidance for common server-side rejection
        if (code == 'email_address_invalid') {
          message = code != null ? '$msg (code: $code)' : '$msg';

          // Append diagnostic hints for the developer / user
          message +=
              '.Hint: Supabase rejected the email format';
        } else {
          message = code != null ? '$msg (code: $code)' : '$msg';
        }
      } catch (_) {
        message = e.toString();
      }

      print('🔥🔥😎🥸😎🔥$message');
      return message;
    }
  }

  //NOTE - LOGIN

  Future<String?> logIn(String email, String password) async {
    try {
      final res = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      // Try to detect an explicit error on the response (implementation varies with package versions).
      try {
        final dyn = res as dynamic;
        final respError = dyn.error ?? dyn['error'];
        if (respError != null) {
          final msg = respError.message ?? respError.toString();
          return msg ?? 'Invalid credentials';
        }
      } catch (_) {
        // ignore parsing errors
      }

      // If no explicit response error, check currentUser as a reliable indicator.
      final user = _supabase.auth.currentUser;
      if (user == null) {
        // no user -> login failed. Try to derive a helpful message from response.
        try {
          final dyn = res as dynamic;
          final msg = dyn.error?.message ?? dyn.toString();
          return (msg != null && msg.isNotEmpty) ? msg : 'Invalid credentials';
        } catch (_) {
          return 'Invalid credentials';
        }
      }

      // success
      return null;
    } catch (e, st) {
      // print full error and stacktrace to device logs for debugging (debug only)

      // Try to extract a friendly message/code if available on the exception object.
      String message;
      try {
        final dyn = e as dynamic;
        final msg = dyn.message ?? dyn.error_description ?? dyn.toString();
        final code = dyn.code;
        message = code != null ? '$msg (code: $code)' : '$msg';
      } catch (_) {
        message = e.toString();
      }

      return message;
    }
  }

  // Sign in with Google using google_sign_in to obtain idToken/accessToken,
  // then exchange with Supabase via signInWithIdToken.
  Future<String?> signInWithGoogle({
    String? webClientId,
    String? iosClientId,
  }) async {
    try {
      // Configure GoogleSignIn. On web pass webClientId; for iOS fallback to iosClientId if provided.
      final googleSignIn = GoogleSignIn(
        scopes: <String>['email', 'profile'],
        clientId: webClientId ?? iosClientId,
      );

      final account = await googleSignIn.signIn();
      if (account == null) {
        return 'Google sign-in cancelled';
      }

      final auth = await account.authentication;
      final idToken = auth.idToken;
      final accessToken = auth.accessToken;
      if (idToken == null) return 'No ID token returned by Google';

      // Exchange tokens with Supabase
      final res = await _supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );

      // Inspect response for errors (implementation may vary by package)
      try {
        final dyn = res as dynamic;
        final respError = dyn.error ?? dyn['error'];
        if (respError != null) {
          final msg = respError.message ?? respError.toString();
          return msg ?? 'Google sign-in failed';
        }
      } catch (_) {}

      // verify current user
      final user = _supabase.auth.currentUser;
      if (user == null) {
        return 'Google sign-in failed (no user)';
      }

      return null; // success
    } catch (e, st) {
      if (kDebugMode) {
        debugPrint('AuthRepository.signInWithGoogle error: $e');
        debugPrint('AuthRepository.signInWithGoogle stack:\n$st');
      }
      try {
        final dyn = e as dynamic;
        final msg = dyn.message ?? dyn.error_description ?? dyn.toString();
        return msg;
      } catch (_) {
        return e.toString();
      }
    }
  }

  //NOTE - LOGOUT

  Future<void> logOut() async {
    await _supabase.auth.signOut();
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(ref);
});
