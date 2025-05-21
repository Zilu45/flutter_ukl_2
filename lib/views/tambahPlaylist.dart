import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class TambahLagu extends StatefulWidget {
  const TambahLagu({super.key});

  @override
  State<TambahLagu> createState() => _TambahLaguState();
}

class _TambahLaguState extends State<TambahLagu> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController artistController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final TextEditingController sourceController = TextEditingController();
  XFile? thumbnail;
  bool isLoading = false;

  Future<void> pickImage() async {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () async {
                final picked =
                    await ImagePicker().pickImage(source: ImageSource.gallery);
                if (picked != null) {
                  setState(() {
                    thumbnail = picked;
                  });
                }
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () async {
                final picked =
                    await ImagePicker().pickImage(source: ImageSource.camera);
                if (picked != null) {
                  setState(() {
                    thumbnail = picked;
                  });
                }
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> saveSong() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => isLoading = true);

    var uri =
        Uri.parse('https://learn.smktelkom-mlg.sch.id/ukl2/playlists/song');
    var request = http.MultipartRequest('POST', uri)
      ..fields['title'] = titleController.text
      ..fields['artist'] = artistController.text
      ..fields['description'] = descController.text
      ..fields['source'] = sourceController.text;

    if (thumbnail != null) {
      request.files
          .add(await http.MultipartFile.fromPath('thumbnail', thumbnail!.path));
    }

    var response = await request.send();
    setState(() => isLoading = false);
    if (response.statusCode == 200) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Song has been created!')),
        );
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/playlist',
          (route) => false,
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to add song')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ADD NEW SONG'),
        backgroundColor: Colors.blue.shade700,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.popUntil(context, ModalRoute.withName('/playlist'));
          },
          icon: const Icon(Icons.music_note),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Card(
            elevation: 4,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        labelText: 'Title',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.music_note),
                      ),
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Required' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: artistController,
                      decoration: const InputDecoration(
                        labelText: 'Artist',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person),
                      ),
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Required' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: descController,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.description),
                      ),
                      maxLines: 3,
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Required' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: sourceController,
                      decoration: const InputDecoration(
                        labelText: 'Source (YouTube URL)',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.link),
                      ),
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Required' : null,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        ElevatedButton.icon(
                          onPressed: pickImage,
                          icon: const Icon(Icons.attach_file),
                          label: const Text('Choose File'),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            thumbnail != null
                                ? thumbnail!.name
                                : 'No file chosen',
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 13, color: Colors.black54),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: isLoading
                                ? null
                                : () {
                                    Navigator.pushNamedAndRemoveUntil(
                                      context,
                                      '/playlist',
                                      (route) => true,
                                    );
                                  },
                            child: const Text('Cancel'),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: isLoading ? null : saveSong,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue.shade700,
                            ),
                            child: isLoading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2, color: Colors.white),
                                  )
                                : const Text('Save Song'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
