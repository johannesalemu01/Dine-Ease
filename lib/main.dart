import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:dine_ease/models/favourite_restaurant.dart';
import 'package:dine_ease/pages/cart_page.dart';
import 'package:dine_ease/pages/login.dart';
import 'package:dine_ease/pages/profile/settings_page.dart';
import 'package:dine_ease/pages/search_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:video_player/video_player.dart';
import 'dart:async';
import 'package:dine_ease/pages/new_password.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Try to load .env if present; don't crash if it isn't.
  try {
    await dotenv.load(fileName: '.env');
  } catch (e) {
    debugPrint(
      'No .env file found — continuing without it. (${e.runtimeType})',
    );
  }

  // Safely read values — dotenv.env may throw if dotenv wasn't initialized.
  String supabaseUrl = 'https://kzffxvaamdnagsfyxevz.supabase.co';
  String supabaseAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imt6ZmZ4dmFhbWRuYWdzZnl4ZXZ6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjI0MTY5MTUsImV4cCI6MjA3Nzk5MjkxNX0.fITfAmkwjRrPvOtuJ1245ExGAPR-mOkAfGuEu_UiJJ4';
  try {
    supabaseUrl =
        dotenv.env['SUPABASE_URL'] ??
        'https://kzffxvaamdnagsfyxevz.supabase.co';
    supabaseAnonKey =
        dotenv.env['SUPABASE_ANON_KEY'] ??
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imt6ZmZ4dmFhbWRuYWdzZnl4ZXZ6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjI0MTY5MTUsImV4cCI6MjA3Nzk5MjkxNX0.fITfAmkwjRrPvOtuJ1245ExGAPR-mOkAfGuEu_UiJJ4';
  } catch (e) {
    debugPrint(
      'dotenv not initialized, using empty supabase keys: ${e.runtimeType}',
    );
  }

  await Hive.initFlutter();

  // Initialize Supabase only when keys are provided.
  if (supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty) {
    await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);
  } else {
    debugPrint('Supabase keys missing — skipping Supabase.initialize().');
  }

  Hive.registerAdapter(FavouriteRestaurantAdapter());
  await Hive.openBox<FavouriteRestaurant>('favList');

  runApp(const ProviderScope(child: MesobAPP()));
}

// Use a getter so callers access the client after possible initialization.
SupabaseClient get supabaseClient => Supabase.instance.client;

// navigator key so we can push from auth listener
final GlobalKey<NavigatorState> appNavigatorKey = GlobalKey<NavigatorState>();

class MesobAPP extends ConsumerStatefulWidget {
  const MesobAPP({super.key});

  @override
  ConsumerState<MesobAPP> createState() => _MesobAPPState();
}

class _MesobAPPState extends ConsumerState<MesobAPP> {
  StreamSubscription<AuthState>? _authSub;

  @override
  void initState() {
    super.initState();
    // Listen to Supabase auth state changes
    _authSub = Supabase.instance.client.auth.onAuthStateChange.listen((event) {
      final authEvent = event.event;
      if (authEvent == AuthChangeEvent.passwordRecovery) {
        // Navigate to new-password route
        appNavigatorKey.currentState?.pushReplacementNamed('/new-password');
      }
    });
  }

  @override
  void dispose() {
    _authSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: appNavigatorKey,
      title: 'Mesob foods',
      theme: ThemeData(fontFamily: 'Poppins'),
      debugShowCheckedModeBanner: false,
      // show video splash first, then Login
      home: const VideoSplashPage(),
      routes: {
        '/search_page': (context) => const SearchPage(),
        '/cart_page': (context) => const CartPage(),
        '/settings_page': (context) => const AppSettings(),
        '/new-password': (context) => const NewPasswordPage(),
      },
    );
  }
}

// --- Video splash page (plays asset then navigates to Login) ---
class VideoSplashPage extends StatefulWidget {
  const VideoSplashPage({super.key});

  @override
  State<VideoSplashPage> createState() => _VideoSplashPageState();
}

class _VideoSplashPageState extends State<VideoSplashPage> {
  late VideoPlayerController _controller;
  bool _navigated = false;
  bool _videoInitialized = false;
  VoidCallback? _listener;
  Timer? _initTimeout;
  static const kSplashOrange = Color(0xfff7B43f);

  @override
  void initState() {
    super.initState();

    // Start a short timeout so we don't get stuck on the splash/logo.
    _initTimeout = Timer(const Duration(seconds: 3), () {
      if (!_videoInitialized && !_navigated) {
        _navigateToLogin();
      }
    });

    _controller = VideoPlayerController.asset('assets/splash/splash_video.mp4');

    // Initialize, start playback and set up listener.
    _controller
        .initialize()
        .then((_) async {
          // mark initialized and start playing
          if (mounted) {
            setState(() {
              _videoInitialized = true;
            });
          }
          try {
            await _controller.setLooping(false);
            await _controller.setVolume(0.0); // keep muted if desired
            await _controller.play();
          } catch (_) {
            // ignore play errors here; the timeout/fallback will handle it
          }
        })
        .catchError((err, st) {
          // initialization failed -> fallback

          if (!_navigated) _navigateToLogin();
        });

    // listener to detect end of video (use stored callback to remove later)
    _listener = () {
      if (!_controller.value.isInitialized || _navigated) return;
      final duration = _controller.value.duration;
      final position = _controller.value.position;
      if (duration.inMilliseconds > 0 &&
          position >= duration - const Duration(milliseconds: 150)) {
        _navigated = true;
        // small delay to render last frame then navigate
        Future.delayed(const Duration(milliseconds: 50), () {
          if (!mounted) return;
          _navigateToLogin();
        });
      }
    };
    _controller.addListener(_listener!);
  }

  void _navigateToLogin() {
    if (!mounted) return;
    // cancel timeout and remove listener before navigating
    _initTimeout?.cancel();
    try {
      if (_listener != null) _controller.removeListener(_listener!);
    } catch (_) {}
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const Login()),
    );
  }

  @override
  void dispose() {
    _initTimeout?.cancel();
    if (_listener != null) {
      try {
        _controller.removeListener(_listener!);
      } catch (_) {}
    }
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Keep same background as native splash (orange) and show branding while
    // the video initializes to avoid any black flash between splash -> video.
    return Scaffold(
      backgroundColor: kSplashOrange,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Full-screen branding background (covers entire screen, not centered)
          Positioned.fill(
            child: Image.asset(
              'assets/splash/logo.png',
              fit: BoxFit.cover, // use cover so no black bars show
            ),
          ),

          // Video layer: fade in once initialized to smoothly replace the branding
          if (_controller.value.isInitialized)
            AnimatedOpacity(
              opacity: _videoInitialized ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOut,
              child: FittedBox(
                fit: BoxFit.cover,
                clipBehavior: Clip.hardEdge,
                child: SizedBox(
                  width: _controller.value.size.width,
                  height: _controller.value.size.height,
                  child: VideoPlayer(_controller),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
