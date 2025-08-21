// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Trackich';

  @override
  String get dashboard => 'Панель';

  @override
  String get calendar => 'Календарь';

  @override
  String get projects => 'Проекты';

  @override
  String get analytics => 'Аналитика';

  @override
  String get settings => 'Настройки';

  @override
  String get startTask => 'Начать задачу';

  @override
  String get pauseTask => 'Пауза';

  @override
  String get resumeTask => 'Продолжить';

  @override
  String get stopTask => 'Стоп';

  @override
  String workingOn(String taskName) {
    return 'Работаю над: $taskName';
  }

  @override
  String get project => 'Проект';

  @override
  String get selectProject => 'Выберите проект';

  @override
  String get taskName => 'Название задачи...';

  @override
  String get addNote => 'Добавить заметку';

  @override
  String get todaysSummary => 'Сводка за сегодня';

  @override
  String todayWorked(String duration) {
    return 'Сегодня: $duration работы';
  }

  @override
  String tasksCompleted(int count) {
    return '$count задач выполнено';
  }

  @override
  String breaksTaken(int count) {
    return '$count перерывов сделано';
  }

  @override
  String goal(String goal, int percentage) {
    return 'Цель: $goal ($percentage% выполнено)';
  }

  @override
  String get recentTasks => 'Недавние задачи';

  @override
  String get viewAllTasks => 'Посмотреть все задачи...';

  @override
  String get newProject => 'Новый проект';

  @override
  String activeProjects(int count, int archived) {
    return '$count активных, $archived архивных';
  }

  @override
  String thisWeek(String duration) {
    return 'На этой неделе: $duration';
  }

  @override
  String lastActivity(String time) {
    return 'Последняя активность: $time';
  }

  @override
  String get edit => 'Редактировать';

  @override
  String get archive => 'Архивировать';

  @override
  String get viewTasks => 'Посмотреть задачи';

  @override
  String get general => 'Основные';

  @override
  String get language => 'Язык';

  @override
  String get theme => 'Тема';

  @override
  String get timeFormat => 'Формат времени';

  @override
  String get weekStartsOn => 'Неделя начинается с';

  @override
  String get defaultProject => 'Проект по умолчанию';

  @override
  String get breakConfiguration => 'Настройка перерывов';

  @override
  String get workSessionDuration => 'Длительность рабочей сессии';

  @override
  String get shortBreakDuration => 'Длительность короткого перерыва';

  @override
  String get longBreakDuration => 'Длительность длинного перерыва';

  @override
  String get longBreakInterval => 'Интервал длинного перерыва';

  @override
  String get enableBreakNotifications => 'Включить уведомления о перерывах';

  @override
  String get notificationSound => 'Звук уведомления';

  @override
  String get testSound => 'Проверить звук';

  @override
  String get notifications => 'Уведомления';

  @override
  String get systemNotifications => 'Системные уведомления';

  @override
  String get breakReminders => 'Напоминания о перерывах';

  @override
  String get dailySummary => 'Дневная сводка';

  @override
  String get quietHours => 'Тихие часы';

  @override
  String get dataManagement => 'Управление данными';

  @override
  String get exportData => 'Экспорт данных';

  @override
  String get importData => 'Импорт данных';

  @override
  String get clearAllData => 'Очистить все данные';

  @override
  String get storageUsed => 'Использовано места';

  @override
  String get english => 'Английский';

  @override
  String get russian => 'Русский';

  @override
  String get light => 'Светлая';

  @override
  String get dark => 'Темная';

  @override
  String get system => 'Системная';

  @override
  String get hour12 => '12-часовой';

  @override
  String get hour24 => '24-часовой';

  @override
  String get monday => 'Понедельник';

  @override
  String get sunday => 'Воскресенье';

  @override
  String get minutes => 'минут';

  @override
  String get sessions => 'сессий';

  @override
  String get enabled => 'Включено';

  @override
  String get disabled => 'Выключено';

  @override
  String get today => 'Сегодня';

  @override
  String get week => 'Неделя';

  @override
  String get month => 'Месяц';

  @override
  String total(String duration) {
    return 'Всего: $duration';
  }

  @override
  String get takeBreak => 'Сделать перерыв';

  @override
  String shortBreak(String duration) {
    return 'Короткий перерыв ($duration)';
  }

  @override
  String longBreak(String duration) {
    return 'Длинный перерыв ($duration)';
  }

  @override
  String get customDuration => 'Своя длительность';

  @override
  String get justPause => 'Просто пауза';

  @override
  String get readyToResume => 'Готовы продолжить?';

  @override
  String resume(String taskName) {
    return 'Продолжить $taskName';
  }

  @override
  String get startNewTask => 'Начать новую задачу';

  @override
  String get extendBreak => 'Продлить перерыв';

  @override
  String get quickStart => 'Быстрый старт';

  @override
  String get startTimer => 'Запустить таймер';

  @override
  String get enterTaskName => 'Введите название задачи...';

  @override
  String get errorLoadingProjects => 'Ошибка загрузки проектов';

  @override
  String get noRecentTasks => 'Нет недавних задач';

  @override
  String get todaySummary => 'Сводка за сегодня';

  @override
  String get timeWorked => 'Время работы';

  @override
  String get dailyGoalProgress => 'Прогресс дневной цели';

  @override
  String get complete => 'завершено';

  @override
  String get breakTime => 'Время перерывов';

  @override
  String get breaks => 'Перерывы';

  @override
  String get currentTime => 'Текущее время';

  @override
  String get noTasksToday => 'Сегодня не работали над задачами';

  @override
  String get projectBreakdown => 'Разбивка по проектам';
}
