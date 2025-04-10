import 'package:flutter/material.dart';
import 'screen/splash_screen.dart';
import 'screen/login_screen.dart';
import 'screen/signup_screen.dart';
import 'screen/role_selection_screen.dart';
import 'donor_dashboard.dart';
import 'ngo_dashboard.dart';
import 'needy_dashboard.dart';
import 'donation_form.dart';
import 'donation_detail_screen.dart';
import 'chat_screen.dart';
import 'profile_screen.dart';
import 'request_history_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FoodShare',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Roboto',
        appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.green,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.green),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/role_selection': (context) => const RoleSelectionScreen(),
        '/donor_dashboard': (context) => const DonorDashboard(),
        '/ngo_dashboard': (context) => const NGODashboard(),
        '/needy_dashboard': (context) => const NeedyDashboard(),
        '/donation_form': (context) => const DonationForm(),
        '/profile': (context) => ProfileScreen(),
        '/request_history': (context) => RequestHistoryScreen(),
        '/chat': (context) => ChatScreen(receiver: ModalRoute.of(context)!.settings.arguments as ChatUser),
        '/request_history': (context) => RequestHistoryScreen(),
        '/profile': (context) => ProfileScreen(),

      },
      onGenerateRoute: (settings) {
        if (settings.name == '/donation_detail') {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (context) => DonationDetailScreen(
              donation: args['donation'],
            ),
          );
        } else if (settings.name == '/chat') {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (context) => ChatScreen(
              receiver: args['receiver'],
            ),
          );
        }
        return null;
      },
    );
  }
}

// Example Usage:
// Navigate to ChatScreen with a receiver parameter
void navigateToChatScreen(BuildContext context, dynamic receiver) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ChatScreen(receiver: receiver),
    ),
  );
}
