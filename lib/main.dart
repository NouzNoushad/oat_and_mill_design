import 'package:flutter/material.dart';
import 'package:oat_and_mill_design/data/database.dart';
import 'package:oat_and_mill_design/screens/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MyDb myDb = MyDb();
  myDb.open();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: false,
      ),
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}
