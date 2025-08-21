# Trackich - Personal Time Tracking Application
## Technical Specification Document

### Document Overview
- **Project Name**: Trackich
- **Platform**: Cross-platform Desktop (Windows, macOS, Linux)
- **Framework**: Flutter
- **State Management**: Riverpod
- **Data Storage**: SharedPreferences
- **Target Users**: Individual professionals managing multiple projects
- **Design Philosophy**: Claude-style (clean, minimal, intuitive)

---

## 1. Application Architecture

### 1.1 Technical Stack
- **Frontend**: Flutter (Desktop targets)
- **State Management**: Riverpod 2.x
- **Local Storage**: SharedPreferences
- **Notifications**: Local system notifications
- **Localization**: Flutter Intl (English/Russian)
- **Design System**: Custom Claude-inspired UI components

### 1.2 Project Structure
```
lib/
├── main.dart
├── app/
│   ├── app.dart
│   └── theme/
├── core/
│   ├── constants/
│   ├── utils/
│   └── extensions/
├── data/
│   ├── models/
│   ├── repositories/
│   └── services/
├── presentation/
│   ├── screens/
│   ├── widgets/
│   └── providers/
├── l10n/
│   ├── app_en.arb
│   └── app_ru.arb
└── generated/
```

---

## 2. Data Models

### 2.1 Project Model
```dart
class Project {
  final String id;
  final String name;
  final String description;
  final Color color;
  final DateTime createdAt;
  final DateTime? archivedAt;
  final bool isArchived;
  final ProjectSettings settings;
}
```

### 2.2 Task Model
```dart
class Task {
  final String id;
  final String projectId;
  final String title;
  final String? description;
  final DateTime startTime;
  final DateTime? endTime;
  final Duration? duration;
  final TaskStatus status;
  final List<String> tags;
}

enum TaskStatus { active, paused, completed, cancelled }
```

### 2.3 Break Configuration Model
```dart
class BreakConfiguration {
  final Duration workDuration;
  final Duration shortBreakDuration;
  final Duration longBreakDuration;
  final int longBreakInterval;
  final bool enableNotifications;
  final String notificationSound;
}
```

### 2.4 User Settings Model
```dart
class UserSettings {
  final String language;
  final ThemeMode themeMode;
  final BreakConfiguration breakConfig;
  final bool enableSystemNotifications;
  final TimeFormat timeFormat;
  final WeekStartDay weekStartDay;
}
```

---

## 3. Screen Specifications

### 3.1 Main Dashboard Screen
**File**: `lib/presentation/screens/dashboard_screen.dart`

#### Layout Structure
- **Header**: App title, current project selector, time display
- **Main Content**: 
  - Current task widget (if active)
  - Quick start new task button
  - Today's time summary
  - Recent tasks list (last 5)
- **Bottom Navigation**: Dashboard, Calendar, Projects, Settings

#### Key Components
- `CurrentTaskWidget`: Shows active task with pause/stop controls
- `TimeDisplayWidget`: Real-time timer and total daily time
- `QuickTaskStartWidget`: Project selector + task name input
- `DailyStatsWidget`: Hours worked, tasks completed, breaks taken
- `RecentTasksList`: Scrollable list of recent tasks with quick actions

#### User Interactions
- Start new task: Select project → Enter task name → Start
- Pause/Resume current task: Single button toggle
- Stop task: Confirmation dialog → Task completion
- View task details: Tap on recent task item

#### State Management
- `dashboardProvider`: Current task state, daily stats
- `activeTaskProvider`: Real-time task timer
- `recentTasksProvider`: Last 5 tasks across all projects

### 3.2 Calendar View Screen
**File**: `lib/presentation/screens/calendar_screen.dart`

#### Layout Structure
- **Header**: Month/Year navigation, view toggle (Week/Month)
- **Calendar Grid**: 
  - Week view: 7 days with hourly breakdown
  - Month view: Standard calendar with task indicators
- **Task Details Panel**: Selected day's tasks and time breakdown

#### Key Components
- `CalendarHeaderWidget`: Navigation and view controls
- `WeekViewWidget`: 7-day horizontal scroll with time blocks
- `MonthViewWidget`: Standard calendar grid
- `DayTasksPanel`: Right panel showing selected day's details
- `TaskTimeBlock`: Visual representation of task duration

#### Features
- **Week View**: 
  - Hourly time blocks (8 AM - 8 PM default range)
  - Color-coded tasks by project
  - Drag to adjust task times (future enhancement)
  - Break indicators
- **Month View**:
  - Day cells with total hours worked
  - Color dots indicating projects worked on
  - Completion status indicators

#### User Interactions
- Switch views: Week ↔ Month toggle button
- Navigate time: Previous/Next arrows, date picker
- Select day: Tap calendar cell → Update task details panel
- View task: Tap task block → Task detail popup

### 3.3 Projects Management Screen
**File**: `lib/presentation/screens/projects_screen.dart`

#### Layout Structure
- **Header**: "Projects" title, Add project button
- **Project List**: Scrollable list of project cards
- **Project Detail Panel**: Right panel for selected project

#### Project Card Components
- Project name and description
- Color indicator
- Total time this week/month
- Task count (active/completed)
- Last activity timestamp
- Quick actions (Edit, Archive, View Tasks)

#### Project Detail Panel
- Project overview stats
- Recent tasks list
- Time tracking charts (week/month view)
- Project settings access

#### User Interactions
- Create project: Floating action button → Project creation dialog
- Edit project: Tap project card → Edit dialog
- Archive project: Long press → Archive confirmation
- View project tasks: Tap "View Tasks" → Filtered task list

### 3.4 Settings Screen
**File**: `lib/presentation/screens/settings_screen.dart`

#### Layout Structure
- **Header**: "Settings" title
- **Settings Sections**: Grouped configuration options

#### Settings Sections

##### General Settings
- Language selection (English/Russian)
- Theme mode (System/Light/Dark)
- Time format (12h/24h)
- Week start day
- Default project

##### Break Configuration
- Work session duration (default: 25 min)
- Short break duration (default: 5 min)
- Long break duration (default: 15 min)
- Long break interval (default: every 4 sessions)
- Enable break notifications
- Notification sound selection

##### Notification Settings
- System notifications enable/disable
- Break reminder notifications
- Daily summary notifications
- Notification quiet hours

##### Data Management
- Export data (JSON/CSV)
- Import data
- Clear all data (with confirmation)
- Backup to cloud (future enhancement)

#### User Interactions
- Modify settings: Tap setting → Show appropriate input widget
- Test notifications: "Test" button for notification settings
- Reset to defaults: Reset button with confirmation

### 3.5 Task Management Screen
**File**: `lib/presentation/screens/task_management_screen.dart`

#### Layout Structure
- **Header**: Filter controls, search bar
- **Task List**: Scrollable list with grouping options
- **Bulk Actions**: Multi-select operations

#### Filter Controls
- Project filter dropdown
- Date range picker
- Status filter (All, Active, Completed, Cancelled)
- Sort options (Date, Duration, Project, Alphabetical)

#### Task List Item
- Task title and description
- Project name and color indicator
- Start/end time
- Duration
- Status badge
- Quick actions (Edit, Delete, Duplicate)

#### Bulk Actions
- Select multiple tasks
- Bulk delete with confirmation
- Bulk project reassignment
- Bulk export

---

## 4. User Workflow Specifications

### 4.1 Daily Workflow
1. **Morning Setup**
   - User opens app
   - Selects primary project for the day
   - Reviews daily goals (optional notes)
   - Starts first task

2. **Work Session Cycle**
   - Start task with project selection and task name
   - Work period with live timer
   - Break notification triggers
   - Take break (tracked separately)
   - Resume or start new task

3. **Task Transitions**
   - Complete current task → Log completion time
   - Switch tasks → Auto-pause current, start new
   - Long break → Automatic break session tracking

4. **End of Day**
   - Review daily summary
   - Complete any incomplete tasks
   - View productivity metrics

### 4.2 Weekly Workflow
1. **Weekly Planning**
   - Review last week's time allocation
   - Set project priorities for coming week
   - Adjust break schedules if needed

2. **Weekly Review**
   - Calendar view analysis
   - Project time distribution
   - Productivity pattern identification

### 4.3 Project Management Workflow
1. **Project Creation**
   - Name and description entry
   - Color selection for visual identification
   - Initial settings configuration

2. **Project Lifecycle**
   - Active project task tracking
   - Project-specific analytics
   - Archive when complete

---

## 5. Feature Specifications

### 5.1 Time Tracking Engine

#### Core Functionality
- **Precision**: Second-level accuracy
- **Persistence**: Auto-save every 30 seconds
- **Recovery**: Resume incomplete sessions on app restart
- **Validation**: Prevent overlapping time entries

#### Timer States
- **Idle**: No active task
- **Running**: Task in progress with live timer
- **Paused**: Task paused, timer stopped
- **Break**: Break period active

#### Implementation Details
```dart
class TimeTrackingService {
  Stream<Duration> get currentTaskDuration;
  Future<void> startTask(Task task);
  Future<void> pauseTask();
  Future<void> resumeTask();
  Future<void> stopTask();
  Future<void> startBreak(BreakType type);
}
```

### 5.2 Break Management System

#### Break Types
- **Short Break**: 5-15 minutes
- **Long Break**: 15-30 minutes
- **Lunch Break**: 30-60 minutes
- **Custom Break**: User-defined duration

#### Notification System
- **Break Reminders**: Configurable intervals
- **Break End Alerts**: Return to work notifications
- **Smart Scheduling**: Respect user's current activity

#### Health Features
- Eye strain reminder (20-20-20 rule)
- Posture change reminders
- Hydration reminders
- Movement encouragement

### 5.3 Project Analytics

#### Time Distribution Charts
- Daily time allocation pie chart
- Weekly trend line graph
- Monthly project comparison bars
- Quarterly productivity overview

#### Productivity Metrics
- **Focus Time**: Uninterrupted work periods
- **Task Completion Rate**: Completed vs. started tasks
- **Project Balance**: Time distribution across projects
- **Break Adherence**: Following break schedule

#### Reports Generation
- Daily summary report
- Weekly productivity report
- Monthly project analysis
- Custom date range reports

### 5.4 Data Persistence

#### SharedPreferences Structure
```dart
// Core data keys
static const String PROJECTS_KEY = 'projects';
static const String TASKS_KEY = 'tasks';
static const String SETTINGS_KEY = 'user_settings';
static const String ACTIVE_TASK_KEY = 'active_task';
static const String BREAK_CONFIG_KEY = 'break_config';

// Analytics data
static const String DAILY_STATS_KEY = 'daily_stats';
static const String WEEKLY_STATS_KEY = 'weekly_stats';
```

#### Data Backup Strategy
- JSON export functionality
- Automatic daily backup (local)
- Data validation on import
- Migration strategy for version updates

---

## 6. UI/UX Design Guidelines

### 6.1 Claude-Inspired Design Principles

#### Visual Design
- **Color Palette**: 
  - Primary: Clean blues (#2563eb, #3b82f6)
  - Secondary: Warm grays (#6b7280, #9ca3af)
  - Accent: Subtle greens (#10b981, #34d399)
  - Background: Pure whites/soft grays
  - Text: High contrast (#111827, #374151)

#### Typography
- **Primary Font**: System default (SF Pro, Segoe UI, Roboto)
- **Font Sizes**: 
  - Headers: 24px, 20px, 18px
  - Body: 16px, 14px
  - Caption: 12px, 10px
- **Font Weights**: Regular (400), Medium (500), Semibold (600)

#### Spacing System
- **Base Unit**: 8px
- **Common Spacings**: 8px, 16px, 24px, 32px, 48px
- **Container Padding**: 24px
- **Element Margin**: 16px
- **Component Gap**: 12px

### 6.2 Component Design Standards

#### Buttons
- **Primary**: Filled, rounded corners (8px), hover states
- **Secondary**: Outlined, same dimensions as primary
- **Text Buttons**: No background, underline on hover
- **Icon Buttons**: 44px minimum touch target

#### Input Fields
- **Text Inputs**: Clean borders, focus indicators, floating labels
- **Dropdowns**: Native platform styling with custom icons
- **Time Pickers**: Custom time wheel or platform native

#### Cards and Containers
- **Project Cards**: Subtle shadows, rounded corners, hover lift
- **Task Items**: Clean list styling, clear hierarchy
- **Modal Dialogs**: Centered, backdrop blur, smooth animations

### 6.3 Interaction Patterns

#### Navigation
- **Bottom Navigation**: Fixed, icon + label, active state indicators
- **Sidebar**: Collapsible on larger screens
- **Breadcrumbs**: For deep navigation contexts

#### Feedback
- **Loading States**: Skeleton screens, progress indicators
- **Success Actions**: Subtle animations, color changes
- **Error States**: Non-intrusive alerts, inline validation
- **Empty States**: Helpful illustrations, clear actions

---

## 7. Localization Requirements

### 7.1 Supported Languages
- **Primary**: English (US)
- **Secondary**: Russian

### 7.2 Localization Scope

#### Text Content
- All UI labels and buttons
- Error messages and notifications
- Help text and tooltips
- Date and time formats
- Number formats (hours, minutes)

#### Cultural Considerations
- **Date Formats**: US (MM/DD/YYYY) vs. Russian (DD.MM.YYYY)
- **Time Formats**: 12-hour vs. 24-hour preferences
- **Week Start**: Sunday vs. Monday
- **Number Separators**: Decimal point vs. comma

#### Implementation Structure
```dart
// ARB files structure
// app_en.arb
{
  "appTitle": "Trackich",
  "startTask": "Start Task",
  "pauseTask": "Pause",
  "stopTask": "Stop",
  "projects": "Projects",
  "calendar": "Calendar",
  "settings": "Settings"
}

// app_ru.arb
{
  "appTitle": "Trackich",
  "startTask": "Начать задачу",
  "pauseTask": "Пауза",
  "stopTask": "Остановить",
  "projects": "Проекты",
  "calendar": "Календарь",
  "settings": "Настройки"
}
```

---

## 8. Technical Implementation Details

### 8.1 State Management with Riverpod

#### Provider Structure
```dart
// Core providers
final projectsProvider = StateNotifierProvider<ProjectsNotifier, List<Project>>;
final activeTaskProvider = StateNotifierProvider<ActiveTaskNotifier, Task?>;
final settingsProvider = StateNotifierProvider<SettingsNotifier, UserSettings>;
final breakConfigProvider = StateNotifierProvider<BreakConfigNotifier, BreakConfiguration>;

// Computed providers
final todayStatsProvider = Provider<DailyStats>;
final currentWeekTasksProvider = Provider<List<Task>>;
final projectTimeStatsProvider = FamilyProvider<ProjectStats, String>;
```

#### State Persistence
```dart
abstract class PersistentStateNotifier<T> extends StateNotifier<T> {
  final String storageKey;
  final SharedPreferences prefs;
  
  PersistentStateNotifier(this.storageKey, this.prefs, T initialState) : super(initialState) {
    _loadState();
  }
  
  Future<void> _loadState();
  Future<void> _saveState();
}
```

### 8.2 Data Services

#### Storage Service
```dart
class StorageService {
  static late SharedPreferences _prefs;
  
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }
  
  static Future<void> saveProjects(List<Project> projects);
  static Future<List<Project>> loadProjects();
  static Future<void> saveSettings(UserSettings settings);
  static Future<UserSettings> loadSettings();
}
```

#### Notification Service
```dart
class NotificationService {
  Future<void> init();
  Future<void> showBreakReminder(BreakType type);
  Future<void> showDailyStats(DailyStats stats);
  Future<void> scheduleBreakNotification(Duration delay);
  Future<void> cancelAllNotifications();
}
```

### 8.3 Cross-Platform Considerations

#### Desktop-Specific Features
- **Window Management**: Minimum size, remember position/size
- **System Tray**: Background operation, quick controls
- **Keyboard Shortcuts**: Global hotkeys for start/stop/pause
- **Menu Bar**: Native menu integration

#### Platform-Specific Implementations
```dart
// Windows specific
class WindowsNotificationService implements NotificationService {
  // Windows toast notifications
}

// macOS specific  
class MacOSNotificationService implements NotificationService {
  // macOS notification center
}

// Linux specific
class LinuxNotificationService implements NotificationService {
  // libnotify integration
}
```

---

## 9. Performance Considerations

### 9.1 Optimization Strategies

#### Data Management
- Lazy loading of historical data
- Pagination for large task lists
- Efficient JSON serialization
- Memory-conscious state management

#### UI Performance
- Widget rebuilding optimization
- Image caching for project icons
- Smooth animations (60 FPS target)
- Responsive layout for different screen sizes

#### Background Processing
- Timer accuracy maintenance
- Efficient break scheduling
- Background task persistence
- Resource cleanup on app close

### 9.2 Memory Management
- Dispose controllers and streams properly
- Limit in-memory task history
- Periodic cleanup of old notifications
- Efficient SharedPreferences usage

---

## 10. Testing Strategy

### 10.1 Unit Testing
- Data model serialization/deserialization
- Business logic validation
- State management providers
- Utility functions

### 10.2 Integration Testing
- Screen navigation flows
- Data persistence workflows
- Notification triggering
- Timer accuracy tests

### 10.3 Platform Testing
- Cross-platform UI consistency
- Platform-specific features
- Performance on different hardware
- Accessibility compliance

---

## 11. Development Phases

### 11.1 Phase 1: Core Foundation (Week 1-2)
- Project structure setup
- Basic navigation
- Data models implementation
- SharedPreferences integration
- Basic time tracking functionality

### 11.2 Phase 2: Main Features (Week 3-4)
- Dashboard screen completion
- Calendar view implementation
- Project management
- Settings screen
- Break notification system

### 11.3 Phase 3: Polish & Enhancement (Week 5-6)
- UI/UX refinements
- Localization implementation
- Performance optimization
- Platform-specific features
- Testing and bug fixes

### 11.4 Phase 4: Advanced Features (Week 7-8)
- Analytics and reporting
- Data export/import
- Advanced break configurations
- Productivity insights
- Final testing and deployment

---

## 12. Success Metrics

### 12.1 User Experience Metrics
- **Task Start Time**: < 3 seconds from dashboard
- **Navigation Speed**: Screen transitions < 200ms
- **Data Accuracy**: 99.9% timer precision
- **Crash Rate**: < 0.1% sessions

### 12.2 Feature Adoption
- **Daily Active Usage**: Track consistent daily use
- **Break Compliance**: Users following break schedules
- **Project Organization**: Multi-project usage
- **Settings Customization**: Feature utilization rates

### 12.3 Performance Benchmarks
- **App Launch Time**: < 2 seconds cold start
- **Memory Usage**: < 50MB average
- **Battery Impact**: Minimal background consumption
- **Storage Efficiency**: < 10MB for 6 months of data

---

## Conclusion

This technical specification provides a comprehensive blueprint for developing Trackich, a personal time tracking application focused on productivity, health, and efficiency. The design emphasizes simplicity while providing powerful features for managing multiple projects and maintaining healthy work habits.

The specification balances technical requirements with user experience considerations, ensuring the final product will be both functional and delightful to use. The phased development approach allows for iterative improvements and user feedback integration throughout the development process.

Key success factors include maintaining the Claude-inspired clean design, ensuring cross-platform consistency, and providing meaningful productivity insights that help users optimize their work patterns and maintain work-life balance.