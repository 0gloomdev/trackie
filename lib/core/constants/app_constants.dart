class AppConstants {
  static const String appName = 'Trackie';
  static const String appVersion = '1.0.0';

  static const List<int> tagColors = [
    0xFF6366F1,
    0xFFEC4899,
    0xFF10B981,
    0xFFF59E0B,
    0xFF3B82F6,
    0xFF8B5CF6,
    0xFF14B8A6,
    0xFFF97316,
  ];

  static const List<ContentType> contentTypes = [
    ContentType(
      id: 'course',
      name: 'Course',
      icon: 'play_circle',
      color: 0xFF6366F1,
    ),
    ContentType(id: 'book', name: 'Book', icon: 'menu_book', color: 0xFF8B4513),
    ContentType(
      id: 'pdf',
      name: 'PDF',
      icon: 'picture_as_pdf',
      color: 0xFFE53935,
    ),
    ContentType(id: 'epub', name: 'EPUB', icon: 'book', color: 0xFF43A047),
    ContentType(
      id: 'video',
      name: 'Video',
      icon: 'video_library',
      color: 0xFFFF5722,
    ),
    ContentType(
      id: 'audio',
      name: 'Audio',
      icon: 'headphones',
      color: 0xFF00BCD4,
    ),
    ContentType(
      id: 'article',
      name: 'Article',
      icon: 'article',
      color: 0xFF9C27B0,
    ),
    ContentType(
      id: 'podcast',
      name: 'Podcast',
      icon: 'podcasts',
      color: 0xFFFF9800,
    ),
    ContentType(id: 'note', name: 'Note', icon: 'note', color: 0xFF607D8B),
    ContentType(id: 'link', name: 'Link', icon: 'link', color: 0xFF2196F3),
    ContentType(
      id: 'tutorial',
      name: 'Tutorial',
      icon: 'build',
      color: 0xFF00BCD4,
    ),
    ContentType(
      id: 'doc',
      name: 'Documentation',
      icon: 'description',
      color: 0xFF3F51B5,
    ),
    ContentType(
      id: 'workshop',
      name: 'Workshop',
      icon: 'groups',
      color: 0xFF009688,
    ),
    ContentType(
      id: 'bootcamp',
      name: 'Bootcamp',
      icon: 'military_tech',
      color: 0xFFE91E63,
    ),
    ContentType(
      id: 'certification',
      name: 'Certification',
      icon: 'verified',
      color: 0xFFCDDC39,
    ),
    ContentType(
      id: 'project',
      name: 'Project',
      icon: 'folder_special',
      color: 0xFF9C27B0,
    ),
  ];

  static const List<ContentStatus> statuses = [
    ContentStatus(id: 'pending', name: 'Por empezar', color: 0xFF9E9E9E),
    ContentStatus(id: 'in_progress', name: 'En progreso', color: 0xFFFF9800),
    ContentStatus(id: 'completed', name: 'Completado', color: 0xFF4CAF50),
    ContentStatus(id: 'paused', name: 'Pausado', color: 0xFF795548),
    ContentStatus(id: 'archived', name: 'Archivado', color: 0xFF607D8B),
  ];

  static const List<Priority> priorities = [
    Priority(id: 'low', name: 'Baja', color: 0xFF4CAF50),
    Priority(id: 'medium', name: 'Media', color: 0xFFFF9800),
    Priority(id: 'high', name: 'Alta', color: 0xFFF44336),
  ];

  static const List<OnboardingStep> onboardingSteps = [
    OnboardingStep(
      title: 'Welcome to Trackie',
      description: 'Your personal learning hub',
      icon: 'school',
    ),
    OnboardingStep(
      title: 'Add your content',
      description: 'Courses, books, PDFs, podcasts and more',
      icon: 'add_circle',
    ),
    OnboardingStep(
      title: 'Organize with tags',
      description: 'Create custom categories and tags',
      icon: 'label',
    ),
    OnboardingStep(
      title: 'Track your progress',
      description: 'Visualize your progress with statistics',
      icon: 'trending_up',
    ),
    OnboardingStep(
      title: 'Ready to learn!',
      description: 'Start your learning journey',
      icon: 'celebration',
    ),
  ];
}

class ContentType {
  final String id;
  final String name;
  final String icon;
  final int color;
  const ContentType({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
  });
}

class ContentStatus {
  final String id;
  final String name;
  final int color;
  const ContentStatus({
    required this.id,
    required this.name,
    required this.color,
  });
}

class Priority {
  final String id;
  final String name;
  final int color;
  const Priority({required this.id, required this.name, required this.color});
}

class OnboardingStep {
  final String title;
  final String description;
  final String icon;
  const OnboardingStep({
    required this.title,
    required this.description,
    required this.icon,
  });
}
