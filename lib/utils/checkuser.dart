import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:possystem/pages/loginpage.dart';
import '../pages/homepage.dart';

class CheckUser extends StatelessWidget {
  const CheckUser({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // 1. While Firebase is initializing or checking the token
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // 2. If a local user exists, we verify they weren't deleted from the console
        if (snapshot.hasData) {
          return FutureBuilder(
            future: snapshot.data!.reload(),
            builder: (context, reloadSnapshot) {
              // If the reload fails because the user was deleted,
              // authStateChanges will automatically emit 'null' and move to Login.
              if (reloadSnapshot.hasError) {
                return const LoginPage();
              }

              // If still reloading, show a tiny delay/loading state
              if (reloadSnapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(body: Center(child: CircularProgressIndicator()));
              }

              return const MyHomePage(title: "PopNFry");
            },
          );
        }

        // 3. No user is logged in
        return const LoginPage();
      },
    );
  }
}