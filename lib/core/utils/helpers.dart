import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

class AppHelpers {
  static IconData getTypeIcon(String type) {
    final typeData = AppConstants.contentTypes.firstWhere(
      (t) => t.id == type,
      orElse: () => AppConstants.contentTypes.first,
    );
    switch (typeData.icon) {
      case 'play_circle':
        return Icons.play_circle;
      case 'menu_book':
        return Icons.menu_book;
      case 'picture_as_pdf':
        return Icons.picture_as_pdf;
      case 'book':
        return Icons.book;
      case 'video_library':
        return Icons.video_library;
      case 'headphones':
        return Icons.headphones;
      case 'article':
        return Icons.article;
      case 'podcasts':
        return Icons.podcasts;
      case 'note':
        return Icons.note;
      case 'link':
        return Icons.link;
      default:
        return Icons.library_books;
    }
  }

  static Color getTypeColor(String type) {
    final typeData = AppConstants.contentTypes.firstWhere(
      (t) => t.id == type,
      orElse: () => AppConstants.contentTypes.first,
    );
    return Color(typeData.color);
  }

  static String getTypeName(String type) {
    final typeData = AppConstants.contentTypes.firstWhere(
      (t) => t.id == type,
      orElse: () => AppConstants.contentTypes.first,
    );
    return typeData.name;
  }

  static String getStatusName(String status) {
    final statusData = AppConstants.statuses.firstWhere(
      (s) => s.id == status,
      orElse: () => AppConstants.statuses.first,
    );
    return statusData.name;
  }

  static Color getStatusColor(String status) {
    final statusData = AppConstants.statuses.firstWhere(
      (s) => s.id == status,
      orElse: () => AppConstants.statuses.first,
    );
    return Color(statusData.color);
  }
}
