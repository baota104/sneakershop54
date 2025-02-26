import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:sneaker_shop/Presentation/Features/Login/LoginScreen.dart';
import 'package:sneaker_shop/Presentation/Features/Login/bloc/login_cubit.dart';
import 'package:sneaker_shop/Presentation/Features/Onboarding/Onboardingchildpage.dart';
import 'package:sneaker_shop/Presentation/Features/Onboarding/Onboardingpageview.dart';
import 'package:sneaker_shop/Presentation/Features/Register/RegisterScreen.dart';
import 'package:sneaker_shop/Presentation/Features/splash/SplashScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sneaker_shop/domains/authentication_repository/authentication_repository.dart';
import 'package:sneaker_shop/domains/data_source/firebase_auth_service.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const App());
}
class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final AuthenticationRepository _authenticationRepository;
  late final FirebaseAuthService _firebaseAuthService;

  @override
  void initState() {
    super.initState();
    _firebaseAuthService = FirebaseAuthService();
    _authenticationRepository = AuthenticationRepositoryImpl(firebaseAuthService: _firebaseAuthService);
  }
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context)=>_authenticationRepository ),
        BlocProvider(create: (_)=> LoginCubit(authenticationRepository: _authenticationRepository),
        ),
      ],
        child: const MyApp());
  }
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return BlocProvider.value(
      value: BlocProvider.of<LoginCubit>(context), // ✅ Đảm bảo có LoginCubit trong cây widget
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        routes: {
          "/splash": (context) => SplashScreen(),
          "/home": (context) => OnboardingPageView(),
        },
        initialRoute: "/splash",
      ),
    );
  }
}


