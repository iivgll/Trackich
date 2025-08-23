// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Трэкич';

  @override
  String get dashboard => 'Панель';

  @override
  String get projects => 'Проекты';

  @override
  String get calendar => 'Календарь';

  @override
  String get analytics => 'Аналитика';

  @override
  String get settings => 'Настройки';

  @override
  String get startTimer => 'Запустить таймер';

  @override
  String get pauseTimer => 'Приостановить таймер';

  @override
  String get stopTimer => 'Остановить таймер';

  @override
  String get selectProject => 'Выберите проект...';

  @override
  String get taskDescription => 'Над чем вы работаете?';

  @override
  String get todayActivity => 'Активность сегодня';

  @override
  String get createProject => 'Создать проект';

  @override
  String get projectName => 'Название проекта';

  @override
  String get projectDescription => 'Описание';

  @override
  String get projectColor => 'Цвет проекта';

  @override
  String get save => 'Сохранить';

  @override
  String get cancel => 'Отмена';

  @override
  String get totalHours => 'Всего часов';

  @override
  String get focusScore => 'Оценка фокуса';

  @override
  String get breakCompliance => 'Соблюдение перерывов';

  @override
  String get productivity => 'Продуктивность';

  @override
  String get timeBreakdown => 'Распределение времени';

  @override
  String get productivityTrend => 'Тренд продуктивности';

  @override
  String get weekView => 'Неделя';

  @override
  String get monthView => 'Месяц';

  @override
  String get dayView => 'День';

  @override
  String get general => 'Общие';

  @override
  String get timerAndBreaks => 'Таймер и перерывы';

  @override
  String get notifications => 'Уведомления';

  @override
  String get language => 'Язык';

  @override
  String get theme => 'Тема';

  @override
  String get lightTheme => 'Светлая';

  @override
  String get darkTheme => 'Тёмная';

  @override
  String get systemTheme => 'Системная';

  @override
  String get enableNotifications => 'Включить уведомления';

  @override
  String get workInterval => 'Рабочий интервал';

  @override
  String get shortBreak => 'Короткий перерыв';

  @override
  String get longBreak => 'Длинный перерыв';

  @override
  String get minutes => 'минут';

  @override
  String get takeBreak => 'Сделайте перерыв';

  @override
  String breakTime(String breakType) {
    return 'Время для $breakType перерыва!';
  }

  @override
  String workCompleted(double hours) {
    final intl.NumberFormat hoursNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String hoursString = hoursNumberFormat.format(hours);

    return 'Отличная работа! Вы выполнили $hoursString часов сегодня.';
  }

  @override
  String get breakInterval => 'Интервал перерывов';

  @override
  String breakReminderDescription(int minutes) {
    return 'Напоминания о перерывах каждые $minutes минут';
  }

  @override
  String get breakRemindersToggle => 'Напоминания о перерывах';

  @override
  String get breakRemindersDescription =>
      'Автоматические уведомления о перерывах';

  @override
  String get error => 'Ошибка';

  @override
  String get retry => 'Повторить';

  @override
  String get close => 'Закрыть';

  @override
  String get week => 'Неделя';

  @override
  String get month => 'Месяц';

  @override
  String get quarter => 'Квартал';

  @override
  String get year => 'Год';

  @override
  String get today => 'Сегодня';

  @override
  String get thisWeek => 'На этой неделе';

  @override
  String get thisMonth => 'В этом месяце';

  @override
  String get allTime => 'Все время';

  @override
  String get startSimilarTask => 'Начать похожую задачу';

  @override
  String get continueTask => 'Продолжить задачу';

  @override
  String get project => 'Проект:';

  @override
  String get task => 'Задача:';

  @override
  String get noProjectsAvailable =>
      'Нет доступных проектов. Создайте сначала один.';

  @override
  String get selectProjectHint => 'Выберите проект';

  @override
  String get day => 'День';

  @override
  String get exportingToExcel => 'Экспорт в Excel...';

  @override
  String get exportSuccess => 'Отчет Excel успешно экспортирован!';

  @override
  String exportFailed(String error) {
    return 'Ошибка экспорта: $error';
  }

  @override
  String get errorLoadingProject => 'Ошибка загрузки проекта';

  @override
  String get filterCalendar => 'Фильтр календаря';

  @override
  String get allProjects => 'Все проекты';

  @override
  String get clearAll => 'Очистить все';

  @override
  String get apply => 'Применить';

  @override
  String get clearFilters => 'Очистить фильтры';

  @override
  String get filteredResults => 'Результаты фильтрации';

  @override
  String get english => 'English';

  @override
  String get russian => 'Русский';

  @override
  String get min => 'мин';

  @override
  String get testNotifications => 'Тест уведомлений';

  @override
  String get testNotificationsSubtitle =>
      'Отправить тестовое уведомление для проверки работы системы';

  @override
  String get testNotificationSent =>
      'Тестовое уведомление отправлено! Проверьте центр уведомлений.';

  @override
  String get test => 'Тест';

  @override
  String get request => 'Запросить';

  @override
  String get notificationPermissionsGranted =>
      'Разрешения на уведомления предоставлены!';

  @override
  String get enableNotificationsTitle => 'Включить уведомления';

  @override
  String get enableNotificationsInstructions =>
      'Чтобы включить уведомления для Трэкича:';

  @override
  String get step1 => '1. Откройте настройки устройства';

  @override
  String get step2 =>
      '2. Найдите \"Уведомления\" или \"Приложения и уведомления\"';

  @override
  String get step3 => '3. Найдите \"Trackich\" в списке приложений';

  @override
  String get step4 => '4. Включите уведомления';

  @override
  String get ok => 'ОК';

  @override
  String get hoursPerWeek => 'часов/неделя';

  @override
  String projectCreated(String name) {
    return 'Проект \"$name\" успешно создан!';
  }

  @override
  String errorCreatingProject(String error) {
    return 'Ошибка создания проекта: $error';
  }

  @override
  String get active => 'Активный';

  @override
  String get archived => 'Архивированный';

  @override
  String get deleteProject => 'Удалить проект';

  @override
  String deleteProjectConfirmation(String name) {
    return 'Вы уверены, что хотите удалить \"$name\"? Это действие нельзя отменить, также будут удалены все связанные записи времени.';
  }

  @override
  String projectDeleted(String name) {
    return 'Проект \"$name\" удален';
  }

  @override
  String get delete => 'Удалить';

  @override
  String get edit => 'Редактировать';

  @override
  String get created => 'создан';

  @override
  String get updated => 'обновлен';

  @override
  String projectSelectedMessage(String projectName) {
    return 'Выбран проект $projectName. Введите задачу для запуска таймера.';
  }
}
