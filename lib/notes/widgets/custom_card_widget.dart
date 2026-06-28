import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CustomCardWidget extends StatelessWidget {
  const CustomCardWidget({super.key, required this.user});
  final User? user;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),

      child: ListTile(
        leading: CircleAvatar(child: Icon(Icons.person)),

        title: Text(
          user?.email ?? "No Email",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),

        subtitle: Text("Welcome back 👋"),
      ),
    );
  }
}
