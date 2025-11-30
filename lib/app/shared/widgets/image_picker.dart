import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CustomImagePicker extends StatefulWidget {
  final String label;
  final String? initialImageUrl;
  final Function(XFile?) onImagePicked;

  const CustomImagePicker({
    super.key,
    required this.label,
    this.initialImageUrl,
    required this.onImagePicked,
  });

  @override
  State<CustomImagePicker> createState() => _CustomImagePickerState();
}

class _CustomImagePickerState extends State<CustomImagePicker> {
  final ImagePicker _picker = ImagePicker();
  File? _localImage;

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      setState(() {
        _localImage = File(pickedFile.path);
      });
      widget.onImagePicked(pickedFile);
    }
  }

  @override
  Widget build(BuildContext context) {
    ImageProvider? imageProvider;
    if (_localImage != null) {
      imageProvider = FileImage(_localImage!);
    } else if (widget.initialImageUrl != null &&
        widget.initialImageUrl!.isNotEmpty) {
      if (widget.initialImageUrl!.startsWith('http')) {
        imageProvider = NetworkImage(widget.initialImageUrl!);
      } else {
        imageProvider = FileImage(File(widget.initialImageUrl!));
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        InkWell(
          onTap: _pickImage,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
              image: imageProvider != null
                  ? DecorationImage(image: imageProvider, fit: BoxFit.cover)
                  : null,
            ),
            child: imageProvider == null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_photo_alternate,
                        size: 40,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "Pilih Gambar",
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  )
                : null,
          ),
        ),
        if (imageProvider != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                "Ketuk gambar untuk mengganti",
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ),
          ),
      ],
    );
  }
}
