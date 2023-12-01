import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:servicehub/firebase_options.dart';
import 'package:servicehub/model/app_state.dart';
import 'package:servicehub/side_bar_screens/dashboard.dart';
import 'package:servicehub/side_bar_screens/main_screen.dart';
import 'package:servicehub/side_bar_screens/orders.dart';
import 'package:servicehub/side_bar_screens/requests.dart';
import 'package:servicehub/side_bar_screens/transactions.dart';
import 'package:servicehub/view/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);

    FirebaseFirestore.instance.settings = Settings(persistenceEnabled: false);
    runApp(const MyDashBoard());
  } else {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    runApp(const MyApp());
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => ApplicationState())],
      child: ChangeNotifierProvider(
        create: (_) => ApplicationState(),
        child: MaterialApp(
          title: 'ServiceHub',
          themeMode: ThemeMode.system,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: const SplashScreen(),
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}

class MyDashBoard extends StatelessWidget {
  const MyDashBoard({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ServiceHub',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: SplashScreen.id,
      routes: {
        SplashScreen.id: (context) => SplashScreen(),
        MainScreen.id: (context) => MainScreen(),
        Requests.id: (context) => Requests(),
        Transactions.id: (context) => Transactions(),
        Orders.id: (context) => Orders(),
        DashBoardScreen.id: (context) => DashBoardScreen(),
      },
    );
  }
}
