// @dart=2.9

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:matka/providers/user_provider.dart';
//import 'package:firebase_analytics/firebase_analytics.dart';
//import 'package:firebase_analytics/observer.dart';
//import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:matka/util/CU.dart';
import 'package:provider/provider.dart';

import 'navigation/screens/SplashScreen.dart';

//import 'package:Matka Master/util/CU.dart';
//import 'navigation/screens/SplashScreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
//  Crashlytics.instance.enableInDevMode = true;
  // Pass all uncaught errors from the framework to Crashlytics.
//  FlutterError.onError = Crashlytics.instance.recordFlutterError;
  runZoned<Future<void>>(() async {
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<UserProvider>(
              create: (context) => UserProvider()),
        ],
        child: MyApp(),
      ),
    );
    // ignore: deprecated_member_use
  }, onError: (dynamic error, dynamic stack) {
//    Crashlytics.instance.recordError;
  });
}

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
//  FirebaseAnalytics analytics = FirebaseAnalytics();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'All Markets Game',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "GoogleSans-Regular",
        hintColor: CU.textColorhint,
//        cursorColor: CU.primaryColor,
        primaryColor: CU.primaryColor,
        inputDecorationTheme: InputDecorationTheme(),
        textSelectionTheme:
            TextSelectionThemeData(selectionColor: CU.primaryColor),
      ),
      builder: (context, child) {
        // double scale = (MediaQuery.of(context).size.height /
        // MediaQuery.of(context).size.width );
        return MediaQuery(
          child: child,
          data: MediaQuery.of(context)
              .copyWith(textScaleFactor: Platform.isAndroid ? 1.2 : 1.4),
        );
//          ScrollConfiguration(
//          behavior: MyScrollBehavior(),
//          child: child,
//        );
      },
      home: SplashScreen(),
//      navigatorObservers: [
//        FirebaseAnalyticsObserver(analytics: analytics),
//      ],
    );
  }
}

//---------------------------------MyHttpOverrides----------------------------//
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
