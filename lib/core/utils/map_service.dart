import 'dart:io';
import 'package:url_launcher/url_launcher.dart';

class MapService {
  static Future<void> openSystemMap({
    required double lat,
    required double lng,
  }) async {
    Uri uri;

    if (Platform.isAndroid) {
      uri = Uri.parse("geo:$lat,$lng?q=$lat,$lng");
    } else if (Platform.isIOS) {
      uri = Uri.parse("http://maps.apple.com/?ll=$lat,$lng");
    } else {
      uri = Uri.parse(
        "https://www.google.com/maps/search/?api=1&query=$lat,$lng",
      );
    }

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Xaritani ochib bo\'lmadi: $uri';
    }
  }
}
