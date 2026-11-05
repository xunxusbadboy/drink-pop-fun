import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
void main() { WidgetsFlutterBinding.ensureInitialized(); runApp(const DrinkApp()); }
class DrinkApp extends StatelessWidget {
  const DrinkApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'วันนี้ดื่มไรดี?', debugShowCheckedModeBanner: false,
    theme: ThemeData(useMaterial3:true, scaffoldBackgroundColor: const Color(0xFFFFFAF1), colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFFF337A)), fontFamily: null),
    home: const HomeScreen(),
  );
}
