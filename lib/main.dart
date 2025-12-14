import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:todolist_app/cubit/auth_cubit.dart';
import 'package:todolist_app/cubit/prayer_cubit.dart';
import 'package:todolist_app/cubit/todo_cubit.dart';
import 'package:todolist_app/cubit/user_cubit.dart';
import 'package:todolist_app/screen/account/menu_account_page.dart';
import 'package:todolist_app/screen/account/profile_page.dart';
import 'package:todolist_app/screen/auth/forgot_password_page.dart';
import 'package:todolist_app/screen/auth/reset_new_password_page.dart';
import 'package:todolist_app/screen/auth/sign_in_page.dart';
import 'package:todolist_app/screen/auth/sign_up_page..dart';
import 'package:todolist_app/screen/landing_page.dart';
import 'package:todolist_app/screen/home_menu/calendar_holiday_page.dart';
import 'package:todolist_app/screen/home_menu/schedule_pray_page.dart';
import 'package:todolist_app/screen/home_menu/weather_page.dart';
import 'package:todolist_app/screen/launcher_page.dart';
import 'package:todolist_app/screen/todo_screen.dart';
import 'package:todolist_app/service/auth_service.dart';
import 'package:todolist_app/service/prayer_service.dart';
import 'package:todolist_app/service/todo_service.dart';
import 'package:todolist_app/service/user_service.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  // konfigurasi supabase
  final String supabaseUrl = dotenv.env["SUPABASE_URL"] ?? '';
  final String supabaseAnonKey = dotenv.env["ANON_KEY"] ?? '';

  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);

  final todoService = TodoService();
  final authService = AuthService();
  final prayerService = PrayerService();
  final userService = UserService();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<TodoCubit>(create: (_) => TodoCubit([], todoService)),
        BlocProvider<AuthCubit>(create: (_) => AuthCubit(authService)),
        BlocProvider<PrayerCubit>(create: (_) => PrayerCubit(prayerService)),
        BlocProvider<UserCubit>(create: (_) => UserCubit(userService)),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    DeepLinkHandler.init();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: "Test",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurpleAccent),
      ),
      home: LauncherPage(),
      // home: SignInPage(),
      routes: {
        '/signin': (context) => SignInPage(),
        '/signup': (context) => SignUpPage(),
        '/todo': (context) => TodoScreen(),
        '/forgot-password': (context) => ForgotPasswordPage(),
        '/reset-password': (context) => ResetNewPasswordPage(),
        '/bottom-page': (context) => BottomNavigationBarPage(),
        '/menu-account': (context) => MenuAccountPage(),
        '/schedule-pray': (context) => SchedulePrayPage(),
        '/calendar': (context) => CalendarHolidayPage(),
        '/profile': (context) => ProfilePage(),
        '/weather-page': (context) => WeatherPage(),
      },
    );
  }
}

class DeepLinkHandler {
  static final _appLinks = AppLinks();

  static Future<void> init() async {
    final initial = await _appLinks.getInitialAppLink();
    if (initial != null) _handle(initial);

    _appLinks.uriLinkStream.listen((uri) {
      _handle(uri);
    });
  }

  static void _handle(Uri uri) async {
    if (uri.scheme == "myapp" && uri.host == "reset-password") {
      String? token;

      // 1. Cek di query parameter
      if (uri.queryParameters.containsKey('access_token')) {
        token = uri.queryParameters['access_token'];
      }

      // 2. Jika tidak ada, cek fragment (#)
      if (token == null || token!.isEmpty) {
        final fragment =
            uri.fragment; // contoh: "access_token=xxx&type=recovery"

        final params = Uri.splitQueryString(fragment);
        token = params['access_token'];
      }

      if (token != null && token!.isNotEmpty) {
        await Supabase.instance.client.auth.exchangeCodeForSession(token!);
      }

      navigatorKey.currentState?.pushNamed("/reset-password");
    }
  }
}
