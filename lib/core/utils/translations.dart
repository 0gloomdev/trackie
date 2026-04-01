import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/providers/providers.dart';

final translationsProvider = Provider<Translations>((ref) {
  final settings = ref.watch(settingsProvider);
  return Translations(settings.locale);
});

class Translations {
  final String locale;

  Translations(this.locale);

  String get dashboard => 'Dashboard';
  String get library => 'Library';
  String get courses => 'Courses';
  String get achievements => 'Achievements';
  String get community => 'Community';
  String get notes => 'Notes';
  String get reminders => 'Reminders';
  String get help => 'Help';
  String get settings => 'Settings';
  String get analytics => 'Stats';
  String get timer => 'Timer';

  String get welcomeBack => 'Welcome back';
  String get totalItems => 'Total Saved';
  String get thisWeek => 'This Week';
  String get offlineSync => 'Offline Sync';
  String get recentItems => 'Recent Items';
  String get weeklyActivity => 'Weekly Activity';

  String get all => 'All';
  String get books => 'Books';
  String get videos => 'Videos';
  String get articles => 'Articles';
  String get search => 'Search';
  String get noItems => 'No items found';
  String get addFirst => 'Start by adding your first link';

  String get completed => 'Completed';
  String get inProgress => 'In Progress';
  String get pending => 'Pending';

  String get save => 'Save';
  String get cancel => 'Cancel';
  String get delete => 'Delete';
  String get edit => 'Edit';
  String get add => 'Add';
  String get create => 'Create';
  String get close => 'Close';

  String get profile => 'Profile';
  String get notifications => 'Notifications';
  String get privacy => 'Privacy';
  String get dataSync => 'Data & Sync';
  String get appearance => 'Appearance';
  String get theme => 'Theme';
  String get language => 'Language';
  String get dark => 'Dark';
  String get light => 'Light';
  String get system => 'System';
  String get dangerZone => 'Danger Zone';

  String get pomodoro => 'Pomodoro';
  String get focus => 'Focus';
  String get start => 'Start';
  String get pause => 'Pause';
  String get resume => 'Resume';
  String get reset => 'Reset';
  String get sessionsToday => 'sessions today';

  String get newNote => 'New Note';
  String get editNote => 'Edit Note';
  String get noteTitle => 'Note title';
  String get noteContent => 'Write your note...';
  String get pinNote => 'Pin note';
  String get pinned => 'Pinned';
  String get allNotes => 'All Notes';

  String get newReminder => 'New Reminder';
  String get reminderTitle => 'Reminder title';
  String get dueDate => 'Date & Time';
  String get pendingReminders => 'Pending';
  String get completedReminders => 'Completed';

  String get today => 'Today';
  String get yesterday => 'Yesterday';
  String get daysAgo => 'days';
  String get minutes => 'min';
  String get xp => 'XP';
  String get level => 'Level';
  String get streak => 'Streak';

  String get profileTitle => 'Edit Profile';
  String get name => 'Name';
  String get email => 'Email';
  String get saveProfile => 'Save Profile';

  String get exportData => 'Export Data';
  String get importData => 'Import Data';
  String get autoBackup => 'Auto Backup';
  String get deleteAllData => 'Delete All Data';

  String get enabled => 'Enabled';
  String get disabled => 'Disabled';
  String get selectTheme => 'Select Theme';
  String get selectLanguage => 'Select Language';

  String get noNotesYet => 'No notes yet';
  String get createFirstNote => 'Create your first note to get started';
  String get createNote => 'Create note';

  String get noRemindersYet => 'No reminders yet';
  String get createReminder => 'Create reminder';
  String get noAchievements => 'No achievements yet';
  String get unlockAchievements => 'Complete tasks to unlock achievements';

  String get course => 'Course';
  String get video => 'Video';
  String get book => 'Book';
  String get pdf => 'PDF';
  String get article => 'Article';

  String get myProgress => 'My Progress';
  String get statistics => 'Statistics';
  String get yourActivity => 'Your Activity';

  String get quickActions => 'Quick Actions';
  String get tutorial => 'Tutorial';
  String get contact => 'Contact';
  String get rateApp => 'Rate Us';
  String get terms => 'Terms';
  String get faq => 'FAQ';

  String get newItem => 'New Item';
  String get itemTitle => 'Item Title';
  String get description => 'Description';
  String get url => 'URL';
  String get status => 'Status';
  String get progress => 'Progress';
  String get tags => 'Tags';
  String get notes2 => 'Notes';

  String get focusMode => 'Focus Mode';
  String get ready => 'READY';
  String get running => 'RUNNING';
  String get paused => 'PAUSED';

  String get itemsCompleted => 'Items completed';
  String get daysStreak => 'Days streak';
  String get totalXp => 'Total XP';
  String get achievementsUnlocked => 'Achievements';

  String get general => 'General';
  String get data => 'Data';
  String get security => 'Security';
  String get about => 'About';
  String get version => 'Version';
  String get help2 => 'Help';

  String get searchInLibrary => 'Search in library...';
  String get noResults => 'No results';
  String get typeToSearch => 'Type to search';

  String get addYourFirst => 'Add your first';
  String get toGetStarted => 'to get started';
}
