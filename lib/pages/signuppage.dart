import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:possystem/pages/loginpage.dart';
import '../components/uihelper.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  void signup(String email, String password) async {
    if (email == "" && password == "") {
      Helper.showAlert(context: context, title: "Enter Required Fields");
    } else {
      UserCredential? usercredential;
      try {
        usercredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password)
            .then((value) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginPage(),
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
              signup(
                emailController.text.toString(),
                passwordController.text.toString(),
              );
            }, "Sign Up"),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Already have account?",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    // context, MaterialPageRoute(builder: (context) => LoginPage()));
                  },
                  style: TextButton.styleFrom(
                    elevation: 0,
                    textStyle: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    foregroundColor: Colors.blue,
                  ),
                  child: Text("log in"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
