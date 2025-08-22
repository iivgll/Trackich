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
}
