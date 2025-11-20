import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'loginPage.dart';
import 'admin/AdminDashboardSalles.dart';
import 'admin/GetionSallesPage.dart';
import 'admin/UserManagementPage.dart';
import 'admin/RolePermissionsPage.dart';
import 'admin/EmploiTempsPage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const SalleManagerApp());
}

class SalleManagerApp extends StatelessWidget {
  const SalleManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestion des Salles',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),

      initialRoute: '/',
      routes: {
        '/': (context) => const LoginPage(), // page de login
        '/adminDashboard': (context) => const AdminDashboardSalles(),
        '/salles': (context) => const GestionSallesPage(),
        '/utilisateurs': (context) => const UserManagementPage(),
        '/permissions': (context) => const RolePermissionsPage(),
        '/emploiTemps': (context) => const EmploiTempsPage(),
      },
    );
  }
}
