
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:streetguards/screens/localization_screen.dart';

import 'package:streetguards/screens/permission_screen.dart';
import 'package:streetguards/screens/report_screen.dart';
import 'package:streetguards/screens/profile_screen.dart';
import 'package:streetguards/screens/splash_screen.dart';
import 'package:streetguards/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  EasyLocalization.ensureInitialized();


  await Firebase.initializeApp();
  runApp( EasyLocalization(
        supportedLocales: [Locale('en'), Locale('ar')],
        useOnlyLangCode: true,
        path: 'assets/translations', // <-- change the path of the translation files
        fallbackLocale: Locale('en'),
        saveLocale: true,
        child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: "StreetGuards",
      debugShowCheckedModeBanner: false,
      supportedLocales: EasyLocalization.of(context).supportedLocales,
      locale: EasyLocalization.of(context).locale,
      localizationsDelegates: [
        // delegate from flutter_localization
        EasyLocalization.of(context).delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        // delegate from localization package.
      ],
      theme: ThemeData.dark().copyWith(
        textTheme: ThemeData.dark().textTheme.apply(
              fontFamily: 'WorkSans',
            ),
        primaryTextTheme: ThemeData.dark().textTheme.apply(
              fontFamily: 'WorkSans',
            ),
        accentTextTheme: ThemeData.dark().textTheme.apply(
              fontFamily: 'WorkSans',
            ),
      ),
      darkTheme: ThemeData(
        fontFamily: 'WorkSans',
      ),
      initialRoute: SplashScreen.id,
      routes: {
        HomeScreen.id: (context) => HomeScreen(),
     //   Search.id: (context) => Search(),
        LocalizationScreen.id: (context) => LocalizationScreen(),
        PermissionScreen.id: (context) => PermissionScreen(),
        SplashScreen.id: (context) => SplashScreen(),
        ProfileScreen.id: (context) => ProfileScreen(),
        ReportScreen.id: (context) => ReportScreen(),
      },
    );
  }
}
