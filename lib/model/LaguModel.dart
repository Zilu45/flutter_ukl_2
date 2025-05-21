
class LaguModel {
  final String uuid;
  final String title;
  final String artist;
  final String description;
  final String source;
  final String thumbnail;
  final int likes;

  LaguModel({
    required this.uuid,
    required this.title,
    required this.artist,
    required this.description,
    required this.source,
    required this.thumbnail,
    required this.likes,
  });

  factory LaguModel.fromJson(Map<String, dynamic> json) {
    return LaguModel(
      uuid: json['uuid'] ?? '',
      title: json['title'] ?? '',
      artist: json['artist'] ?? '',
      description: json['description'] ?? '',
      source: json['source'] ?? '',
      thumbnail: json['thumbnail'] ?? '',
      likes: json['likes'] ?? 0,
    );
  }
}