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

class MesobAPP extends StatelessWidget {
  const MesobAPP({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mesob foods',
      theme: ThemeData(fontFamily: 'Poppins'),
      debugShowCheckedModeBanner: false,
      // show video splash first, then Login
      home: const VideoSplashPage(),
      routes: {
        '/search_page': (context) => const SearchPage(),
        '/cart_page': (context) => const CartPage(),
        '/settings_page': (context) => const AppSettings(),
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

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/splash/splash_video.mp4')
      ..initialize().then((_) {
        // start playback when ready
        _controller.play();
        _controller.setVolume(0.0);
        // ensure video plays once
        _controller.setLooping(false);
        setState(() {});
      });

    // Listener to detect end of video and navigate once
    _controller.addListener(() {
      if (!_controller.value.isInitialized || _navigated) return;
      final position = _controller.value.position;
      final duration = _controller.value.duration;
      if (position >= duration - const Duration(milliseconds: 100)) {
        _navigated = true;
        // small delay to ensure last frame rendered
        Timer(const Duration(milliseconds: 50), () {
          if (!mounted) return;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const Login()),
          );
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.removeListener(() {});
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _controller.value.isInitialized
          ? SizedBox.expand(
              child: FittedBox(
                fit: BoxFit.cover,
                clipBehavior: Clip.hardEdge,
                child: SizedBox(
                  width: _controller.value.size.width,
                  height: _controller.value.size.height,
                  child: VideoPlayer(_controller),
                ),
              ),
            )
          : Container(color: Colors.black),
    );
  }
}
