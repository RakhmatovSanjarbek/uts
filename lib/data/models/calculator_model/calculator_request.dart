import 'dart:io';

import 'package:dio/dio.dart';

class CalculatorRequest {
  final File images;
  final String weight;
  final String length;
  final String width;
  final String height;
  final String? comment;

  CalculatorRequest({
    required this.images,
    required this.weight,
    required this.length,
    required this.width,
    required this.height,
    this.comment,
  });

  Future<FormData> toFormData() async {
    return FormData.fromMap({
      "image": await MultipartFile.fromFile(images.path, filename: images.path.split('/').last),
      "weight": weight,
      "length": length,
      "width": width,
      "height": height,
      if (comment != null) "comment": comment,
    });
  }
}
