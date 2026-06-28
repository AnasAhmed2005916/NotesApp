import 'package:cloud_firestore/cloud_firestore.dart';

class NoteModel {
  final String id;
  final String title;
  final String description;
  final String userId;
  final DateTime createdAt;

  NoteModel({
    required this.id,
    required this.title,
    required this.description,
    required this.userId,
    required this.createdAt,
  });
  factory NoteModel.fromJson(Map<String, dynamic> json, String id) {
    return NoteModel(
      id: id,

      title: json['title'] ?? '',

      description: json['description'] ?? '',

      userId: json['userId'] ?? '',

      createdAt: (json['createdAt'] as Timestamp).toDate(),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'userId': userId,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
