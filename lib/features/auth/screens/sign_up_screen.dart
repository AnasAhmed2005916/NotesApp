import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:last_version/core/dependency_injuction/dependency_injuction.dart';
import 'package:last_version/core/helpers/dialogs.dart';
import 'package:last_version/features/auth/screens/login_screen.dart';
import 'package:last_version/features/auth/services/auth_service.dart';
import 'package:last_version/features/auth/widgets/custom_text_form_field.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final AuthService authService = getIt<AuthService>();

  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("sign_up".tr())),
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
                      label: "name".tr(),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "please_enter_name".tr();
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 15),

                    CustomTextFormField(
                      controller: emailController,
                      label: "email".tr(),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "please_enter_email".tr();
                        }

                        if (!value.contains("@")) {
                          return "enter_valid_email".tr();
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: 15),

                    CustomTextFormField(
                      controller: passwordController,
                      isPassword: true,
                      label: "password".tr(),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "please_enter_password".tr();
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 15),

                    CustomTextFormField(
                      controller: confirmPasswordController,
                      isPassword: true,
                      label: "confirm_password".tr(),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "please_enter_confirm_password".tr();
                        }

                        if (value != passwordController.text) {
                          return "passwords_do_not_match".tr();
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: 20),

                    ElevatedButton(
                      onPressed: () async {
                        if (!formKey.currentState!.validate()) return;

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
                            title: "success".tr(),
                            desc:
                                "${"account_created".tr()}\n${"verify_email_next".tr()}",
                            btnOkText: "ok".tr(),
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
                          switch (e.code) {
                            case 'weak-password':
                              showErrorDialog(context, "weak_password".tr());
                              break;

                            case 'email-already-in-use':
                              showErrorDialog(
                                context,
                                "email_already_used".tr(),
                              );
                              break;

                            case 'invalid-email':
                              showErrorDialog(context, "invalid_email".tr());
                              break;

                            default:
                              showErrorDialog(
                                context,
                                "something_went_wrong".tr(),
                              );
                          }
                        } catch (_) {
                          showErrorDialog(context, "something_went_wrong".tr());
                        }
                      },
                      child: Text("create_account".tr()),
                    ),

                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => LoginScreen()),
                        );
                      },
                      child: Text("already_have_account".tr()),
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
