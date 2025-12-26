import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:possystem/pages/forgotpassword.dart';
import 'package:possystem/pages/signuppage.dart';
import '../components/uihelper.dart';
import 'homepage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  login(String email, String password) async {
    if (email == "" && password == "") {
      Helper.showAlert(context: context, title: "Enter Required Fields");
    } else {
      UserCredential? usercredentials;
      try {
        usercredentials = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password)
            .then((value) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MyHomePage(title: "PopNFry"),
                ),
              );
            });
      } on FirebaseAuthException catch (err) {
        return Helper.showAlert(context: context, title: err.code.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(30),
        child: AppBar(
          title: Text("PopNFry"),
          // centerTitle: true,
          automaticallyImplyLeading: false,
          // surfaceTintColor: Colors.redAccent,
          // backgroundColor: Colors.redAccent,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        child: Column(
          spacing: 10,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Helper.CustomTextField(emailController, "Email", Icons.mail, false),
            Helper.CustomTextField(
              passwordController,
              "Password",
              Icons.password,
              true,
            ),
            SizedBox(height: 30),
            Helper.CustomButton(() {
              login(
                emailController.text.toString(),
                passwordController.text.toString(),
              );
            }, "login"),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Don't have account?",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignupPage()),
                    );
                  },
                  style: TextButton.styleFrom(
                    elevation: 0,
                    textStyle: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    foregroundColor: Colors.blue,
                  ),
                  child: Text("Sign Up"),
                ),
              ],
            ),
            SizedBox(height: 20),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ForgotPass(),//Forgot Password screen
                  ),
                );
              },
              child: Text(
                "Forgot password?",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500,color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
