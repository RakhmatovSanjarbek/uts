import 'package:flutter/material.dart';

class VideoUtils {
  // YouTube URL dan video ID olish
  static String? extractVideoId(String url) {
    // https://youtu.be/C3sVjpiU1P4?si=... format uchun
    final regExp1 = RegExp(r'youtu\.be\/([a-zA-Z0-9_-]{11})');
    // https://www.youtube.com/watch?v=... format uchun
    final regExp2 = RegExp(r'watch\?v=([a-zA-Z0-9_-]{11})');
    // https://www.youtube.com/embed/... format uchun
    final regExp3 = RegExp(r'embed\/([a-zA-Z0-9_-]{11})');

    Match? match = regExp1.firstMatch(url);
    match ??= regExp2.firstMatch(url);
    match ??= regExp3.firstMatch(url);

    if (match != null) {
      return match.group(1);
    }
    return null;
  }

  // YouTube thumbnail olish
  static String getThumbnailUrl(String videoId) {
    return 'https://img.youtube.com/vi/$videoId/maxresdefault.jpg';
  }

  // Sanani formatlash
  static String formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Bugun';
    } else if (difference.inDays == 1) {
      return 'Kecha';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} kun oldin';
    } else if (difference.inDays < 30) {
      return '${(difference.inDays / 7).floor()} hafta oldin';
    } else if (difference.inDays < 365) {
      return '${(difference.inDays / 30).floor()} oy oldin';
    } else {
      return '${date.day}.${date.month}.${date.year}';
    }
  }

  // Video sarlavhasini qisqartirish
  static String formatTitle(String title, {int maxLength = 50}) {
    if (title.length <= maxLength) return title;
    return '${title.substring(0, maxLength)}...';
  }
}