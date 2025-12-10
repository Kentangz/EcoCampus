import 'dart:convert';
import 'dart:io';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:crypto/crypto.dart';
import 'package:ecocampus/app/shared/utils/notification_helper.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class CloudinaryService {
  final String _cloudName = dotenv.env['CLOUDINARY_CLOUD_NAME'] ?? '';
  final String _uploadPreset = dotenv.env['CLOUDINARY_UPLOAD_PRESET'] ?? '';
  final String _apiKey = dotenv.env['CLOUDINARY_API_KEY'] ?? '';
  final String _apiSecret = dotenv.env['CLOUDINARY_API_SECRET'] ?? '';

  late final CloudinaryPublic cloudinary;

  CloudinaryService() {
    cloudinary = CloudinaryPublic(_cloudName, _uploadPreset, cache: false);
  }

  Future<String?> uploadImage(File file) async {
    if (_cloudName.isEmpty || _uploadPreset.isEmpty) {
      NotificationHelper.showError("Config Error", "Cek .env");
      return null;
    }
    try {
      CloudinaryResponse response = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(
          file.path,
          resourceType: CloudinaryResourceType.Auto,
        ),
      );
      return response.secureUrl;
    } catch (e) {
      // print("Cloudinary Error: $e");
      return null;
    }
  }

  Future<bool> deleteImage(String imageUrl) async {
    if (imageUrl.isEmpty || !imageUrl.startsWith('http')) return false;

    String? publicId = _getPublicIdFromUrl(imageUrl);
    if (publicId == null) return false;

    String resourceType = 'image';
    if (imageUrl.contains('/video/')) {
      resourceType = 'video';
    } else if (imageUrl.contains('/raw/')) {
      resourceType = 'raw';
    }

    try {
      String timestamp = DateTime.now().millisecondsSinceEpoch.toString();

      String strToSign = "public_id=$publicId&timestamp=$timestamp$_apiSecret";
      var bytes = utf8.encode(strToSign);
      var digest = sha1.convert(bytes);
      String signature = digest.toString();

      var uri = Uri.parse(
        "https://api.cloudinary.com/v1_1/$_cloudName/$resourceType/destroy",
      );

      var response = await http.post(
        uri,
        body: {
          "public_id": publicId,
          "api_key": _apiKey,
          "timestamp": timestamp,
          "signature": signature,
        },
      );

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        if (jsonResponse['result'] == 'ok') {
          return true;
        }
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  String? _getPublicIdFromUrl(String url) {
    try {
      Uri uri = Uri.parse(url);
      List<String> segments = uri.pathSegments;

      int uploadIndex = segments.indexOf('upload');
      if (uploadIndex == -1 || uploadIndex + 2 >= segments.length) return null;

      List<String> publicIdSegments = segments.sublist(uploadIndex + 2);
      String fullPath = publicIdSegments.join('/');

      int dotIndex = fullPath.lastIndexOf('.');
      if (dotIndex != -1) {
        return fullPath.substring(0, dotIndex);
      }
      return fullPath;
    } catch (e) {
      return null;
    }
  }
}
