import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projek_absen/service/pref_handler.dart';
import 'package:projek_absen/views/home_absen.dart';
import 'package:projek_absen/views/login_absen.dart';
import 'package:projek_absen/views/register_absen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final token = await PreferenceHandler.getToken();

  runApp(MyApp(initialRoute: token != null ? '/home' : '/login'));
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      // GANTI INI
      title: 'Absensi App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute: initialRoute,
      getPages: [
        GetPage(name: '/home', page: () => const HomeAbsen()),
        GetPage(name: '/login', page: () => const LoginScreen()),
        GetPage(name: '/register', page: () => const RegisterScreen()),
      ],
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:projek_absen/service/pref_handler.dart';
// import 'package:projek_absen/views/home_absen.dart';
// import 'package:projek_absen/views/login_absen.dart';
// import 'package:projek_absen/views/register_absen.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   final token = await PreferenceHandler.getToken();

//   runApp(MyApp(initialRoute: token != null ? '/home' : '/login'));
// }

// class MyApp extends StatelessWidget {
//   final String initialRoute;

//   const MyApp({super.key, required this.initialRoute});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Absensi App',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//       ),
//       initialRoute: initialRoute,
//       routes: {
//         '/login': (context) => const LoginScreen(),
//         '/register': (context) => const RegisterScreen(),
//         '/home': (context) => const HomeAbsen(),
//       },
//     );
//   }
// }
