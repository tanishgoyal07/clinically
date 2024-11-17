import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:scaitica/utils/constant.dart';

class PosePredictionService {
  static Future<Map<String, dynamic>> predictPose(
      Uint8List imageBytes, String targetPose) async {
    try {
      final base64Image = base64Encode(imageBytes);
      final response = await http.post(
        Uri.parse(SERVER_URI),
        headers: {"Content-Type": "application/json"},
        body: json.encode({'frame': base64Image, 'target_pose': targetPose}),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to predict pose');
      }
    } catch (e) {
      print("Error during pose prediction: $e");
      throw e;
    }
  }
}
