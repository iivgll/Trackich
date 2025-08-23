# Техническое задание: Переделка дизайна Trackich в стиле Apple

## Анализ текущего состояния дизайна

### Выявленные проблемы:

1. **Цветовая палитра**:
   - Устаревшие и "пестрящие" цвета (#BBACC1, #F1DEDE, #49E448)
   - Отсутствие системы семантических цветов
   - Неконсистентность между светлой и темной темой

2. **Типографика**:
   - Использование SF Pro Display как основного шрифта (хорошо)
   - Неоптимальные размеры и веса текста
   - Отсутствие четкой иерархии

3. **Компоненты**:
   - Устаревшие стили кнопок и карточек
   - Отсутствие системы elevation/depth
   - Несогласованные отступы и размеры

4. **Анимации**:
   - Слишком быстрые переходы (150ms)
   - Отсутствие easing curves в стиле Apple

## Целевой Apple-стиль

### Принципы дизайна:
- Минимализм и чистота
- Нативный внешний вид
- Плавные анимации с правильным easing
- Богатая, но сдержанная цветовая палитра
- Профессиональные пропорции

## Техническое задание по компонентам

### 1. Обновление цветовой палитры

**Файл**: `/Users/ivan/dev/utils/trackich/lib/core/theme/app_theme.dart`

#### 1.1 Новые цвета для светлой темы:

```dart
// ЗАМЕНИТЬ существующие цвета на:

// Light Theme Colors - Apple-inspired Clean Palette
static const Color lightPrimary = Color(0xFF007AFF);        // iOS Blue
static const Color lightPrimaryVariant = Color(0xFF5856D6);  // iOS Purple  
static const Color lightSecondary = Color(0xFF32D74B);      // iOS Green
static const Color lightAccent = Color(0xFFFF9500);         // iOS Orange

// Light Theme Backgrounds
static const Color lightBackground = Color(0xFFFAFAFA);     // System background
static const Color lightSurface = Color(0xFFFFFFFF);       // Card surface
static const Color lightSurfaceSecondary = Color(0xFFF2F2F7); // Secondary background
static const Color lightSurfaceGrouped = Color(0xFFF2F2F7);   // Grouped background

// Light Theme Text
static const Color lightText = Color(0xFF000000);           // Primary text
static const Color lightTextSecondary = Color(0xFF3C3C43);  // Secondary text 
static const Color lightTextTertiary = Color(0xFF6D6D7A);   // Tertiary text
static const Color lightTextQuaternary = Color(0xFF8E8E93); // Quaternary text

// Light Theme Separators
static const Color lightSeparator = Color(0x3C3C4336);      // Separator
static const Color lightSeparatorOpaque = Color(0xFFC6C6C8); // Opaque separator
```

#### 1.2 Новые цвета для темной темы:

```dart
// Dark Theme Colors - Apple Dark Mode
static const Color darkPrimary = Color(0xFF0A84FF);         // iOS Dark Blue
static const Color darkPrimaryVariant = Color(0xFF5E5CE6);   // iOS Dark Purple
static const Color darkSecondary = Color(0xFF30D158);       // iOS Dark Green
static const Color darkAccent = Color(0xFFFF9F0A);          // iOS Dark Orange

// Dark Theme Backgrounds  
static const Color darkBackground = Color(0xFF000000);      // System background
static const Color darkSurface = Color(0xFF1C1C1E);        // Card surface
static const Color darkSurfaceSecondary = Color(0xFF2C2C2E); // Secondary surface
static const Color darkSurfaceGrouped = Color(0xFF000000);    // Grouped background

// Dark Theme Text
static const Color darkText = Color(0xFFFFFFFF);            // Primary text
static const Color darkTextSecondary = Color(0xFFEBEBF5);   // Secondary text
static const Color darkTextTertiary = Color(0xFF9999A3);    // Tertiary text  
static const Color darkTextQuaternary = Color(0xFF6D6D7A);  // Quaternary text

// Dark Theme Separators
static const Color darkSeparator = Color(0x54545458);       // Separator
static const Color darkSeparatorOpaque = Color(0xFF38383A); // Opaque separator
```

### 2. Обновление типографики

**В файле**: `/Users/ivan/dev/utils/trackich/lib/core/theme/app_theme.dart`

```dart
// ЗАМЕНИТЬ текущие TextTheme на:

// Apple Typography Scale
static const TextTheme lightTextTheme = TextTheme(
  // Large Title - 34pt Regular
  displayLarge: TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 34,
    fontWeight: FontWeight.w400,
    height: 1.2,
    letterSpacing: 0.37,
    color: lightText,
  ),
  
  // Title 1 - 28pt Regular  
  displayMedium: TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 28,
    fontWeight: FontWeight.w400,
    height: 1.29,
    letterSpacing: 0.36,
    color: lightText,
  ),
  
  // Title 2 - 22pt Regular
  headlineMedium: TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 22,
    fontWeight: FontWeight.w400,
    height: 1.27,
    letterSpacing: 0.35,
    color: lightText,
  ),
  
  // Title 3 - 20pt Regular
  headlineSmall: TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w400,
    height: 1.25,
    letterSpacing: 0.38,
    color: lightText,
  ),
  
  // Headline - 17pt Semibold
  titleLarge: TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 17,
    fontWeight: FontWeight.w600,
    height: 1.29,
    letterSpacing: -0.41,
    color: lightText,
  ),
  
  // Body - 17pt Regular
  bodyLarge: TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 17,
    fontWeight: FontWeight.w400,
    height: 1.29,
    letterSpacing: -0.41,
    color: lightText,
  ),
  
  // Callout - 16pt Regular
  titleMedium: TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.31,
    letterSpacing: -0.32,
    color: lightText,
  ),
  
  // Subhead - 15pt Regular
  bodyMedium: TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 15,
    fontWeight: FontWeight.w400,
    height: 1.33,
    letterSpacing: -0.24,
    color: lightTextSecondary,
  ),
  
  // Footnote - 13pt Regular
  bodySmall: TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 13,
    fontWeight: FontWeight.w400,
    height: 1.38,
    letterSpacing: -0.08,
    color: lightTextSecondary,
  ),
  
  // Caption 1 - 12pt Regular
  labelMedium: TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.33,
    letterSpacing: 0,
    color: lightTextSecondary,
  ),
  
  // Caption 2 - 11pt Regular
  labelSmall: TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 11,
    fontWeight: FontWeight.w400,
    height: 1.36,
    letterSpacing: 0.07,
    color: lightTextSecondary,
  ),
);
```

### 3. Обновление компонентов

#### 3.1 Кнопки

**В файле**: `/Users/ivan/dev/utils/trackich/lib/core/theme/app_theme.dart`

```dart
// ЗАМЕНИТЬ ElevatedButtonThemeData на:
elevatedButtonTheme: ElevatedButtonThemeData(
  style: ElevatedButton.styleFrom(
    backgroundColor: lightPrimary,
    foregroundColor: Colors.white,
    disabledBackgroundColor: lightTextQuaternary,
    disabledForegroundColor: lightTextTertiary,
    elevation: 0,
    shadowColor: Colors.transparent,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10), // Apple corner radius
    ),
    padding: const EdgeInsets.symmetric(
      horizontal: 20,
      vertical: 13, // Apple button height ~44pt
    ),
    minimumSize: const Size(44, 44), // Apple minimum tap target
    textStyle: const TextStyle(
      fontFamily: primaryFontFamily,
      fontSize: 17,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.41,
    ),
  ),
),
```

#### 3.2 Карточки

```dart
// ЗАМЕНИТЬ CardTheme на:
cardTheme: CardThemeData(
  color: lightSurface,
  elevation: 0,
  shadowColor: Colors.transparent,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12), // Apple card radius
    side: BorderSide(
      color: lightSeparator,
      width: 0.33, // Apple border width
    ),
  ),
  margin: EdgeInsets.zero,
),
```

#### 3.3 Поля ввода

```dart
// ЗАМЕНИТЬ InputDecorationTheme на:
inputDecorationTheme: InputDecorationTheme(
  filled: true,
  fillColor: lightSurface,
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(
      color: lightSeparatorOpaque,
      width: 0.33,
    ),
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(
      color: lightSeparatorOpaque,
      width: 0.33,
    ),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(
      color: lightPrimary,
      width: 1.0,
    ),
  ),
  contentPadding: const EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 16, // Apple input padding
  ),
  hintStyle: TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 17,
    fontWeight: FontWeight.w400,
    color: lightTextTertiary,
    height: 1.29,
  ),
),
```

### 4. Обновление анимаций

**В файле**: `/Users/ivan/dev/utils/trackich/lib/core/theme/app_theme.dart`

```dart
// ЗАМЕНИТЬ Animation Durations на:
// Apple-style Animation System
static const Duration animationFast = Duration(milliseconds: 200);
static const Duration animationMedium = Duration(milliseconds: 300);
static const Duration animationSlow = Duration(milliseconds: 500);
static const Duration animationExtraSlow = Duration(milliseconds: 700);

// Apple Easing Curves
static const Curve easeInOut = Curves.easeInOut;
static const Curve easeOut = Curves.easeOut; 
static const Curve easeInOutQuint = Cubic(0.86, 0, 0.07, 1);
static const Curve springCurve = Curves.elasticOut;
```

### 5. Обновление пространственной системы

```dart
// ЗАМЕНИТЬ Spacing System на Apple-стиль:
// Apple Spacing System (4pt base unit)
static const double space1 = 2;   // Extra tight
static const double space2 = 4;   // Tight  
static const double space3 = 8;   // Small
static const double space4 = 12;  // Medium-small
static const double space5 = 16;  // Medium (standard)
static const double space6 = 20;  // Medium-large
static const double space7 = 24;  // Large
static const double space8 = 32;  // Extra large
static const double space9 = 40;  // Extra extra large
static const double space10 = 48; // Huge

// Apple Border Radius System
static const double radiusTight = 6;
static const double radiusSmall = 8;
static const double radiusMedium = 10;
static const double radiusLarge = 12; 
static const double radiusXLarge = 16;
static const double radiusFull = 9999;
```

### 6. Изменения в конкретных файлах

#### 6.1 MainScreen - Сайдбар

**Файл**: `/Users/ivan/dev/utils/trackich/lib/presentation/screens/main_screen.dart`

**Изменения в методе `_AdaptiveSidebar.build()`**:

```dart
// ЗАМЕНИТЬ Container decoration на:
decoration: BoxDecoration(
  color: Theme.of(context).brightness == Brightness.light
      ? AppTheme.lightSurfaceGrouped
      : AppTheme.darkSurfaceGrouped,
  border: Border(
    right: BorderSide(
      color: Theme.of(context).brightness == Brightness.light
          ? AppTheme.lightSeparator
          : AppTheme.darkSeparator,
      width: 0.33, // Apple border width
    ),
  ),
),
```

**В методе `_buildNavigationItems()`**:

```dart
// ЗАМЕНИТЬ navigation item styling на:
child: Container(
  height: 44, // Apple list row height
  padding: EdgeInsets.symmetric(
    horizontal: isCompact ? AppTheme.space3 : AppTheme.space5,
    vertical: 0,
  ),
  decoration: BoxDecoration(
    color: isSelected
        ? AppTheme.getPrimaryColor(context).withOpacity(0.12)
        : Colors.transparent,
    borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
  ),
  // ... rest of navigation item
),
```

#### 6.2 DashboardScreen - Карточки и макет

**Файл**: `/Users/ivan/dev/utils/trackich/lib/presentation/widgets/dashboard/dashboard_screen.dart`

**Изменить отступы и стиль карточек**:

```dart
// ЗАМЕНИТЬ padding на:
padding: const EdgeInsets.all(AppTheme.space5), // 16px

// ЗАМЕНИТЬ header container decoration на:
decoration: BoxDecoration(
  color: Theme.of(context).brightness == Brightness.light 
      ? AppTheme.lightSurface 
      : AppTheme.darkSurface,
  borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
  border: Border.all(
    color: Theme.of(context).brightness == Brightness.light 
        ? AppTheme.lightSeparator 
        : AppTheme.darkSeparator,
    width: 0.33,
  ),
),
```

#### 6.3 TimerWidget - Дизайн таймера

**Файл**: `/Users/ivan/dev/utils/trackich/lib/presentation/widgets/dashboard/widgets/timer_widget.dart`

**Обновить стиль главного таймера**:

```dart
// ЗАМЕНИТЬ timer display container на:
decoration: BoxDecoration(
  color: Theme.of(context).brightness == Brightness.light
      ? AppTheme.lightSurfaceSecondary
      : AppTheme.darkSurfaceSecondary,
  borderRadius: BorderRadius.circular(AppTheme.radiusXLarge),
  border: timer.isActive && timer.state == TimerState.running
      ? Border.all(
          color: AppTheme.getPrimaryColor(context).withOpacity(0.3),
          width: 1.0,
        )
      : Border.all(
          color: Theme.of(context).brightness == Brightness.light
              ? AppTheme.lightSeparator
              : AppTheme.darkSeparator,
          width: 0.33,
        ),
),
```

#### 6.4 ProjectsScreen - Карточки проектов

**Файл**: `/Users/ivan/dev/utils/trackich/lib/presentation/widgets/projects/projects_screen.dart`

**Обновить стиль карточек проектов**:

```dart
// В _ProjectCard.build(), ЗАМЕНИТЬ Card на:
Card(
  elevation: 0,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
    side: BorderSide(
      color: Theme.of(context).brightness == Brightness.light
          ? AppTheme.lightSeparator
          : AppTheme.darkSeparator,
      width: 0.33,
    ),
  ),
  child: InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
    // ...
  ),
),
```

### 7. Анимации и переходы

#### 7.1 Добавить плавные анимации

**Создать файл**: `/Users/ivan/dev/utils/trackich/lib/core/animations/apple_transitions.dart`

```dart
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AppleTransitions {
  // Apple-style page transition
  static Widget slideTransition(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return SlideTransition(
      position: animation.drive(
        Tween<Offset>(
          begin: const Offset(1.0, 0.0),
          end: Offset.zero,
        ).chain(
          CurveTween(curve: AppTheme.easeInOutQuint),
        ),
      ),
      child: child,
    );
  }
  
  // Apple-style fade transition
  static Widget fadeTransition(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeTransition(
      opacity: animation.drive(
        CurveTween(curve: AppTheme.easeOut),
      ),
      child: child,
    );
  }
  
  // Apple-style scale transition for dialogs
  static Widget scaleTransition(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return ScaleTransition(
      scale: animation.drive(
        Tween<double>(begin: 0.8, end: 1.0).chain(
          CurveTween(curve: AppTheme.easeInOutQuint),
        ),
      ),
      child: FadeTransition(
        opacity: animation,
        child: child,
      ),
    );
  }
}
```

#### 7.2 Добавить анимированные переходы в виджеты

**В файлах виджетов добавить**:

```dart
// Для состояний кнопок:
AnimatedContainer(
  duration: AppTheme.animationFast,
  curve: AppTheme.easeInOut,
  // ... properties
)

// Для изменения цветов:
AnimatedDefaultTextStyle(
  duration: AppTheme.animationMedium,
  curve: AppTheme.easeOut,
  // ... style properties
)
```

### 8. Специальные Apple-эффекты

#### 8.1 Добавить vibrancy и blur эффекты

```dart
// Для модальных окон и диалогов:
BackdropFilter(
  filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
  child: Container(
    color: Theme.of(context).brightness == Brightness.light
        ? Colors.white.withOpacity(0.8)
        : Colors.black.withOpacity(0.8),
    child: child,
  ),
)
```

#### 8.2 Добавить тени в Apple-стиле

```dart
// Apple-style shadows
static List<BoxShadow> get appleShadowSmall => [
  BoxShadow(
    color: Colors.black.withOpacity(0.08),
    offset: const Offset(0, 1),
    blurRadius: 2,
    spreadRadius: 0,
  ),
];

static List<BoxShadow> get appleShadowMedium => [
  BoxShadow(
    color: Colors.black.withOpacity(0.12),
    offset: const Offset(0, 4),
    blurRadius: 8,
    spreadRadius: 0,
  ),
  BoxShadow(
    color: Colors.black.withOpacity(0.04),
    offset: const Offset(0, 1),
    blurRadius: 2,
    spreadRadius: 0,
  ),
];
```

## План реализации

### Этап 1: Основы (1-2 дня)
1. ✅ Обновить цветовую палитру в `app_theme.dart`
2. ✅ Обновить типографику
3. ✅ Обновить базовые компоненты (кнопки, карточки, поля ввода)

### Этап 2: Компоненты (2-3 дня)
1. ✅ Обновить MainScreen и сайдбар
2. ✅ Обновить DashboardScreen
3. ✅ Обновить TimerWidget
4. ✅ Обновить ProjectsScreen

### Этап 3: Анимации (1-2 дня)  
1. ✅ Добавить Apple-стиль анимации
2. ✅ Обновить переходы между экранами
3. ✅ Добавить micro-interactions

### Этап 4: Полировка (1 день)
1. ✅ Добавить тени и эффекты
2. ✅ Тестирование и мелкие исправления
3. ✅ Оптимизация производительности

## Критерии успеха

- ✅ Приложение выглядит как нативное iOS/macOS приложение
- ✅ Плавные анимации везде (300ms с easing)
- ✅ Консистентная цветовая схема без "пестрящих" цветов
- ✅ Правильные пропорции и отступы по Apple HIG
- ✅ Богатый, элитный внешний вид без излишеств

## Результат

После реализации этого технического задания приложение Trackich будет иметь:
- Минималистичный, элегантный дизайн в стиле Apple
- Профессиональную цветовую палитру
- Плавные анимации и переходы
- Нативный внешний вид компонентов
- Богатый, элитный интерфейс без "отстойного" вида

Все изменения сосредоточены в файлах темы и существующих компонентах, что обеспечивает простоту реализации и поддержки.