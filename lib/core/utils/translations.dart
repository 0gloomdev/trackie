import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/providers/providers.dart';

final translationsProvider = Provider<Translations>((ref) {
  final settings = ref.watch(settingsProvider);
  return Translations(settings.locale);
});

class Translations {
  final String locale;

  Translations(this.locale);

  String get dashboard => locale == 'en' ? 'Dashboard' : 'Panel';
  String get library => locale == 'en' ? 'Library' : 'Biblioteca';
  String get courses => locale == 'en' ? 'Courses' : 'Cursos';
  String get achievements => locale == 'en' ? 'Achievements' : 'Logros';
  String get community => locale == 'en' ? 'Community' : 'Comunidad';
  String get notes => locale == 'en' ? 'Notes' : 'Notas';
  String get reminders => locale == 'en' ? 'Reminders' : 'Recordatorios';
  String get help => locale == 'en' ? 'Help' : 'Ayuda';
  String get settings => locale == 'en' ? 'Settings' : 'Ajustes';
  String get analytics => locale == 'en' ? 'Stats' : 'Estadísticas';
  String get timer => locale == 'en' ? 'Timer' : 'Temporizador';

  String get welcomeBack =>
      locale == 'en' ? 'Welcome back' : 'Bienvenido de nuevo';
  String get totalItems => locale == 'en' ? 'Total Saved' : 'Total Guardados';
  String get thisWeek => locale == 'en' ? 'This Week' : 'Esta semana';
  String get offlineSync =>
      locale == 'en' ? 'Offline Sync' : 'Sincronización Offline';
  String get recentItems =>
      locale == 'en' ? 'Recent Items' : 'Elementos Recientes';
  String get weeklyActivity =>
      locale == 'en' ? 'Weekly Activity' : 'Actividad Semanal';

  String get all => locale == 'en' ? 'All' : 'Todos';
  String get books => locale == 'en' ? 'Books' : 'Libros';
  String get videos => locale == 'en' ? 'Videos' : 'Videos';
  String get articles => locale == 'en' ? 'Articles' : 'Artículos';
  String get search => locale == 'en' ? 'Search' : 'Buscar';
  String get noItems =>
      locale == 'en' ? 'No items found' : 'No se encontraron elementos';
  String get addFirst => locale == 'en'
      ? 'Start by adding your first link'
      : 'Comienza agregando tu primer enlace';

  String get completed => locale == 'en' ? 'Completed' : 'Completado';
  String get inProgress => locale == 'en' ? 'In Progress' : 'En progreso';
  String get pending => locale == 'en' ? 'Pending' : 'Pendiente';

  String get save => locale == 'en' ? 'Save' : 'Guardar';
  String get cancel => locale == 'en' ? 'Cancel' : 'Cancelar';
  String get delete => locale == 'en' ? 'Delete' : 'Eliminar';
  String get edit => locale == 'en' ? 'Edit' : 'Editar';
  String get add => locale == 'en' ? 'Add' : 'Agregar';
  String get create => locale == 'en' ? 'Create' : 'Crear';
  String get close => locale == 'en' ? 'Close' : 'Cerrar';

  String get profile => locale == 'en' ? 'Profile' : 'Perfil';
  String get notifications =>
      locale == 'en' ? 'Notifications' : 'Notificaciones';
  String get privacy => locale == 'en' ? 'Privacy' : 'Privacidad';
  String get dataSync =>
      locale == 'en' ? 'Data & Sync' : 'Datos y Sincronización';
  String get appearance => locale == 'en' ? 'Appearance' : 'Apariencia';
  String get theme => locale == 'en' ? 'Theme' : 'Tema';
  String get language => locale == 'en' ? 'Language' : 'Idioma';
  String get dark => locale == 'en' ? 'Dark' : 'Oscuro';
  String get light => locale == 'en' ? 'Light' : 'Claro';
  String get system => locale == 'en' ? 'System' : 'Sistema';
  String get dangerZone => locale == 'en' ? 'Danger Zone' : 'Zona de Peligro';

  String get pomodoro => locale == 'en' ? 'Pomodoro' : 'Pomodoro';
  String get focus => locale == 'en' ? 'Focus' : 'Enfócate';
  String get start => locale == 'en' ? 'Start' : 'Iniciar';
  String get pause => locale == 'en' ? 'Pause' : 'Pausar';
  String get resume => locale == 'en' ? 'Resume' : 'Reanudar';
  String get reset => locale == 'en' ? 'Reset' : 'Reiniciar';
  String get sessionsToday =>
      locale == 'en' ? 'sessions today' : 'sesiones hoy';

  String get newNote => locale == 'en' ? 'New Note' : 'Nueva Nota';
  String get editNote => locale == 'en' ? 'Edit Note' : 'Editar Nota';
  String get noteTitle => locale == 'en' ? 'Note title' : 'Título de la nota';
  String get noteContent =>
      locale == 'en' ? 'Write your note...' : 'Escribe tu nota...';
  String get pinNote => locale == 'en' ? 'Pin note' : 'Fijar nota';
  String get pinned => locale == 'en' ? 'Pinned' : 'Fijadas';
  String get allNotes => locale == 'en' ? 'All Notes' : 'Todas las notas';

  String get newReminder =>
      locale == 'en' ? 'New Reminder' : 'Nuevo Recordatorio';
  String get reminderTitle =>
      locale == 'en' ? 'Reminder title' : 'Título del recordatorio';
  String get dueDate => locale == 'en' ? 'Date & Time' : 'Fecha y hora';
  String get pendingReminders => locale == 'en' ? 'Pending' : 'Pendientes';
  String get completedReminders => locale == 'en' ? 'Completed' : 'Completados';

  String get today => locale == 'en' ? 'Today' : 'Hoy';
  String get yesterday => locale == 'en' ? 'Yesterday' : 'Ayer';
  String get daysAgo => locale == 'en' ? 'days' : 'días';
  String get minutes => locale == 'en' ? 'min' : 'min';
  String get xp => locale == 'en' ? 'XP' : 'XP';
  String get level => locale == 'en' ? 'Level' : 'Nivel';
  String get streak => locale == 'en' ? 'Streak' : 'Racha';

  String get profileTitle => locale == 'en' ? 'Edit Profile' : 'Editar Perfil';
  String get name => locale == 'en' ? 'Name' : 'Nombre';
  String get email => locale == 'en' ? 'Email' : 'Correo';
  String get saveProfile => locale == 'en' ? 'Save Profile' : 'Guardar';

  String get exportData => locale == 'en' ? 'Export Data' : 'Exportar Datos';
  String get importData => locale == 'en' ? 'Import Data' : 'Importar Datos';
  String get autoBackup => locale == 'en' ? 'Auto Backup' : 'Auto Respaldo';
  String get deleteAllData =>
      locale == 'en' ? 'Delete All Data' : 'Borrar Todos los Datos';

  String get enabled => locale == 'en' ? 'Enabled' : 'Activado';
  String get disabled => locale == 'en' ? 'Disabled' : 'Desactivado';
  String get selectTheme =>
      locale == 'en' ? 'Select Theme' : 'Seleccionar Tema';
  String get selectLanguage =>
      locale == 'en' ? 'Select Language' : 'Seleccionar Idioma';

  String get noNotesYet => locale == 'en' ? 'No notes yet' : 'No hay notas aún';
  String get createFirstNote => locale == 'en'
      ? 'Create your first note to get started'
      : 'Crea tu primera nota para comenzar';
  String get createNote => locale == 'en' ? 'Create note' : 'Crear nota';

  String get noRemindersYet =>
      locale == 'en' ? 'No reminders yet' : 'No hay recordatorios';
  String get createReminder =>
      locale == 'en' ? 'Create reminder' : 'Crear recordatorio';
  String get noAchievements =>
      locale == 'en' ? 'No achievements yet' : 'No hay logros aún';
  String get unlockAchievements => locale == 'en'
      ? 'Complete tasks to unlock achievements'
      : 'Completa tareas para desbloquear logros';

  String get course => locale == 'en' ? 'Course' : 'Curso';
  String get video => locale == 'en' ? 'Video' : 'Video';
  String get book => locale == 'en' ? 'Book' : 'Libro';
  String get pdf => locale == 'en' ? 'PDF' : 'PDF';
  String get article => locale == 'en' ? 'Article' : 'Artículo';

  String get myProgress => locale == 'en' ? 'My Progress' : 'Mi Progreso';
  String get statistics => locale == 'en' ? 'Statistics' : 'Estadísticas';
  String get yourActivity =>
      locale == 'en' ? 'Your Activity' : 'Tu actividad y progreso';

  String get quickActions =>
      locale == 'en' ? 'Quick Actions' : 'Acciones Rápidas';
  String get tutorial => locale == 'en' ? 'Tutorial' : 'Tutorial';
  String get contact => locale == 'en' ? 'Contact' : 'Contacto';
  String get rateApp => locale == 'en' ? 'Rate Us' : 'Valoranos';
  String get terms => locale == 'en' ? 'Terms' : 'Términos';
  String get faq => locale == 'en' ? 'FAQ' : 'Preguntas Frecuentes';

  String get newItem => locale == 'en' ? 'New Item' : 'Nuevo Elemento';
  String get itemTitle => locale == 'en' ? 'Item Title' : 'Título del elemento';
  String get description => locale == 'en' ? 'Description' : 'Descripción';
  String get url => locale == 'en' ? 'URL' : 'URL';
  String get status => locale == 'en' ? 'Status' : 'Estado';
  String get progress => locale == 'en' ? 'Progress' : 'Progreso';
  String get tags => locale == 'en' ? 'Tags' : 'Etiquetas';
  String get notes2 => locale == 'en' ? 'Notes' : 'Notas';

  String get focusMode => locale == 'en' ? 'Focus Mode' : 'Modo Enfoque';
  String get ready => locale == 'en' ? 'READY' : 'LISTO';
  String get running => locale == 'en' ? 'RUNNING' : 'EN CURSO';
  String get paused => locale == 'en' ? 'PAUSED' : 'PAUSADO';

  String get itemsCompleted =>
      locale == 'en' ? 'Items completed' : 'Items completados';
  String get daysStreak => locale == 'en' ? 'Days streak' : 'Días de racha';
  String get totalXp => locale == 'en' ? 'Total XP' : 'XP Total';
  String get achievementsUnlocked => locale == 'en' ? 'Achievements' : 'Logros';

  String get general => locale == 'en' ? 'General' : 'General';
  String get data => locale == 'en' ? 'Data' : 'Datos';
  String get security => locale == 'en' ? 'Security' : 'Seguridad';
  String get about => locale == 'en' ? 'About' : 'Acerca de';
  String get version => locale == 'en' ? 'Version' : 'Versión';
  String get help2 => locale == 'en' ? 'Help' : 'Ayuda';

  String get searchInLibrary =>
      locale == 'en' ? 'Search in library...' : 'Buscar en tu biblioteca...';
  String get noResults => locale == 'en' ? 'No results' : 'Sin resultados';
  String get typeToSearch =>
      locale == 'en' ? 'Type to search' : 'Escribe para buscar';

  String get addYourFirst =>
      locale == 'en' ? 'Add your first' : 'Agrega tu primer';
  String get toGetStarted =>
      locale == 'en' ? 'to get started' : 'para comenzar';
}
