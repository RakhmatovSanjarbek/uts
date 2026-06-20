import 'dart:io';
import 'package:dio/dio.dart';
import 'package:mime/mime.dart';

String detectMime(String path) {
  final mime = lookupMimeType(path);
  if (mime != null && mime.startsWith('image/')) return mime;
  final ext = path.split('.').last.toLowerCase();
  const map = {
    'jpg': 'image/jpeg',
    'jpeg': 'image/jpeg',
    'png': 'image/png',
    'webp': 'image/webp',
    'heic': 'image/heic',
    'heif': 'image/heif',
  };
  return map[ext] ?? 'image/jpeg';
}

Future<MultipartFile> toMultipart(File file, {String prefix = 'photo'}) async {
  final bytes = await file.readAsBytes();
  if (bytes.isEmpty) {
    throw Exception("Rasm fayli bo'sh yoki o'qib bo'lmadi.");
  }
  final mime = detectMime(file.path);
  final ext = file.path.split('.').last.toLowerCase();
  final filename = '${prefix}_${DateTime.now().millisecondsSinceEpoch}.$ext';
  return MultipartFile.fromBytes(
    bytes,
    filename: filename,
    contentType: DioMediaType.parse(mime),
  );
}