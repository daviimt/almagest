import 'package:almagest/services/verify_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:almagest/screens/screens.dart';
import 'package:almagest/services/services.dart';
import 'package:flutter_no_internet_widget/flutter_no_internet_widget.dart';

void main() => runApp(AppState());

class AppState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthService(),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (_) => UserService(),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (_) => GetCompanies(),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (_) => VerifyService(),
          lazy: false,
        ),
        // ChangeNotifierProvider(create: (_) => AuthService()),
      ],
      child: MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return InternetWidget(
      offline: LoadingScreen(),
      // ignore: avoid_print
      whenOffline: () => LoadingScreen,
      // ignore: avoid_print
      whenOnline: () => print('Connected to internet'),
      loadingWidget: const Center(child: Text('Loading')),
      online: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Almagest',
        initialRoute: 'login',
        routes: {
          'checking': (_) => CheckAuthScreen(),
          'home': (_) => HomeScreen(),
          'login': (_) => LoginScreen(),
          'register': (_) => RegisterScreen(),
          'admin': (_) => AdminScreen(),
        },
        scaffoldMessengerKey: NotificationsService.messengerKey,
        theme: ThemeData.light().copyWith(
            scaffoldBackgroundColor: Colors.grey[300],
            appBarTheme: const AppBarTheme(elevation: 0, color: Colors.indigo),
            floatingActionButtonTheme: const FloatingActionButtonThemeData(
                backgroundColor: Colors.indigo, elevation: 0)),
      ),
    );
  }
}

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Almagest',
//       initialRoute: 'login',
//       routes: {
//         'checking': (_) => CheckAuthScreen(),
//         'home': (_) => HomeScreen(),
//         'login': (_) => LoginScreen(),
//         'register': (_) => RegisterScreen(),
//         'admin': (_) => AdminScreen(),
//       },
//       scaffoldMessengerKey: NotificationsService.messengerKey,
//       theme: ThemeData.light().copyWith(
//           scaffoldBackgroundColor: Colors.grey[300],
//           appBarTheme: AppBarTheme(elevation: 0, color: Colors.indigo),
//           floatingActionButtonTheme: FloatingActionButtonThemeData(
//               backgroundColor: Colors.indigo, elevation: 0)),
//     );
//   }
// }
