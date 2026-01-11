import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:possystem/pages/crud.dart';
import 'package:possystem/providers/user_provider.dart';
import 'package:possystem/utils/checkuser.dart';
import 'package:provider/provider.dart';
import 'package:possystem/providers/order_provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: .fromSeed(
            seedColor: Colors.red,
            primary: Colors.redAccent,
            tertiaryContainer: Color.fromRGBO(128, 128, 128, 0.1),
          ),
          appBarTheme: AppBarTheme(
            toolbarHeight: 80,
            backgroundColor: Colors.redAccent,
            centerTitle: true,
            foregroundColor: Colors.white,
            titleTextStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
          textTheme: TextTheme(
            headlineLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            headlineMedium: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        home: const CheckUser(),
        // home:const MenuCategoryScreen(),
      ),
    );
  }
}
