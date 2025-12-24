import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:vndor/core/error/exception.dart';

class StorageService {
  static const String _cloudName = 'dmlrvzvaa';
  static const String _uploadPreset = 'vndorapp';

  Future<String> uploadProductImage({
    required File file,
    required String vendorId, 
  }) async {

    try {
      final uri = Uri.parse(
        'https://api.cloudinary.com/v1_1/$_cloudName/image/upload',
      );

      final request = http.MultipartRequest('POST', uri)
        ..fields['upload_preset'] = _uploadPreset
        ..files.add(
          await http.MultipartFile.fromPath('file', file.path),
        );

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

    

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw ServerException('Cloudinary upload failed');
      }

      final json = jsonDecode(responseBody);
      final url = json['secure_url'];

      if (url == null || url.isEmpty) {
        throw ServerException('Cloudinary returned empty URL');
      }

      return url;
    } catch (e) {
      throw ServerException('Image upload failed');
    }
  }
}
