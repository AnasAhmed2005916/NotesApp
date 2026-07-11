import 'package:cloud_firestore/cloud_firestore.dart';

class NoteModel {
  final String id;
  final String title;
  final String description;
  final String userId;
  final DateTime createdAt;
  final String? imageUrl;
  final bool isFavorite;

  NoteModel({
    required this.id,
    required this.title,
    required this.description,
    required this.userId,
    required this.createdAt,
    this.imageUrl,
    this.isFavorite = false,
  });
  factory NoteModel.fromJson(Map<String, dynamic> json, String id) {
    return NoteModel(
      id: id,

      title: json['title'] ?? '',

      description: json['description'] ?? '',

      userId: json['userId'] ?? '',

      createdAt: (json['createdAt'] as Timestamp).toDate(),
      imageUrl: (json['imageUrl']),
      isFavorite: json['isFavorite'] ?? false,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'userId': userId,
      'createdAt': Timestamp.fromDate(createdAt),
      'imageUrl': imageUrl,
      'isFavorite': isFavorite,
    };
  }
}
