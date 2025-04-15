import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class PhytonFilterService {
  /// Send image to Phyton API for apply filter with HTTP request.
  /// If function works with success, return filter applied image file otherwise
  /// return original image filter.
  static Future<File?> applyCartoonFilter(File imageFile) async {
    try {
      // If running on a real device, use: http://YOUR_PC_IP:PORT/cartoon
      // You can get your local IP using these terminal commands:
      // macOS:  ifconfig | grep "inet " | grep -v 127.0.0.1
      // Windows: ipconfig
      // If running on the Android emulator, use: http://10.0.2.2:PORT/cartoon
      // Default PORT is 5050.
      final Uri uri = Uri.parse("http://YOUR_PC_IP:PORT/cartoon");

      // Sends the image file as binary data to the server.
      final MultipartRequest request = http.MultipartRequest('POST', uri)
        ..files.add(await http.MultipartFile.fromPath('image', imageFile.path));

      final StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        // Convert the response into a byte array.
        final Uint8List bytes = await response.stream.toBytes();

        // Save the filtered image to the device's temporary directory.
        final Directory dir = await getTemporaryDirectory();
        final File file = File(p.join(
            dir.path, "cartoon_${DateTime.now().millisecondsSinceEpoch}.jpg"));
        await file.writeAsBytes(bytes);
        return file;
      } else {
        debugPrint('Cartoon API error: ${response.statusCode}');
        debugPrint('Response body: ${response.reasonPhrase}');
        return imageFile;
      }
    } catch (e) {
      debugPrint('Exception in cartoon filter: ${e.toString()}');
      return imageFile;
    }
  }
}
