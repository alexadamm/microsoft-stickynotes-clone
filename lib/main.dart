import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sticky_notes_clone/services/shared_services.dart';
import 'package:sticky_notes_clone/views/screens/home_page.dart';
import 'package:sticky_notes_clone/views/screens/login_page.dart';
import 'package:sticky_notes_clone/views/screens/register_page.dart';

Widget _defaultHome = const LoginPage();
void main() async {
  await dotenv.load(fileName: '.env');
  WidgetsFlutterBinding.ensureInitialized();

  bool _result = await SharedService.isLoggedIn();
  if (_result) {
    _defaultHome = const HomePage();
  }
  runApp(const ProviderScope(child: MyApp()));
}

final providerInitiaion = Provider<String>((_) => 'initialClass');

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, routes: {
      '/': (context) => _defaultHome,
      '/login': (context) => const LoginPage(),
      '/register': (context) => const RegisterPage(),
      '/home': (context) => const HomePage(),
    });
  }
}
