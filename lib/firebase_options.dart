import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'
    show Firebase, FirebaseOptions;
import 'package:firebase_auth/firebase_auth.dart';
import 'core/theme.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';
import 'screens/add_car_screen.dart';
import 'screens/car_detail_screen.dart';
import 'screens/feed_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/edit_car_screen.dart';
import 'models/car.dart';

@pragma('vm:entry-point')
Future<void> firebaseInit() async {
  try {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyD3VCnXn_mFPzLin02AdIBarQYB7djKcEM",
        authDomain: "appflutter-cfab6.firebaseapp.com",
        projectId: "appflutter-cfab6",
        storageBucket: "appflutter-cfab6.firebasestorage.app",
        messagingSenderId: "549758506831",
        appId: "1:549758506831:web:0a1b2c3d4e5f6g7h8i9j0",
      ),
    );
  } catch (e) {
    debugPrint('Firebase init error: $e');
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await firebaseInit();
  runApp(const CarDexApp());
}

class CarDexApp extends StatelessWidget {
  const CarDexApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CarDex',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(builder: (_) => const AuthWrapper());
          case '/login':
            return MaterialPageRoute(builder: (_) => const LoginScreen());
          case '/register':
            return MaterialPageRoute(builder: (_) => const RegisterScreen());
          case '/home':
            return MaterialPageRoute(builder: (_) => const MainScreen());
          case '/add-car':
            return MaterialPageRoute(builder: (_) => const AddCarScreen());
          case '/car-detail':
            final car = settings.arguments as Car;
            return MaterialPageRoute(builder: (_) => CarDetailScreen(car: car));
          case '/edit-car':
            final car = settings.arguments as Car;
            return MaterialPageRoute(builder: (_) => EditCarScreen(car: car));
          case '/feed':
            return MaterialPageRoute(builder: (_) => const FeedScreen());
          case '/profile':
            return MaterialPageRoute(builder: (_) => const ProfileScreen());
          default:
            return MaterialPageRoute(builder: (_) => const AuthWrapper());
        }
      },
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasData) {
          return const MainScreen();
        }
        return const LoginScreen();
      },
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final _screens = const [HomeScreen(), FeedScreen(), ProfileScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) => setState(() => _currentIndex = index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.garage_outlined),
            selectedIcon: Icon(Icons.garage),
            label: 'Garagem',
          ),
          NavigationDestination(
            icon: Icon(Icons.explore_outlined),
            selectedIcon: Icon(Icons.explore),
            label: 'Explorar',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}
