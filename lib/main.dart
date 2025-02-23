import 'package:flutter/material.dart';
import 'package:sneaker_shop/Presentation/Features/Login/LoginScreen.dart';
import 'package:sneaker_shop/Presentation/Features/Onboarding/Onboardingchildpage.dart';
import 'package:sneaker_shop/Presentation/Features/Onboarding/Onboardingpageview.dart';
import 'package:sneaker_shop/Presentation/Features/Register/RegisterScreen.dart';
import 'package:sneaker_shop/Presentation/Features/splash/SplashScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // routes: {
      //   "/splash":(context)=>SplashScreen(),
      //   "/home":(context)=>OnboardingPageView()
      // },
      // initialRoute: "/splash",
      home: OnboardingPageView(),
    );
  }
}


