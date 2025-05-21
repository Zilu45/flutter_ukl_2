import 'package:flutter_ukl_2/model/isiLaguModel.dart';

class IsiLaguModel {
  final String uuid;
  final String title;
  final String artist;
  final String description;
  final String source;
  final String thumbnail;
  final int likes;
  final List<CommentModel> comments;

  IsiLaguModel({
    required this.uuid,
    required this.title,
    required this.artist,
    required this.description,
    required this.source,
    required this.thumbnail,
    required this.likes,
    required this.comments,
  });

  factory IsiLaguModel.fromJson(Map<String, dynamic> json) {
    return IsiLaguModel(
      uuid: json['uuid'] ?? '',
      title: json['title'] ?? '',
      artist: json['artist'] ?? '',
      description: json['description'] ?? '',
      source: json['source'] ?? '',
      thumbnail: json['thumbnail'] ?? '',
      likes: json['likes'] ?? 0,
      comments: (json['comments'] as List<dynamic>? ?? [])
          .map((c) => CommentModel.fromJson(c))
          .toList(),
    );
  }
}

class CommentModel {
  final String commentText;
  final String creator;
  final String createdAt;

  CommentModel({
    required this.commentText,
    required this.creator,
    required this.createdAt,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      commentText: json['comment_text'] ?? '',
      creator: json['creator'] ?? '',
      createdAt: json['createdAt'] ?? '',
    );
  }
}
