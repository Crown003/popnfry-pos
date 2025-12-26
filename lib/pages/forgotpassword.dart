import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:possystem/components/uihelper.dart';

class ForgotPass extends StatefulWidget {
  const ForgotPass({super.key});

  @override
  State<ForgotPass> createState() => _ForgotPassState();
}

class _ForgotPassState extends State<ForgotPass> {
  TextEditingController emailController = TextEditingController();
  forgotPassword( String email) async {
    if(email==""){
      Helper.showAlert(context: context, title: "Enter a Valid email.");
    }else{
      FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    }

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("PopNFry"),
      ),
      body:Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Helper.CustomTextField(emailController, "Email", Icons.mail, false),
            SizedBox(height: 20,),
            Helper.CustomButton((){
              forgotPassword(emailController.text.toString());
            }, "Reset Password")
          ],
        ),
      )
    );
  }


}
