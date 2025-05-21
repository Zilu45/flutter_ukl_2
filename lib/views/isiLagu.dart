import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_ukl_2/model/isiLaguModel.dart';

class IsiLagu extends StatefulWidget {
  final String songId;
  const IsiLagu({super.key, required this.songId});

  @override
  State<IsiLagu> createState() => _IsiLaguState();
}

class _IsiLaguState extends State<IsiLagu> {
  IsiLaguModel? songData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchSongDetail();
  }

  Future<void> fetchSongDetail() async {
    final url =
        'https://learn.smktelkom-mlg.sch.id/ukl2/playlists/song/${widget.songId}';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        songData = IsiLaguModel.fromJson(data['data']);
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Untuk membuka video di YouTube
  Future<void> _launchVideo(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Song Detail'),
        backgroundColor: Colors.blue.shade700,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : songData == null
              ? const Center(child: Text('Song not found'))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        songData!.title ?? '',
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        songData!.artist ?? '',
                        style:
                            const TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                      const SizedBox(height: 16),
                      GestureDetector(
                        onTap: () {
                          if (songData!.source != null) {
                            _launchVideo(songData!.source);
                          }
                        },
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            AspectRatio(
                              aspectRatio: 16 / 9,
                              child: Image.network(
                                'https://learn.smktelkom-mlg.sch.id/ukl2/thumbnail/${songData!.thumbnail}',
                                fit: BoxFit.cover,
                                errorBuilder: (c, e, s) => Container(
                                  color: Colors.grey.shade200,
                                  child:
                                      const Icon(Icons.music_video, size: 80),
                                ),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.black45,
                                borderRadius: BorderRadius.circular(40),
                              ),
                              child: const Icon(Icons.play_arrow,
                                  color: Colors.white, size: 60),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Description',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade700),
                      ),
                      Text(songData!.description ?? '-'),
                      const SizedBox(height: 16),
                      Text(
                        'Comments',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade700),
                      ),
                      ...((songData!.comments) ?? []).map((comment) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${comment.creator}: ${comment.commentText}',
                                style: const TextStyle(fontSize: 15),
                              ),
                              Text(
                                comment.createdAt ?? '',
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.grey),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
    );
  }
}
