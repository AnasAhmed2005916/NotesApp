import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:last_version/core/dependency_injuction/dependency_injuction.dart';
import 'package:last_version/core/helpers/dialogs.dart';
import 'package:last_version/core/utils/app_text_styles.dart';
import 'package:last_version/features/auth/screens/sign_up_screen.dart';
import 'package:last_version/features/auth/services/auth_service.dart';
import 'package:last_version/features/auth/widgets/custom_text_form_field.dart';
import 'package:last_version/features/notes/screens/home_page_screen.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final AuthService authService = getIt<AuthService>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("login".tr())),
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
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
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

                    const SizedBox(height: 20),

                    ElevatedButton(
                      onPressed: () async {
                        if (!formKey.currentState!.validate()) return;

                        try {
                          final credential = await authService.login(
                            email: emailController.text.trim(),
                            password: passwordController.text.trim(),
                          );

                          if (credential.user!.emailVerified) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => HomePageScreen(),
                              ),
                            );
                          } else {
                            showSuccessDialog(
                              context,
                              "verification_message".tr(),
                            );
                          }
                        } on FirebaseAuthException catch (e) {
                          switch (e.code) {
                            case 'invalid-email':
                              showErrorDialog(context, "invalid_email".tr());
                              break;

                            case 'user-not-found':
                              showErrorDialog(context, "user_not_found".tr());
                              break;

                            case 'wrong-password':
                              showErrorDialog(context, "wrong_password".tr());
                              break;

                            case 'invalid-credential':
                              showErrorDialog(
                                context,
                                "invalid_credentials".tr(),
                              );
                              break;

                            case 'user-disabled':
                              showErrorDialog(context, "account_disabled".tr());
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
                      child: Text("login".tr()),
                    ),

                    const SizedBox(height: 12),

                    Align(
                      alignment: Alignment.bottomRight,
                      child: TextButton(
                        onPressed: () async {
                          if (emailController.text.trim().isEmpty) {
                            showErrorDialog(context, "please_enter_email".tr());
                            return;
                          }

                          try {
                            await authService.resetPassword(
                              emailController.text.trim(),
                            );

                            showSuccessDialog(
                              context,
                              "reset_password_sent".tr(),
                            );
                          } on FirebaseAuthException catch (e) {
                            if (e.code == 'invalid-email') {
                              showErrorDialog(
                                context,
                                "invalid_email_format".tr(),
                              );
                            } else {
                              showErrorDialog(
                                context,
                                "something_went_wrong".tr(),
                              );
                            }
                          } catch (_) {
                            showErrorDialog(
                              context,
                              "something_went_wrong".tr(),
                            );
                          }
                        },
                        child: Text(
                          "forget_password".tr(),
                          style: const TextStyle(
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
                            MaterialPageRoute(
                              builder: (_) => const SignUpScreen(),
                            ),
                          );
                        },
                        child: Text(
                          "create_account".tr(),
                          style: AppTextStyles.authTitle,
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

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
                          } catch (_) {
                            showErrorDialog(
                              context,
                              "something_went_wrong".tr(),
                            );
                          }
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const FaIcon(
                              FontAwesomeIcons.google,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              "login_with_google".tr(),
                              style: AppTextStyles.authTitle,
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
      ),
    );
  }
}
