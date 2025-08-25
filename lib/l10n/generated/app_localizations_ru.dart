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
  String get breakTime => 'Время перерывов';

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
  String get created => 'Создан';

  @override
  String get updated => 'обновлен';

  @override
  String projectSelectedMessage(String projectName) {
    return 'Выбран проект $projectName. Введите задачу для запуска таймера.';
  }

  @override
  String get appName => 'Трэкич';

  @override
  String get noDataForPeriod => 'Нет данных за этот период';

  @override
  String get startTrackingMessage =>
      'Начните отслеживать время, чтобы увидеть аналитику';

  @override
  String get keyMetrics => 'Ключевые метрики';

  @override
  String get totalWorkTime => 'Общее время работы';

  @override
  String get tasksCompleted => 'Задач выполнено';

  @override
  String get projectBreakdown => 'Разбивка по проектам';

  @override
  String get dailyActivity => 'Дневная активность';

  @override
  String get enableAppNotifications => 'Включить уведомления приложения';

  @override
  String get notificationPermissionsRequired =>
      'Требуются разрешения на уведомления';

  @override
  String get notificationsEnabled => 'Уведомления включены';

  @override
  String get notificationsEnabledDescription =>
      'Системные уведомления работают корректно';

  @override
  String get refreshStatus => 'Обновить статус';

  @override
  String get notificationsDisabled => 'Уведомления отключены';

  @override
  String get notificationsDisabledDescription =>
      'Включите в настройках системы для получения уведомлений';

  @override
  String get permissionRequired => 'Требуется разрешение';

  @override
  String get permissionRequiredDescription =>
      'Нажмите для запроса разрешений на уведомления';

  @override
  String get morning => 'утром';

  @override
  String get afternoon => 'днём';

  @override
  String get evening => 'вечером';

  @override
  String get yesterday => 'Вчера';

  @override
  String get errorLoadingTasks => 'Ошибка загрузки задач';

  @override
  String get recentActivity => 'Недавняя активность';

  @override
  String get noTasksToday => 'Нет задач на сегодня';

  @override
  String get startTimerToTrack => 'Запустите таймер для отслеживания работы';

  @override
  String get noTasksThisWeek => 'Нет задач на этой неделе';

  @override
  String get recentActivityWillAppear =>
      'Ваша недавняя активность появится здесь';

  @override
  String get noTasksThisMonth => 'Нет задач в этом месяце';

  @override
  String get monthlyActivityWillAppear =>
      'Ваша месячная активность появится здесь';

  @override
  String get noTasksFound => 'Задачи не найдены';

  @override
  String get startTrackingToSeeActivity =>
      'Начните отслеживать время, чтобы увидеть активность';

  @override
  String get totalTime => 'Общее время';

  @override
  String get sessions => 'Сессии';

  @override
  String get lastActivity => 'Последняя активность';

  @override
  String get averagePerSession => 'Среднее за сессию';

  @override
  String get goodMorning => 'Доброе утро';

  @override
  String get goodAfternoon => 'Добрый день';

  @override
  String get goodEvening => 'Добрый вечер';

  @override
  String get timeForBreakTitle => 'Время для перерыва!';

  @override
  String breakReminderBody(String projectText, int workMinutes) {
    return 'Вы работали$projectText уже $workMinutes мин. Рассмотрите возможность сделать короткий перерыв для поддержания продуктивности.';
  }

  @override
  String get backToWorkTitle => 'Перерыв закончен!';

  @override
  String workReminderBody(int breakMinutes) {
    return 'Вы на перерыве уже $breakMinutes минут. Готовы вернуться к работе?';
  }

  @override
  String get taskCompletedTitle => 'Задача выполнена!';

  @override
  String taskCompletedBody(String taskName, String projectName, int minutes) {
    return 'Отличная работа! Вы выполнили \"$taskName\" в $projectName за $minutes мин сосредоточенной работы.';
  }

  @override
  String get testNotificationTitle => 'Тестовое уведомление';

  @override
  String get testNotificationBody =>
      'Это тестовое уведомление для проверки правильности работы уведомлений.';

  @override
  String get skip => 'Пропустить';

  @override
  String get notificationPermissionTitle => 'Включить уведомления';

  @override
  String get notificationPermissionBody =>
      'Получайте напоминания о перерывах и оставайтесь продуктивными с своевременными уведомлениями. Вы можете изменить эту настройку позже в Настройках.';

  @override
  String get archiveProject => 'Архивировать проект';

  @override
  String get unarchiveProject => 'Восстановить проект';

  @override
  String get archiveProjectConfirmTitle => 'Архивировать проект?';

  @override
  String get archiveProjectConfirmMessage =>
      'Вы уверены, что хотите архивировать этот проект? Все активные таймеры для этого проекта будут остановлены.';

  @override
  String get unarchiveProjectConfirmTitle => 'Восстановить проект?';

  @override
  String get unarchiveProjectConfirmMessage =>
      'Этот проект будет восстановлен в список активных проектов.';

  @override
  String get activeTimerWillBeStopped =>
      'Внимание: Для этого проекта работает активный таймер. Он будет автоматически остановлен при архивировании проекта.';

  @override
  String get notificationPermissionDenied =>
      'Разрешение на уведомления отклонено. Вы можете включить их позже в Настройках.';

  @override
  String get errorOccurred => 'Произошла ошибка. Попробуйте еще раз.';

  @override
  String get focusTimer => 'Таймер фокуса';

  @override
  String get running => 'Запущен';

  @override
  String get paused => 'Приостановлен';

  @override
  String previousSession(String previousTime, String sessionTime) {
    return 'Ранее: $previousTime + Сессия: $sessionTime';
  }

  @override
  String get resumeTimer => 'Возобновить таймер';

  @override
  String get errorLoadingProjects => 'Ошибка загрузки проектов';

  @override
  String get createNewProject => 'Создать новый проект';

  @override
  String get noProjectsYet => 'Проектов пока нет';

  @override
  String get createFirstProject =>
      'Создайте свой первый проект, чтобы начать отслеживать время';

  @override
  String get taskWillBeContinued => 'Эта задача будет продолжена';

  @override
  String continueTaskPreviousTime(String previousTime) {
    return 'Продолжить задачу - Предыдущее время: $previousTime';
  }

  @override
  String get noProjectsFound => 'Проекты не найдены';

  @override
  String get tryAdjustingSearch => 'Попробуйте изменить условия поиска';

  @override
  String get createFirstProjectToStart =>
      'Создайте свой первый проект, чтобы начать';

  @override
  String get enterProjectName => 'Введите название проекта';

  @override
  String get projectNameRequired => 'Название проекта обязательно';

  @override
  String get enterProjectDescription => 'Введите описание проекта';

  @override
  String get enterTagsCommaSeparated => 'Введите теги через запятую';

  @override
  String get pleaseEnterValidNumber => 'Пожалуйста, введите корректное число';

  @override
  String get description => 'Описание';

  @override
  String get statistics => 'Статистика';

  @override
  String get lastActive => 'Последняя активность';

  @override
  String get weeklyTarget => 'Недельная цель';

  @override
  String get tags => 'Теги';
}
