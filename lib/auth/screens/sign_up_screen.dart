import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:last_version/auth/screens/login_screen.dart';
import 'package:last_version/auth/services/auth_service.dart';
import 'package:last_version/auth/widgets/custom_text_form_field.dart';
import 'package:last_version/core/helpers/dialogs.dart';

class SignUpScreen extends StatefulWidget {
  SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final AuthService authService = AuthService();
  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();

  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  final confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sign Up")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Container(
              height: 600,
              width: 600,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(40),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 40),

                    CustomTextFormField(
                      controller: nameController,
                      label: 'Name',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your Name";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 15),

                    CustomTextFormField(
                      controller: emailController,
                      label: 'Email',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your Email";
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 15),

                    CustomTextFormField(
                      controller: passwordController,
                      isPassword: true,
                      label: 'Password',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your Password";
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 15),

                    CustomTextFormField(
                      controller: confirmPasswordController,
                      isPassword: true,
                      label: 'Confirm Password',
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
                        if (formKey.currentState!.validate()) {
                          try {
                            await authService.signUp(
                              email: emailController.text.trim(),
                              password: passwordController.text.trim(),
                            );
                            await authService.sendEmailVerification();
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.success,
                              animType: AnimType.rightSlide,
                              title: "Success",
                              desc:
                                  "Account created successfully => Next step => (verfication of Email)",
                              btnOkOnPress: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => LoginScreen(),
                                  ),
                                );
                              },
                            ).show();
                          } on FirebaseAuthException catch (e) {
                            if (e.code == 'weak-password') {
                              showErrorDialog(
                                context,
                                "The password provided is too weak",
                              );
                            } else if (e.code == 'email-already-in-use') {
                              showErrorDialog(
                                context,
                                "This email is already used",
                              );
                            } else if (e.code == 'invalid-email') {
                              showErrorDialog(
                                context,
                                "Email address is invalid",
                              );
                            } else {
                              showErrorDialog(
                                context,
                                e.message ?? "Something went wrong",
                              );
                            }
                          }
                        }
                      },
                      child: const Text("Create Account"),
                    ),

                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => LoginScreen()),
                        );
                      },
                      child: const Text("Already have an account? Login"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
