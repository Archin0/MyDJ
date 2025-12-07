import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

enum MediaType { photo, video }

class MediaSelector extends StatefulWidget {
  const MediaSelector({
    super.key,
    this.mediaType = MediaType.photo,
    required this.onMediaChanged,
  });

  final MediaType mediaType;
  final void Function(String path) onMediaChanged;

  @override
  State<MediaSelector> createState() => _MediaSelectorState();
}

class _MediaSelectorState extends State<MediaSelector> {
  String _mediaPath = '';
  final ImagePicker _picker = ImagePicker();

  Future<XFile?> _retrieveMedia(ImageSource source) async {
    try {
      if (widget.mediaType == MediaType.photo) {
        return _picker.pickImage(source: source, imageQuality: 50);
      }
      return _picker.pickVideo(source: source);
    } catch (e) {
      debugPrint('Error picking media: $e');
      return null;
    }
  }

  Future<void> _selectFromCamera() async {
    final media = await _retrieveMedia(ImageSource.camera);
    if (media == null) return;
    setState(() => _mediaPath = media.path);
    widget.onMediaChanged(_mediaPath);
  }

  Future<void> _selectFromGallery() async {
    final media = await _retrieveMedia(ImageSource.gallery);
    if (media == null) return;
    setState(() => _mediaPath = media.path);
    widget.onMediaChanged(_mediaPath);
  }

  void _deleteSelected() {
    setState(() => _mediaPath = '');
    widget.onMediaChanged('');
  }

  @override
  Widget build(BuildContext context) {
    final preview = _mediaPath.isEmpty
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                widget.mediaType == MediaType.photo
                    ? Icons.image_not_supported
                    : Icons.videocam_off,
                size: 40,
                color: Colors.grey,
              ),
              const SizedBox(height: 5),
              Text(
                widget.mediaType == MediaType.photo ? 'No photo' : 'No video',
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          )
        : widget.mediaType == MediaType.photo
            ? Image.file(
                File(_mediaPath),
                fit: BoxFit.cover,
                width: double.infinity,
              )
            : const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.movie, size: 64, color: Colors.black54),
                  SizedBox(height: 8),
                  Text('Video selected'),
                ],
              );

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Container(
            height: 150,
            width: double.infinity,
            color: Colors.grey[200],
            alignment: Alignment.center,
            child: preview,
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildControlButton(Icons.camera_alt, _selectFromCamera),
              _buildControlButton(Icons.photo_library, _selectFromGallery),
              _buildControlButton(Icons.delete, _deleteSelected,
                  isDelete: true),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton(
    IconData icon,
    VoidCallback onPressed, {
    bool isDelete = false,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isDelete
            ? Colors.red.shade50
            : Theme.of(context).colorScheme.surface,
        foregroundColor:
            isDelete ? Colors.red : Theme.of(context).colorScheme.primary,
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(12),
      ),
      child: Icon(icon),
    );
  }
}
