import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:last_version/auth/screens/login_screen.dart';
import 'package:last_version/core/helpers/cubits/theme_cubit/theme_cubit.dart';
import 'package:last_version/notes/screens/favoirte_notes_screen.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            const DrawerHeader(
              child: Center(
                child: Text(
                  'My Notes',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.favorite),
              title: const Text('Favorite Notes'),
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
            ListTile(
              leading: const Icon(Icons.dark_mode),
              title: const Text('Change Theme'),
              onTap: () {
                Navigator.pop(context);
                context.read<ThemeCubit>().toggleTheme();
              },
            ),
            const Spacer(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Logout', style: TextStyle(color: Colors.red)),
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
