import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_ukl_2/model/LaguModel.dart';
import 'package:flutter_ukl_2/views/isiLagu.dart';

class Lagu extends StatefulWidget {
  final String playlistId;
  const Lagu({super.key, required this.playlistId});

  @override
  State<Lagu> createState() => _LaguState();
}

class _LaguState extends State<Lagu> {
  List<LaguModel> songs = [];
  List<LaguModel> filteredSongs = [];
  bool isLoading = true;
  TextEditingController searchController = TextEditingController();
  Set<String> likedSongs = {};

  @override
  void initState() {
    super.initState();
    fetchSongs();
    searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    String query = searchController.text.toLowerCase();
    setState(() {
      filteredSongs = songs.where((song) {
        final title = song.title.toLowerCase();
        final artist = song.artist.toLowerCase();
        return title.contains(query) || artist.contains(query);
      }).toList();
    });
  }

  Future<void> fetchSongs() async {
    final url =
        'https://learn.smktelkom-mlg.sch.id/ukl2/playlists/song-list/${widget.playlistId}';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        songs = List<LaguModel>.from(
            data['data'].map((x) => LaguModel.fromJson(x)));
        filteredSongs = songs;
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Song List'),
        backgroundColor: Colors.blue.shade700,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextField(
                    controller: searchController,
                    decoration: const InputDecoration(
                      hintText: 'Search',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredSongs.length,
                    itemBuilder: (context, index) {
                      final song = filteredSongs[index];
                      final songId = song.uuid;
                      final isLiked = likedSongs.contains(songId);

                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        child: ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    IsiLagu(songId: song.uuid),
                              ),
                            );
                          },
                          leading: song.thumbnail.isNotEmpty
                              ? Image.network(
                                  'https://learn.smktelkom-mlg.sch.id/ukl2/thumbnail/${song.thumbnail}',
                                  width: 48,
                                  height: 48,
                                  fit: BoxFit.cover,
                                  errorBuilder: (c, e, s) =>
                                      const Icon(Icons.music_note),
                                )
                              : const Icon(Icons.music_note, size: 48),
                          title: Text(song.title),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(song.artist),
                              Text(song.description,
                                  maxLines: 2, overflow: TextOverflow.ellipsis),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    if (isLiked) {
                                      likedSongs.remove(songId);
                                    } else {
                                      likedSongs.add(songId);
                                    }
                                  });
                                },
                                icon: Icon(
                                  isLiked
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: isLiked ? Colors.red : Colors.grey,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text('${song.likes}'),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
