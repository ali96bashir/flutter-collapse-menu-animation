import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'home/view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'STC',
        textSelectionTheme: const TextSelectionThemeData(),
        inputDecorationTheme: const InputDecorationTheme(
          labelStyle: TextStyle(
            color: Colors.grey,
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              style: BorderStyle.solid,
              color: Colors.grey,
            ),
          ),
        ),
      ),
      home: const HomePage(),
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child!,
        );
      },
    );
  }
}
