import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:possystem/pages/forgotpassword.dart';
import 'package:possystem/pages/signuppage.dart';
import '../components/uihelper.dart';
import '../providers/user_provider.dart';
import 'homepage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  login(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      Helper.showAlert(context: context, title: "Enter Required Fields");
      return;
    }

    final userProvider = context.read<UserProvider>();
    bool success = await userProvider.signIn(email, password);

    if (success && mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MyHomePage(title: "PopNFry"),
        ),
      );
    } else if (mounted) {
      Helper.showAlert(
        context: context,
        title: userProvider.errorMessage ?? "Login failed",
      );
      userProvider.clearError();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(30),
        child: AppBar(
          title: const Text("PopNFry"),
          automaticallyImplyLeading: false,
        ),
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
                const SizedBox(height: 30),
                Helper.CustomButton(
                  userProvider.isLoading
                      ? null
                      : () {
                    login(
                      emailController.text.toString(),
                      passwordController.text.toString(),
                    );
                  },
                  userProvider.isLoading ? "Logging in..." : "Login",
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
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
                          MaterialPageRoute(
                            builder: (context) => const SignupPage(),
                          ),
                        );
                      },
                      style: TextButton.styleFrom(
                        elevation: 0,
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        foregroundColor: Colors.blue,
                      ),
                      child: const Text("Sign Up"),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ForgotPass(),
                      ),
                    );
                  },
                  child: const Text(
                    "Forgot password?",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}