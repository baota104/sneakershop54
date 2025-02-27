import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:sneaker_shop/Presentation/Features/Login/LoginScreen.dart';
import 'package:sneaker_shop/Presentation/Features/Login/bloc/login_cubit.dart';
import 'package:sneaker_shop/Presentation/Features/Onboarding/Onboardingchildpage.dart';
import 'package:sneaker_shop/Presentation/Features/Onboarding/Onboardingpageview.dart';
import 'package:sneaker_shop/Presentation/Features/Register/RegisterScreen.dart';
import 'package:sneaker_shop/Presentation/Features/main/MainScreen.dart';
import 'package:sneaker_shop/Presentation/Features/splash/SplashScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sneaker_shop/Presentation/Features/utils.enum/authentication_status.dart';
import 'package:sneaker_shop/app/app_cubit.dart';
import 'package:sneaker_shop/domains/authentication_repository/authentication_repository.dart';
import 'package:sneaker_shop/domains/data_source/firebase_auth_service.dart';
import 'Presentation/Features/Register/bloc/register_cubit.dart';
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
        RepositoryProvider(create: (context) => _authenticationRepository),
    ],
    child: MultiBlocProvider(
    providers: [
    BlocProvider(create: (_) => LoginCubit(authenticationRepository: _authenticationRepository)),
    BlocProvider(create: (_) => RegisterCubit(authenticationRepository: _authenticationRepository)), // ✅ Đóng ngoặc đúng
    BlocProvider(create: (_)=> AppCubit(authenticationRepository: _authenticationRepository))
    ],
        child: const MyApp()));
  }
}


class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
      final _navigatorKey = GlobalKey<NavigatorState>();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: BlocProvider.of<LoginCubit>(context)),  // ✅ Đảm bảo LoginCubit có trong cây widget
        BlocProvider.value(value: BlocProvider.of<RegisterCubit>(context)), // ✅ Thêm RegisterCubit
        BlocProvider.value(value: BlocProvider.of<AppCubit>(context))
      ],
      child: MaterialApp(
        navigatorKey: _navigatorKey,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        // routes: {
        //   "/splash": (context) => SplashScreen(),
        //   "/home": (context) => OnboardingPageView(),
        // },
        // initialRoute: "/splash",
        builder: (context,child){
            return BlocListener<AppCubit,AppState>(
              listener: (context,state){
                switch (state.status){
                  case AuthenticationStatus.authenticated:
                    _navigatorKey.currentState!.pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context)=> const Mainscreen()
                        ),
                        (route) => false,
                    );
                  case AuthenticationStatus.unauthenticated:
                    _navigatorKey.currentState!.pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (context)=> const Loginscreen(isFirstTimeInstallApp: true)
                      ),
                          (route) => false,
                    );
                  case AuthenticationStatus.unknow:
                    // k lam gi
                    break;
                }
              },
              child: child,
            );
        },
        onGenerateRoute: (_){
          return MaterialPageRoute(builder: (context)=> const SplashScreen());
        },
      ),
    );
  }
}


