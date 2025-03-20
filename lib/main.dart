import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';
import 'package:rive/rive.dart';
import 'package:sigma_path/api/mock_api.dart';
import 'package:sigma_path/models/app_models.dart';
import 'package:sigma_path/screens/home_screen.dart';
import 'package:sigma_path/theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const SigmaPathApp());
}

class SigmaPathApp extends StatelessWidget {
  const SigmaPathApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => ChallengeProvider()),
        ChangeNotifierProvider(create: (_) => RoutineProvider()),
        ChangeNotifierProvider(create: (_) => FocusSessionProvider()),
      ],
      child: MaterialApp(
        title: 'SigmaPath',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        home: FutureBuilder(
          future: MockApi().initializeApp(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SplashScreen();
            }
            return const HomeScreen();
          },
        ),
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  RiveAnimationController? _riveController;
  bool _useRive = true;

  @override
  void initState() {
    super.initState();

    // Try to load Rive animation, if fails, fallback to Lottie
    _loadAnimations();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _animationController.forward();
  }

  Future<void> _loadAnimations() async {
    try {
      // Try to load Rive animation
      await rootBundle.load('assets/animations/sigma_loader.riv');
      setState(() {
        _useRive = true;
        _riveController = SimpleAnimation('Idle');
      });
    } catch (e) {
      // Fallback to Lottie if Rive fails
      setState(() {
        _useRive = false;
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkTheme.colorScheme.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_useRive)
              SizedBox(
                width: 200,
                height: 200,
                child: RiveAnimation.asset(
                  'assets/animations/sigma_loader.riv',
                  controllers: [_riveController!],
                  fit: BoxFit.contain,
                ),
              )
            else
              // Fallback to Lottie animation
              SizedBox(
                width: 200,
                height: 200,
                child: Lottie.asset(
                  'assets/animations/sigma_loader.json',
                  controller: _animationController,
                  repeat: true,
                ),
              ),
            const SizedBox(height: 30),
            // Animated text
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Opacity(
                  opacity: _animationController.value,
                  child: child,
                );
              },
              child: Text(
                'SIGMAPATH',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                  color: AppTheme.darkTheme.colorScheme.onBackground,
                ),
              ),
            ),
            const SizedBox(height: 10),
            // Slogan with animated fade-in
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Opacity(
                  opacity: _animationController.value *
                      0.7, // Slightly more transparent
                  child: child,
                );
              },
              child: Text(
                'BECOME EXCEPTIONAL',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1.5,
                  color: AppTheme.darkTheme.colorScheme.onBackground
                      .withOpacity(0.7),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
