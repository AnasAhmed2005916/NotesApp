import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:last_version/core/helpers/cubits/theme_cubit/theme_cubit.dart';
import 'package:last_version/features/auth/screens/login_screen.dart';
import 'package:last_version/features/notes/cubits/note_cubit/note_cubit.dart';
import 'package:last_version/features/notes/screens/archived_notes_screen.dart';
import 'package:last_version/features/notes/screens/favoirte_notes_screen.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(user?.displayName ?? "user"),
              accountEmail: Text(user?.email ?? "No Email"),
              currentAccountPicture: const CircleAvatar(
                child: Icon(Icons.person),
              ),
            ),

            /// Favorite Notes
            ListTile(
              leading: const Icon(Icons.favorite),
              title: Text("favorite_notes".tr()),
              onTap: () {
                Navigator.pop(context);

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const FavoirteNotesScreen(),
                  ),
                );
              },
            ),

            /// Change Theme
            ListTile(
              leading: const Icon(Icons.dark_mode),
              title: Text("change_theme".tr()),
              onTap: () {
                Navigator.pop(context);
                context.read<ThemeCubit>().toggleTheme();
              },
            ),

            /// Delete All Notes
            ListTile(
              leading: const Icon(Icons.delete_forever, color: Colors.red),
              title: Text("delete_all_notes".tr()),
              onTap: () async {
                final result = await showDialog<bool>(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text("delete_all_notes".tr()),
                      content: Text("delete_all_notes_confirmation".tr()),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context, false);
                          },
                          child: Text("cancel".tr()),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context, true);
                          },
                          child: Text(
                            "delete".tr(),
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    );
                  },
                );

                if (result == true && context.mounted) {
                  context.read<NoteCubit>().deleteAllNotes();

                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                }
              },
            ),

            /// Archived Notes
            ListTile(
              leading: const Icon(Icons.archive),
              title: Text("archived_notes".tr()),
              onTap: () {
                Navigator.pop(context);

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ArchivedNotesScreen(),
                  ),
                );
              },
            ),

            /// Change Language
            ListTile(
              leading: const Icon(Icons.language),
              title: Text("change_language".tr()),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text("change_language".tr()),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            leading: const Text("🇺🇸"),
                            title: Text("english".tr()),
                            onTap: () {
                              context.setLocale(const Locale("en"));
                              Navigator.pop(context);
                            },
                          ),
                          ListTile(
                            leading: const Text("🇪🇬"),
                            title: Text("arabic".tr()),
                            onTap: () {
                              context.setLocale(const Locale("ar"));
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),

            const Spacer(),

            /// Logout
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: Text(
                "logout".tr(),
                style: const TextStyle(color: Colors.red),
              ),
              onTap: () async {
                await FirebaseAuth.instance.signOut();

                if (context.mounted) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => LoginScreen()),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
