import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:last_version/auth/screens/sign_up_screen.dart';
import 'package:last_version/notes/screens/home_page_screen.dart';
import 'package:last_version/auth/widgets/custom_text_form_field.dart';
import 'package:last_version/core/helpers/dialogs.dart';
import 'package:last_version/auth/services/auth_service.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
  final AuthService authService = AuthService();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Container(
            height: 600,
            width: 600,

            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(40),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomTextFormField(
                    controller: emailController,
                    label: 'Email',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your Password confirmation";
                      }
                      if (!value.contains("@")) {
                        return "Enter valid email";
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 15),
                  CustomTextFormField(
                    isPassword: true,
                    controller: passwordController,
                    label: 'Password',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your Password confirmation";
                      }
                      if (value != passwordController.text) {
                        return "Passwords do not match";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        final credential = await authService.login(
                          email: emailController.text.trim(),
                          password: passwordController.text.trim(),
                        );

                        if (credential.user!.emailVerified) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomePageScreen(),
                            ),
                          );
                        } else {
                          showSuccessDialog(
                            context,
                            "Move to your Email and verify your Email to continue",
                          );
                        }
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'invalid-email') {
                          showErrorDialog(context, "Invalid Email");
                        } else if (e.code == 'user-not-found') {
                          showErrorDialog(
                            context,
                            "No user found with this email",
                          );
                        } else if (e.code == 'wrong-password') {
                          showErrorDialog(context, "Wrong password");
                        } else if (e.code == 'invalid-credential') {
                          showErrorDialog(
                            context,
                            "Email or password is incorrect",
                          );
                        } else if (e.code == 'user-disabled') {
                          showErrorDialog(
                            context,
                            "This account has been disabled",
                          );
                        } else {
                          showErrorDialog(
                            context,
                            e.message ?? "Something went wrong",
                          );
                        }
                      }
                    },
                    child: Text("Login"),
                  ),
                  SizedBox(height: 12),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: TextButton(
                      onPressed: () async {
                        if (emailController.text.trim().isEmpty) {
                          showErrorDialog(context, 'Please Enter your Email');
                          return;
                        }
                        try {
                          await authService.resetPassword(
                            emailController.text.trim(),
                          );
                          showSuccessDialog(
                            context,
                            "If an account exists for this email, a reset link has been sent.",
                          );
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'invalid-email') {
                            showErrorDialog(context, 'Invalid Email Format');
                          } else {
                            showErrorDialog(
                              context,
                              e.message ?? 'Something went wrong',
                            );
                          }
                        } catch (e) {
                          showErrorDialog(context, 'Something went wrong');
                        }
                      },
                      child: Text(
                        'Forget Password ?',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.grey,
                    ),
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => SignUpScreen()),
                        );
                      },
                      child: const Text(
                        "Create Account",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 15),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: TextButton(
                      onPressed: () async {
                        try {
                          final user = await authService.loginWithGoogle();

                          if (user != null) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => HomePageScreen(),
                              ),
                            );
                          }
                        } catch (e) {
                          print(e);
                        }
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          FaIcon(FontAwesomeIcons.google, color: Colors.white),
                          SizedBox(width: 10),
                          Text(
                            'Login with Google',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
