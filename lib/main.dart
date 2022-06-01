import 'package:cleaner/screens/tabs/tabs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();

  runApp(
    ProviderScope(
      child: App(),
    ),
  );
}

class App extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cleaner',
      theme: ThemeData(
        fontFamily: 'ProductSans',
        primarySwatch: Colors.green,
        textTheme: Theme.of(context).textTheme.copyWith(
          bodyText2: TextStyle(fontWeight: FontWeight.w400,fontSize: 14, color: Color(0xFF7581A1)),
          bodyText1: TextStyle(fontWeight: FontWeight.w400, fontSize: 16, color: Color(0xFF7581A1)),
          headline1: TextStyle(fontWeight: FontWeight.w600, fontSize: 35, color: Color(0xFF182D64)),
          headline2: TextStyle(fontWeight: FontWeight.w600, fontSize: 24, color: Color(0xFF182D64)),
          headline3: TextStyle(fontWeight: FontWeight.w600, fontSize: 20, color: Color(0xFF182D64)),
          headline4: TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: Color(0xFF182D64)),
        ),
        colorScheme: Theme.of(context).colorScheme.copyWith(
          primary: Colors.white,
          secondary: Color(0xFF267DFF),
        ),
      ),
      home: TabsScreen(),
    );
  }
}
