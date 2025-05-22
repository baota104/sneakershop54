import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  final String userId;
  final String username;
  final String avatarUrl;
  final String content;
  final double rating;
  final bool ivisible;
  final DateTime timestamp;

  CommentModel({
    required this.userId,
    required this.username,
    required this.avatarUrl,
    required this.content,
    required this.rating,
    required this. ivisible,
    required this.timestamp,
  });

  factory CommentModel.fromMap(Map<String, dynamic> map) {
    return CommentModel(
      userId: map['userId'] ?? '',
      username: map['username'] ?? '',
      avatarUrl: map['avatarUrl'] ?? '',
      content: map['content'] ?? '',
      rating: (map['rating'] as num).toDouble(),
      ivisible:map['ivisible'] ?? false,
      timestamp: (map['timestamp'] as Timestamp).toDate(),
    );
  }
}
