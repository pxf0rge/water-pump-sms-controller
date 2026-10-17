import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sms_app/home_page.dart';
import 'package:sms_app/theme/app_theme.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: AppColors.background,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const HomePage(),
      title: 'GSM Controller',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
    );
  }
}
