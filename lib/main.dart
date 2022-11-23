import 'package:flutter/material.dart';
import 'package:blupit/screens/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Image Editor', 
      theme: ThemeData.light(),
      home: const HomeScreen(),
    );
  }
}
