import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:always/firebase_options.dart';
import 'package:always/auth_gate.dart';
import 'package:always/screens/sign_up.dart';
import 'package:always/screens/sign_in.dart';
import 'package:always/screens/home_screen.dart';
import 'package:always/screens/diary.dart';
import 'package:always/screens/remind.dart';
import 'package:always/screens/weather.dart';
import 'package:always/screens/write_screen.dart';
import 'package:always/screens/chat_screen.dart';
import 'package:always/screens/user_list.dart';
import 'package:always/screens/diary_detail_screen.dart';
import 'package:always/screens/add_reminder_screen.dart';
import 'package:always/screens/edit_reminder_screen.dart';
import 'package:always/screens/logout_screen.dart';
import 'package:always/screens/welcome_screen.dart';
import 'package:always/theme_provider.dart';
import 'package:always/screens/forgot_password_screen.dart';

void main() async {
  developer.log('Main function started', name: 'my_app.main');
  try {
    WidgetsFlutterBinding.ensureInitialized();
    developer.log('WidgetsFlutterBinding initialized', name: 'my_app.main');

    developer.log('Initializing Firebase...', name: 'my_app.main');
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    developer.log('Firebase initialized successfully', name: 'my_app.main');

    developer.log('Running app...', name: 'my_app.main');
    runApp(
      ChangeNotifierProvider(
        create: (context) => ThemeProvider(),
        child: const MyApp(),
      ),
    );
  } catch (e, s) {
    developer.log(
      'Error in main function',
      name: 'my_app.main',
      error: e,
      stackTrace: s,
    );
  }
}

final GoRouter _router = GoRouter(
  initialLocation: '/',
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const AuthGate();
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'welcome',
          builder: (BuildContext context, GoRouterState state) {
            return const WelcomeScreen();
          },
        ),
        GoRoute(
          path: 'signin',
          builder: (BuildContext context, GoRouterState state) {
            return const SignInScreen();
          },
        ),
        GoRoute(
          path: 'signup',
          builder: (BuildContext context, GoRouterState state) {
            return const SignUpScreen();
          },
        ),
        GoRoute(
          path: 'forgot-password',
          builder: (BuildContext context, GoRouterState state) {
            return const ForgotPasswordScreen();
          },
        ),
        GoRoute(
          path: 'home',
          builder: (BuildContext context, GoRouterState state) {
            return const HomeScreen();
          },
        ),
        GoRoute(
            path: 'diary',
            builder: (BuildContext context, GoRouterState state) {
              return const DiaryScreen();
            },
            routes: [
              GoRoute(
                path: ':noteId',
                builder: (BuildContext context, GoRouterState state) {
                  final noteId = state.pathParameters['noteId']!;
                  return DiaryDetailScreen(noteId: noteId);
                },
              ),
            ]),
        GoRoute(
          path: 'remind',
          builder: (BuildContext context, GoRouterState state) {
            return const RemindScreen();
          },
        ),
        GoRoute(
          path: 'reminder/:id',
          builder: (BuildContext context, GoRouterState state) {
            final reminderId = state.pathParameters['id']!;
            return EditReminderScreen(reminderId: reminderId);
          },
        ),
        GoRoute(
          path: 'add_reminder', // Add route for the new screen
          builder: (BuildContext context, GoRouterState state) {
            return const AddReminderScreen();
          },
        ),
        GoRoute(
          path: 'weather',
          builder: (BuildContext context, GoRouterState state) {
            return const WeatherScreen();
          },
        ),
        GoRoute(
          path: 'write',
          builder: (BuildContext context, GoRouterState state) {
            return const WriteScreen();
          },
        ),
        GoRoute(
          path: 'users',
          builder: (BuildContext context, GoRouterState state) {
            return const UserListScreen();
          },
        ),
        GoRoute(
          path: '/chat',
          builder: (BuildContext context, GoRouterState state) {
            final extra = state.extra as Map<String, dynamic>;
            return ChatScreen(
              receiverId: extra['receiverId']!,
              receiverEmail: extra['receiverEmail']!,
            );
          },
        ),
        GoRoute(
          path: 'logout',
          builder: (BuildContext context, GoRouterState state) {
            return const LogoutScreen();
          },
        ),
      ],
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        StreamProvider<User?>.value(
          value: FirebaseAuth.instance.authStateChanges(),
          initialData: null,
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp.router(
            routerConfig: _router,
            title: 'memoa',
            theme: themeProvider.lightTheme,
            darkTheme: themeProvider.darkTheme,
            themeMode: themeProvider.themeMode,
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
