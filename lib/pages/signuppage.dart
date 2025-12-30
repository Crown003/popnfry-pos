import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:possystem/pages/loginpage.dart';
import '../components/uihelper.dart';
import '../providers/user_provider.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  signup(String email, String password, String confirmPassword) async {
    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      Helper.showAlert(context: context, title: "Enter Required Fields");
      return;
    }

    final userProvider = context.read<UserProvider>();
    bool success = await userProvider.signUp(email, password, confirmPassword);

    if (success && mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginPage(),
        ),
      );
    } else if (mounted) {
      Helper.showAlert(
        context: context,
        title: userProvider.errorMessage ?? "Sign up failed",
      );
      userProvider.clearError();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("PopNFry"),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        child: Consumer<UserProvider>(
          builder: (context, userProvider, child) {
            return Column(
              spacing: 10,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Helper.CustomTextField(
                  emailController,
                  "Email",
                  Icons.mail,
                  false,
                ),
                Helper.CustomTextField(
                  passwordController,
                  "Password",
                  Icons.password,
                  true,
                ),
                Helper.CustomTextField(
                  confirmPasswordController,
                  "Confirm Password",
                  Icons.password,
                  true,
                ),
                const SizedBox(height: 30),
                Helper.CustomButton(
                  userProvider.isLoading
                      ? null
                      : () {
                    signup(
                      emailController.text.toString(),
                      passwordController.text.toString(),
                      confirmPasswordController.text.toString(),
                    );
                  },
                  userProvider.isLoading ? "Signing up..." : "Sign Up",
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
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
                      },
                      style: TextButton.styleFrom(
                        elevation: 0,
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        foregroundColor: Colors.blue,
                      ),
                      child: const Text("log in"),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}