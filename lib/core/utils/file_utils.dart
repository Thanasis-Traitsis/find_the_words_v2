import 'package:archive/archive.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

class FileUtils {
  static String stageFile(letterNum,langCode) =>
      'stages/${letterNum}_letter_words_$langCode.min.json';
  static String dictionaryFile(fileName,langCode) => 'dictionary/${fileName}_$langCode.min.json';

  static Future<Map<String, dynamic>> loadCompressedJson(String path) async {
    final ByteData data = await rootBundle.load('assets/$path.gz');
    final List<int> bytes = data.buffer.asUint8List();

    final List<int> decompressed = GZipDecoder().decodeBytes(bytes);

    final String jsonString = utf8.decode(decompressed);
    return json.decode(jsonString);
  }
}
