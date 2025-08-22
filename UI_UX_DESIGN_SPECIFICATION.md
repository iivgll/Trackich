# Trackich - UI/UX Design Specification
## Version 1.0 | August 21, 2025

---

## 1. Design Philosophy & Principles

### 1.1 Core Design Philosophy
Trackich embodies the **Claude-style design philosophy**: clean, minimal, and purposeful. Every design decision prioritizes user efficiency and mental clarity while maintaining professional aesthetics.

**Key Design Principles:**
- **Clarity over Complexity**: Information hierarchy that guides users naturally
- **Efficiency First**: Minimal clicks to accomplish core tasks
- **Calm Technology**: Non-intrusive notifications and gentle visual feedback
- **Consistent Interactions**: Predictable behavior patterns across all screens
- **Health-Conscious Design**: Interface promotes healthy work habits

### 1.2 Target User Experience
- **Professional Feel**: Interface suitable for business and personal use
- **Minimal Cognitive Load**: Clean layouts that don't compete for attention
- **Immediate Clarity**: Users understand functionality within 3 seconds
- **Effortless Navigation**: Intuitive flow between features
- **Distraction-Free**: Interface fades into background during work

---

## 2. Visual Design System

### 2.1 Color Palette

#### Primary Color System
```
Primary Blue:    #0066CC  // Main actions, active states
Primary Blue 50: #E6F2FF  // Light backgrounds
Primary Blue 100: #CCE5FF // Hover states
Primary Blue 700: #0052A3  // Pressed states
Primary Blue 900: #003D7A  // Dark theme primary
```

#### Neutral Grays
```
Gray 50:  #F9FAFB  // Light theme background
Gray 100: #F3F4F6  // Card backgrounds
Gray 200: #E5E7EB  // Borders, dividers
Gray 300: #D1D5DB  // Disabled states
Gray 400: #9CA3AF  // Placeholders
Gray 500: #6B7280  // Secondary text
Gray 600: #4B5563  // Primary text
Gray 700: #374151  // Headings
Gray 800: #1F2937  // Dark theme background
Gray 900: #111827  // Dark theme text
```

#### Semantic Colors
```
Success Green: #10B981  // Completed actions, positive feedback
Warning Amber: #F59E0B  // Caution states, break reminders
Error Red:     #EF4444  // Errors, destructive actions
Focus Purple:  #8B5CF6  // Timer active state, focus mode
Break Blue:    #06B6D4  // Break periods, rest states
```

#### Project Color Set
```
Project 1: #EF4444  // Red
Project 2: #F97316  // Orange  
Project 3: #EAB308  // Yellow
Project 4: #22C55E  // Green
Project 5: #06B6D4  // Cyan
Project 6: #3B82F6  // Blue
Project 7: #8B5CF6  // Purple
Project 8: #EC4899  // Pink
```

### 2.2 Typography System

#### Font Family
```
Primary: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif
Monospace: 'JetBrains Mono', 'SF Mono', Monaco, 'Cascadia Code', monospace
```

#### Type Scale
```
Display Large:  32px/40px, Weight: 700  // Main headings
Display Medium: 28px/36px, Weight: 600  // Section titles
Headline:       24px/32px, Weight: 600  // Card titles
Title Large:    20px/28px, Weight: 600  // Subheadings
Title Medium:   18px/24px, Weight: 500  // Labels
Body Large:     16px/24px, Weight: 400  // Primary text
Body Medium:    14px/20px, Weight: 400  // Secondary text
Body Small:     12px/16px, Weight: 500  // Captions, metadata
Label Large:    14px/20px, Weight: 600  // Button text
Label Medium:   12px/16px, Weight: 600  // Form labels
```

#### Timer Display Typography
```
Timer Large:    48px/56px, Weight: 300, Monospace  // Main timer
Timer Medium:   32px/40px, Weight: 300, Monospace  // Dashboard timer
Timer Small:    24px/32px, Weight: 400, Monospace  // Widget timers
```

### 2.3 Spacing System

#### Base Grid: 8px unit system
```
Space 0:  0px
Space 1:  4px   (0.5 units)
Space 2:  8px   (1 unit)
Space 3:  12px  (1.5 units) 
Space 4:  16px  (2 units)
Space 6:  24px  (3 units)
Space 8:  32px  (4 units)
Space 12: 48px  (6 units)
Space 16: 64px  (8 units)
Space 20: 80px  (10 units)
Space 24: 96px  (12 units)
```

#### Component Spacing
```
Button Padding:       12px × 24px
Input Padding:        12px × 16px
Card Padding:         24px
Modal Padding:        32px
Section Margins:      48px
Navigation Height:    64px
Sidebar Width:        280px
```

### 2.4 Border Radius & Shadows

#### Border Radius
```
Radius None: 0px
Radius SM:   4px   // Small elements
Radius MD:   8px   // Buttons, inputs
Radius LG:   12px  // Cards, containers
Radius XL:   16px  // Modals, panels
Radius Full: 9999px // Circular elements
```

#### Shadow System
```
Shadow SM: 0 1px 2px rgba(0, 0, 0, 0.05)           // Subtle elevation
Shadow MD: 0 4px 6px rgba(0, 0, 0, 0.07)           // Cards
Shadow LG: 0 10px 15px rgba(0, 0, 0, 0.1)          // Modals, dropdowns
Shadow XL: 0 20px 25px rgba(0, 0, 0, 0.1)          // Major overlays
```

---

## 3. Component Design Specifications

### 3.1 Button Components

#### Primary Button
```
Background: Primary Blue (#0066CC)
Text Color: White (#FFFFFF)
Border Radius: 8px
Padding: 12px × 24px
Font: 14px, Weight 600

States:
- Hover: Background → Primary Blue 700 (#0052A3)
- Pressed: Background → Primary Blue 900 (#003D7A)
- Disabled: Background → Gray 300 (#D1D5DB), Text → Gray 500 (#6B7280)
- Loading: Show spinner, maintain background color
```

#### Secondary Button
```
Background: Transparent
Text Color: Primary Blue (#0066CC)
Border: 1px solid Gray 300 (#D1D5DB)
Border Radius: 8px
Padding: 12px × 24px
Font: 14px, Weight 600

States:
- Hover: Background → Gray 50 (#F9FAFB), Border → Primary Blue (#0066CC)
- Pressed: Background → Gray 100 (#F3F4F6)
- Disabled: Border → Gray 200 (#E5E7EB), Text → Gray 400 (#9CA3AF)
```

#### Icon Button
```
Size: 40px × 40px
Background: Transparent
Border Radius: 8px
Icon Size: 20px
Color: Gray 600 (#4B5563)

States:
- Hover: Background → Gray 100 (#F3F4F6)
- Pressed: Background → Gray 200 (#E5E7EB)
- Active: Background → Primary Blue 50 (#E6F2FF), Icon → Primary Blue
```

#### Floating Action Button
```
Size: 56px × 56px
Background: Primary Blue (#0066CC)
Border Radius: Full (28px)
Icon: 24px, White
Shadow: Shadow LG

States:
- Hover: Scale → 1.05, Shadow → Shadow XL
- Pressed: Scale → 0.95
```

### 3.2 Input Components

#### Text Input
```
Background: White (#FFFFFF)
Border: 1px solid Gray 300 (#D1D5DB)
Border Radius: 8px
Padding: 12px × 16px
Font: 16px, Weight 400
Placeholder: Gray 400 (#9CA3AF)

States:
- Focus: Border → Primary Blue (#0066CC), Shadow → 0 0 0 3px Primary Blue 50
- Error: Border → Error Red (#EF4444)
- Disabled: Background → Gray 50 (#F9FAFB)
```

#### Dropdown Select
```
Background: White (#FFFFFF)
Border: 1px solid Gray 300 (#D1D5DB)
Border Radius: 8px
Padding: 12px × 16px
Font: 16px, Weight 400
Chevron: 16px, Gray 400 (#9CA3AF)

Dropdown Panel:
- Background: White, Border Radius: 8px
- Shadow: Shadow LG
- Max Height: 200px (scrollable)
- Item Padding: 12px × 16px
- Item Hover: Background → Gray 50 (#F9FAFB)
```

#### Toggle Switch
```
Track Width: 44px
Track Height: 24px
Track Radius: 12px
Thumb Size: 20px
Thumb Radius: 10px

Off State:
- Track: Gray 300 (#D1D5DB)
- Thumb: White, positioned left

On State:
- Track: Primary Blue (#0066CC)
- Thumb: White, positioned right

Animation: 200ms ease-out
```

### 3.3 Card Components

#### Standard Card
```
Background: White (#FFFFFF)
Border: 1px solid Gray 200 (#E5E7EB)
Border Radius: 12px
Padding: 24px
Shadow: Shadow SM

States:
- Hover: Shadow → Shadow MD, Border → Gray 300 (#D1D5DB)
- Interactive: Cursor → pointer
```

#### Stat Card
```
Background: White (#FFFFFF)
Border: 1px solid Gray 200 (#E5E7EB)
Border Radius: 12px
Padding: 24px
Shadow: Shadow SM

Layout:
- Icon: 24px, positioned top-left
- Value: Timer Large (48px), primary color
- Label: Body Medium (14px), Gray 600
- Change Indicator: Body Small (12px), semantic colors
```

#### Project Card
```
Background: White (#FFFFFF)
Border: 1px solid Gray 200 (#E5E7EB)
Border Radius: 12px
Padding: 20px
Shadow: Shadow SM

Header:
- Color Dot: 12px circle, project color
- Title: Title Medium (18px), Gray 900
- Menu: Icon button (16px)

Content:
- Description: Body Medium (14px), Gray 600, 2 lines max
- Time Tracked: Body Small (12px), Gray 500
- Progress Bar: 4px height, project color

Footer:
- Tags: Pills with project color background at 10% opacity
- Last Active: Body Small (12px), Gray 400
```

### 3.4 Navigation Components

#### Sidebar Navigation
```
Width: 280px
Background: Gray 50 (#F9FAFB)
Border Right: 1px solid Gray 200 (#E5E7EB)

Logo Area:
- Height: 64px
- Padding: 16px × 24px
- Logo: 32px height

Navigation Items:
- Height: 48px
- Padding: 12px × 24px
- Icon: 20px, Gray 600
- Text: Body Large (16px), Gray 700
- Border Radius: 8px (with 8px margin)

States:
- Hover: Background → Gray 100 (#F3F4F6)
- Active: Background → Primary Blue 50 (#E6F2FF), Text → Primary Blue
- Badge: 20px height, Primary Blue background
```

#### Top Navigation Bar
```
Height: 64px
Background: White (#FFFFFF)
Border Bottom: 1px solid Gray 200 (#E5E7EB)
Padding: 0 × 24px

Layout:
- Left: Breadcrumb navigation
- Center: Page title (Headline 24px)
- Right: User menu, notifications, settings
```

#### Breadcrumb Navigation
```
Font: Body Medium (14px)
Color: Gray 600 (#4B5563)
Separator: "/" (Gray 400)

Active Item:
- Color: Gray 900 (#111827)
- Weight: 500

Hover:
- Color: Primary Blue (#0066CC)
- Cursor: pointer (for clickable items)
```

### 3.5 Timer Components

#### Main Timer Display
```
Container:
- Background: White (#FFFFFF)
- Border: 1px solid Gray 200 (#E5E7EB)
- Border Radius: 16px
- Padding: 32px
- Shadow: Shadow MD

Timer Display:
- Font: Timer Large (48px), Monospace, Weight 300
- Color: Gray 900 (inactive), Focus Purple (active)
- Format: HH:MM:SS

Project Selector:
- Dropdown with project color indicators
- Font: Title Large (20px)
- Placeholder: "Select project..."

Task Input:
- Placeholder: "What are you working on?"
- Font: Body Large (16px)
- Auto-resize height

Control Buttons:
- Play/Pause: 48px circle, Primary Blue
- Stop: 40px circle, Gray 600
- Icon Size: 24px
```

#### Compact Timer Widget
```
Container:
- Height: 60px
- Background: Gray 50 (#F9FAFB)
- Border Radius: 12px
- Padding: 16px × 20px

Layout (Horizontal):
- Project Dot: 8px, project color
- Project Name: Body Medium (14px), truncated
- Timer: Timer Small (24px), Monospace
- Control Button: 32px, icon 16px
```

#### Timer Controls Bar
```
Background: White (#FFFFFF)
Border: 1px solid Gray 200 (#E5E7EB)
Border Radius: 12px
Padding: 16px × 24px
Height: 56px

Layout:
- Play/Pause: Primary button
- Stop: Secondary button
- Break: Secondary button with Break Blue color
- Spacer
- Time Display: Timer Medium (32px)
```

---

## 4. Screen-by-Screen Design Specifications

### 4.1 Dashboard Screen Layout

#### Overall Structure
```
Layout: Sidebar (280px) + Main Content (flexible)
Main Content Padding: 32px
Grid: 12-column with 24px gutters
```

#### Header Section (Full Width)
```
Height: 120px
Background: Gradient from Primary Blue 50 to White
Border Radius: 12px
Padding: 32px

Content:
- Welcome Text: Display Medium (28px), Gray 900
- Current Date: Body Large (16px), Gray 600
- Quick Actions: Icon buttons (Create Project, Settings)
```

#### Main Timer Section (8 columns)
```
Grid Column: 1-8
Margin Bottom: 32px

Content:
- Main Timer Display (as specified above)
- Project/Task Selector
- Control Buttons
- Session Summary (time today, current streak)
```

#### Today's Summary Widget (4 columns)
```
Grid Column: 9-12
Height: Matches main timer

Header:
- Title: "Today's Activity"
- Total Time: Timer Medium (32px), Primary Blue

Progress Bars:
- Project Name + Time + Progress Bar
- Bar Height: 8px
- Colors: Project colors with 20% opacity background

Footer:
- Tasks Completed: Count with icon
- Break Time: Total break duration
```

#### Quick Actions Panel (6 columns)
```
Grid Column: 1-6
Height: 160px

Header: Title Large (20px), "Quick Start"

Recent Projects:
- Grid: 2×3 project cards
- Card Size: 100px × 80px
- Project Color: Top border (4px)
- Project Name: Body Medium (14px), truncated
- Last Used: Body Small (12px), Gray 500
```

#### Health & Wellness Widget (6 columns)
```
Grid Column: 7-12
Height: 160px

Header: Title Large (20px), "Wellness"

Content:
- Next Break: Countdown timer, Focus Purple
- Break Score: Today's break compliance percentage
- Health Tip: Rotating wellness suggestions
- Take Break Button: Secondary button, Break Blue
```

#### Recent Activity Feed (Full Width)
```
Height: 300px
Background: White
Border: 1px solid Gray 200
Border Radius: 12px
Padding: 24px

Header:
- Title: Title Large (20px), "Recent Activity"
- Filter: Dropdown (Today, This Week, All)

Activity Items:
- Time: Body Small (12px), Gray 500
- Project Dot: 8px, project color
- Task Name: Body Medium (14px), Gray 900
- Duration: Body Small (12px), Gray 600
- Edit Icon: 16px, appears on hover
```

### 4.2 Projects Screen Layout

#### Toolbar Section
```
Height: 80px
Padding: 24px × 32px
Background: White
Border Bottom: 1px solid Gray 200

Left Side:
- Search Input: 320px width
- Filter Dropdown: "All Projects", "Active", "Archived"
- View Toggle: Grid/List icons

Right Side:
- Sort Dropdown: "Recent", "A-Z", "Most Used"
- Create Project Button: Primary button with plus icon
```

#### Projects Grid (Default View)
```
Grid: 3 columns on desktop, 2 on tablet
Gap: 24px
Padding: 32px

Project Card: (As specified in Component section)
- Hover: Lift effect (translateY: -2px, shadow increase)
- Click: Navigate to project details/edit
```

#### Projects List View
```
Table Layout:
- Name Column: 30% (with color dot)
- Description Column: 40%
- Time Tracked Column: 15%
- Last Active Column: 15%

Row Height: 60px
Row Padding: 16px × 24px
Alternating Backgrounds: White/Gray 50

Actions:
- Row Hover: Show action buttons (Edit, Archive, Delete)
- Checkbox Column: For bulk operations
```

#### Empty State
```
Layout: Centered content
Icon: 64px project folder icon, Gray 400
Title: Display Medium (28px), "No Projects Yet"
Description: Body Large (16px), Gray 600
Action: Primary button "Create Your First Project"
Illustration: Simple productivity-themed graphic
```

### 4.3 Project Creation/Edit Modal

#### Modal Container
```
Width: 600px
Max Height: 80vh
Background: White
Border Radius: 16px
Shadow: Shadow XL
Padding: 32px

Backdrop: rgba(0, 0, 0, 0.5)
Animation: Scale + fade in (300ms ease-out)
```

#### Modal Header
```
Border Bottom: 1px solid Gray 200
Padding Bottom: 24px
Margin Bottom: 32px

Title: Display Medium (28px)
Close Button: Icon button (24px), positioned top-right
```

#### Form Layout
```
Field Spacing: 24px vertical margin

Project Name:
- Label: Label Large (14px), Weight 600
- Input: Full width text input
- Helper: "Choose a memorable name"

Description:
- Label + Helper text
- Textarea: 3 rows, auto-resize
- Character count: 200 max

Color Selection:
- Label: "Project Color"
- Color Palette: 8 colors in 4×2 grid
- Swatch Size: 40px circles
- Selected: Border (3px, White) + Shadow
- Hover: Scale 1.1

Tags Input:
- Label: "Tags (optional)"
- Tag Input: With autocomplete
- Tag Pills: Removable, project color theme

Target Hours:
- Label: "Weekly Target (hours)"
- Number Input: With stepper controls
- Helper: "Set 0 to disable tracking"
```

#### Modal Footer
```
Background: Gray 50
Margin: 32px × -32px × -32px
Padding: 24px × 32px
Border Radius: 0 × 0 × 16px × 16px

Buttons:
- Cancel: Text button, left-aligned
- Save: Primary button, right-aligned
- Delete: Secondary button (edit mode only)
```

### 4.4 Calendar Screen Layout

#### Calendar Toolbar
```
Height: 80px
Padding: 24px × 32px
Border Bottom: 1px solid Gray 200

Left Side:
- View Toggle: Week/Month/Day buttons (segmented control)
- Today Button: Secondary button

Center:
- Navigation: Previous/Next arrows + Current period
- Period Text: Title Large (20px)

Right Side:
- Export Button: Secondary button
- Settings: Icon button
```

#### Week View Layout
```
Grid: 7 days × time slots
Time Slot Height: 60px (1 hour)
Day Column Width: Flexible (1/7 of available space)

Day Headers:
- Height: 60px
- Day Name: Label Large (14px), Weight 600
- Date: Body Large (16px)
- Today Highlight: Primary Blue background

Time Sidebar:
- Width: 80px
- Font: Body Small (12px), Gray 600
- Format: 24h/12h based on settings

Time Blocks:
- Background: Project color at 10% opacity
- Border Left: 4px solid project color
- Text: Body Small (12px), project color (dark)
- Hover: Opacity increase to 15%
- Click: Show time entry details popover
```

#### Month View Layout
```
Calendar Grid: 7×6 cells
Cell Size: Square (calculated based on available space)
Cell Padding: 8px

Date Headers:
- Height: 40px
- Font: Body Small (12px), Gray 600

Date Cells:
- Date Number: Body Medium (14px), top-left
- Activity Indicators: Small dots (6px) in project colors
- Total Time: Body Small (12px), bottom-right
- Today: Border (2px, Primary Blue)
- Other Month: Gray 400 text

Activity Summary:
- Max 3 dots per day
- Hover: Tooltip with project breakdown
```

#### Day Timeline View
```
Timeline: 24-hour vertical layout
Hour Height: 80px
Time Labels: 60px width sidebar

Time Blocks:
- Full width within hour slots
- Height proportional to duration
- Project color styling
- Task name overlay
- Break blocks: Dashed border, Break Blue color

Current Time Indicator:
- Red line across timeline
- Time label on sidebar
- Auto-scroll to current time on load
```

### 4.5 Analytics Screen Layout

#### Analytics Header
```
Height: 120px
Padding: 32px
Background: Linear gradient (Primary Blue 50 to White)

Time Period Selector:
- Segmented Control: Week/Month/Quarter/Custom
- Date Range Picker: Custom option
- Refresh Button: Auto-refresh toggle

Key Metrics Row:
- 4 stat cards in grid
- Metrics: Total Hours, Focus Score, Break Compliance, Productivity Trend
```

#### Charts Section
```
Grid: 2×2 layout on desktop, stacked on smaller screens
Gap: 32px
Padding: 32px

Time Distribution Chart (Top Left):
- Type: Donut chart
- Size: 300px diameter
- Colors: Project colors
- Center: Total hours
- Legend: Right side, scrollable

Productivity Trend (Top Right):
- Type: Line chart
- Height: 300px
- X-axis: Days/weeks
- Y-axis: Hours
- Line: Primary Blue, 3px width
- Fill: Gradient from Primary Blue 20% to transparent

Weekly Comparison (Bottom Left):
- Type: Bar chart
- Height: 300px
- Bars: Primary Blue
- Hover: Darker shade + tooltip

Break Patterns (Bottom Right):
- Type: Heat map
- Days of week × hours of day
- Colors: Break Blue intensity scale
- Tooltip: Break frequency data
```

#### Insights Panel
```
Width: Full
Background: White
Border: 1px solid Gray 200
Border Radius: 12px
Padding: 32px
Margin Top: 32px

Header:
- Title: Title Large (20px), "Productivity Insights"
- Subtitle: Body Medium (14px), Gray 600

Insight Cards:
- Layout: Grid, 2-3 columns
- Background: Gray 50
- Border Radius: 8px
- Padding: 20px
- Icon: 24px, semantic colors
- Title: Body Large (16px), Weight 500
- Description: Body Medium (14px), Gray 600
- Action: Text button (optional)
```

### 4.6 Settings Screen Layout

#### Settings Sidebar
```
Width: 240px
Background: Gray 50
Border Right: 1px solid Gray 200

Categories:
- General
- Timer & Breaks
- Notifications
- Data & Privacy
- About

Category Items:
- Height: 44px
- Padding: 12px × 20px
- Font: Body Medium (14px)
- Active: Primary Blue background (10% opacity)
```

#### Settings Content
```
Padding: 32px × 40px
Background: White

Section Header:
- Title: Display Medium (28px)
- Description: Body Large (16px), Gray 600
- Margin Bottom: 32px

Setting Groups:
- Margin Bottom: 40px
- Group Title: Title Large (20px), Margin Bottom: 16px

Setting Item:
- Layout: Label (left) + Control (right)
- Height: 56px
- Border Bottom: 1px solid Gray 100
- Label: Body Large (16px), Gray 900
- Description: Body Medium (14px), Gray 600
- Control: Toggle, dropdown, or input
```

#### Data Management Section
```
Background: Gray 50
Border: 1px solid Gray 200
Border Radius: 12px
Padding: 24px

Warning Icon: 24px, Warning Amber
Title: Title Medium (18px), "Data Management"
Description: Body Medium (14px), Gray 600

Actions:
- Export Data: Primary button
- Import Data: Secondary button  
- Clear All Data: Secondary button (Error Red text)

Confirmation Modal:
- Critical actions require confirmation
- Red accent for destructive actions
```

---

## 5. Interaction Design & User Flows

### 5.1 Timer Interaction Patterns

#### Starting a Timer
```
Flow: Dashboard → Select Project → Enter Task → Start

Interaction Details:
1. Project Selector Click:
   - Show dropdown with recent projects
   - Search functionality for large project lists
   - "Create Project" option at bottom

2. Task Input Focus:
   - Auto-complete from previous task names
   - Placeholder changes to encourage specificity
   - Enter key starts timer

3. Start Button Interaction:
   - Button morphs from Play to Pause icon
   - Timer display changes color (Gray → Focus Purple)
   - Subtle pulse animation on timer digits
   - System notification (optional)

States:
- Idle: All controls enabled, gray timer
- Running: Pause/Stop enabled, colored timer
- Paused: Resume/Stop enabled, warning color
```

#### Timer State Transitions
```
Visual Feedback:
- Start: 300ms ease-out scale + color transition
- Pause: Immediate feedback, warning color
- Stop: Confirmation dialog, return to idle state
- Auto-break: Smooth transition to break mode

Animations:
- Timer digits: Smooth counting animation
- Progress ring: Circular progress for work sessions
- Background: Subtle color shifts for different modes
```

### 5.2 Navigation Patterns

#### Sidebar Navigation
```
Interaction Model: Single-click navigation
Active State: Persistent until new selection
Keyboard Navigation: Arrow keys + Enter

Visual Feedback:
- Hover: 150ms ease-in background change
- Click: Immediate active state
- Page load: Progress indicator if needed

Badge Notifications:
- Position: Top-right of nav item
- Style: Small circle with count
- Animation: Gentle bounce on update
```

#### Breadcrumb Navigation
```
Clickable Elements: All parent levels
Current Page: Non-clickable, emphasized
Overflow: Collapse middle items with "..."

Hover States:
- Underline animation (200ms ease-out)
- Color transition to Primary Blue
- Pointer cursor
```

### 5.3 Form Interaction Patterns

#### Input Field Behaviors
```
Focus States:
- Border color transition (200ms)
- Label animation (slide up + scale down)
- Placeholder fade out
- Helper text appearance

Validation:
- Real-time validation for format errors
- Success state: Green border + checkmark icon
- Error state: Red border + error message
- Warning state: Amber border + warning message

Auto-save:
- Debounced saving (1 second delay)
- Visual indicator during save
- Success confirmation (subtle animation)
```

#### Modal Interactions
```
Opening:
- Backdrop fade-in (200ms)
- Modal scale-in + fade-in (300ms ease-out)
- Focus trap to modal content
- Body scroll lock

Closing:
- ESC key or backdrop click
- Scale-out + fade-out (250ms ease-in)
- Return focus to trigger element
- Confirm unsaved changes

Form Submission:
- Button loading state
- Disable form during processing
- Success: Close modal + show toast
- Error: Show inline error messages
```

### 5.4 Data Visualization Interactions

#### Chart Interactions
```
Hover Effects:
- Data point highlighting
- Tooltip with detailed information
- Crosshair lines for precision
- Legend highlighting

Click Interactions:
- Drill down to detailed view
- Filter data by clicked element
- Toggle data series visibility

Zoom and Pan:
- Mouse wheel zoom on timeline charts
- Drag to pan on large datasets
- Reset zoom button
- Smooth transitions (300ms ease-out)
```

#### Calendar Interactions
```
Time Block Interactions:
- Hover: Highlight + details preview
- Click: Open time entry details popover
- Double-click: Edit time entry inline
- Drag: Move time entry (with validation)

Navigation:
- Keyboard: Arrow keys for date navigation
- Touch: Swipe gestures for week/month changes
- Smooth transitions between periods
```

---

## 6. Responsive Design Guidelines

### 6.1 Breakpoint System

#### Primary Breakpoints
```
Mobile:    320px - 767px   (Future consideration)
Tablet:    768px - 1023px  (Minimum support)
Desktop:   1024px - 1439px (Primary target)
Large:     1440px+         (Optimized experience)
```

#### Desktop-Focused Responsive Rules
```
Minimum Window Size: 800×600px
Optimal Size: 1200×800px
Maximum Width: No limit (content scales appropriately)

Layout Adaptations:
- Sidebar: Collapsible on smaller screens
- Grid Systems: Reduce columns on narrow screens  
- Typography: Maintain readability at all sizes
- Touch Targets: 44px minimum (future mobile support)
```

### 6.2 Layout Flexibility

#### Sidebar Behavior
```
> 1200px: Full sidebar visible
800-1199px: Collapsible sidebar with icons
< 800px: Overlay sidebar (slide in/out)

Transition: 250ms ease-out
Toggle: Hamburger menu icon
Persistence: Remember user preference
```

#### Grid System Adaptations
```
Large Desktop (1440px+):
- Dashboard: 4-column grid
- Projects: 4-column grid
- Maximum content width: 1200px (centered)

Standard Desktop (1024-1439px):
- Dashboard: 3-column grid
- Projects: 3-column grid
- Full width utilization

Compact Desktop (800-1023px):
- Dashboard: 2-column grid
- Projects: 2-column grid
- Compressed spacing
```

#### Component Scaling
```
Typography: Fixed sizes (no scaling)
Spacing: Proportional reduction at smaller sizes
Icons: Maintain minimum 16px size
Buttons: Maintain minimum 44px height
Cards: Reduce padding, maintain hierarchy
```

---

## 7. Accessibility Design Standards

### 7.1 Visual Accessibility

#### Color and Contrast
```
Minimum Contrast Ratios:
- Normal Text: 4.5:1 (WCAG AA)
- Large Text: 3:1 (WCAG AA)
- Interactive Elements: 3:1 minimum

Color Dependencies:
- Never rely solely on color for meaning
- Always provide secondary indicators (icons, labels)
- Support for high contrast mode
- Color blind friendly palette testing
```

#### Typography Accessibility
```
Font Size Minimums:
- Body text: 16px minimum
- Secondary text: 14px minimum
- Never below 12px for any interface text

Readability:
- Line height: 1.4 minimum for body text
- Line length: 45-75 characters optimal
- Adequate spacing between interactive elements
- Clear hierarchy with size and weight differences
```

### 7.2 Keyboard Navigation

#### Focus Management
```
Focus Indicators:
- Visible focus ring: 2px solid Primary Blue
- Sufficient contrast against all backgrounds
- Never remove focus indicators

Tab Order:
- Logical sequence following visual layout
- Skip links for navigation bypass
- Proper focus trapping in modals
- Focus restoration after modal close

Keyboard Shortcuts:
- Space: Start/pause timer
- Ctrl/Cmd + N: New project
- Ctrl/Cmd + S: Save (in forms)
- Escape: Close modals/dropdowns
```

#### Screen Reader Support
```
Semantic HTML:
- Proper heading hierarchy (h1-h6)
- Landmark regions (main, nav, aside)
- Form labels and descriptions
- Button purposes clearly described

ARIA Labels:
- Timer status announcements
- Progress indicators
- Error messages
- State changes (loading, success, error)

Live Regions:
- Timer updates (polite)
- Form validation (assertive)
- Status notifications (polite)
```

### 7.3 Motor Accessibility

#### Target Sizes
```
Minimum Touch Target: 44px × 44px
Adequate Spacing: 8px minimum between targets
Large Interactive Elements: Primary actions get priority
Alternative Interactions: Multiple ways to trigger actions
```

#### Timing and Animation
```
Animation Controls:
- Respect prefers-reduced-motion
- Disable animations for accessibility needs
- Provide alternative static states

Timing Flexibility:
- No automatic timeouts on forms
- Extended time for complex interactions
- Clear timing expectations
```

---

## 8. Dark Mode Design Specifications

### 8.1 Dark Mode Color Palette

#### Primary Dark Colors
```
Background Primary: #1F2937   (Gray 800)
Background Secondary: #111827 (Gray 900)
Background Elevated: #374151  (Gray 700)
Surface: #4B5563             (Gray 600)
```

#### Text Colors (Dark Mode)
```
Text Primary: #F9FAFB        (Gray 50)
Text Secondary: #E5E7EB      (Gray 200)
Text Tertiary: #9CA3AF       (Gray 400)
Text Disabled: #6B7280       (Gray 500)
```

#### Interactive Colors (Dark Mode)
```
Primary Blue: #3B82F6        (Blue 500)
Primary Blue Hover: #2563EB  (Blue 600)
Primary Blue Active: #1D4ED8 (Blue 700)

Success: #10B981             (Emerald 500)
Warning: #F59E0B             (Amber 500)
Error: #EF4444               (Red 500)
Focus: #8B5CF6               (Purple 500)
```

### 8.2 Dark Mode Component Adaptations

#### Button Adaptations
```
Primary Button (Dark):
- Background: Primary Blue (#3B82F6)
- Text: White
- Hover: Primary Blue Hover (#2563EB)

Secondary Button (Dark):
- Background: Transparent
- Border: 1px solid Gray 600 (#4B5563)
- Text: Gray 200 (#E5E7EB)
- Hover: Background Gray 700 (#374151)
```

#### Card Adaptations
```
Standard Card (Dark):
- Background: Background Elevated (#374151)
- Border: 1px solid Gray 600 (#4B5563)
- Shadow: Enhanced for better definition

Timer Display (Dark):
- Background: Background Primary (#1F2937)
- Border: Gray 600 (#4B5563)
- Active Timer: Focus Purple (#8B5CF6)
```

#### Input Adaptations
```
Text Input (Dark):
- Background: Background Primary (#1F2937)
- Border: Gray 600 (#4B5563)
- Text: Text Primary (#F9FAFB)
- Placeholder: Text Tertiary (#9CA3AF)
- Focus: Primary Blue border with darker shadow
```

### 8.3 Dark Mode Transition

#### Theme Toggle
```
Location: Settings → General → Theme Mode
Options: Light, Dark, System (follows OS preference)
Transition: 300ms ease-out for all color properties
Persistence: Save preference in local storage
```

#### Smooth Transitions
```
CSS Transition: all 300ms ease-out
Affected Properties: background-color, border-color, color
Exception: Images and charts (instant change)
Prefers-color-scheme: Support system preference detection
```

---

## 9. Animation & Micro-Interaction Specifications

### 9.1 Animation Principles

#### Core Animation Values
```
Duration Scale:
- Instant: 0ms (state changes)
- Fast: 150ms (small elements)
- Medium: 250ms (modals, navigation)
- Slow: 400ms (page transitions)

Easing Functions:
- Ease-out: Default for entrances (cubic-bezier(0, 0, 0.2, 1))
- Ease-in: Exits (cubic-bezier(0.4, 0, 1, 1))
- Ease-in-out: Transform effects (cubic-bezier(0.4, 0, 0.2, 1))

Performance:
- Use transform and opacity for animations
- Avoid animating layout properties
- Use will-change sparingly
```

### 9.2 Specific Animation Behaviors

#### Button Interactions
```
Hover State:
- Scale: 1.02 (subtle growth)
- Duration: 150ms ease-out
- Background: Color transition

Press State:
- Scale: 0.98 (subtle shrink)
- Duration: 100ms ease-out
- Immediate feedback

Loading State:
- Spinner: 1s linear infinite rotation
- Button content: Fade to 50% opacity
- Width: Maintain original button width
```

#### Modal Animations
```
Entry:
- Backdrop: Fade in (0 to 50% opacity, 200ms)
- Modal: Scale (0.95 to 1) + Fade (0 to 1, 300ms ease-out)
- Stagger: Backdrop starts 50ms before modal

Exit:
- Modal: Scale (1 to 0.95) + Fade (1 to 0, 250ms ease-in)
- Backdrop: Fade out (50% to 0, 200ms)
- Stagger: Modal starts 50ms before backdrop
```

#### Timer Animations
```
Start Animation:
- Timer color: Gray to Focus Purple (300ms ease-out)
- Scale pulse: 1 to 1.05 to 1 (400ms ease-out)
- Play button: Icon morph to pause (200ms)

Digit Updates:
- Individual digit: Fade out/in (150ms each)
- Smooth counting for seconds
- No animation for milliseconds (performance)

Break Notifications:
- Gentle bounce: Scale 1 to 1.1 to 1 (500ms)
- Color pulse: Current to Break Blue (300ms)
- Sound: Optional audio cue
```

#### Loading States
```
Skeleton Loading:
- Background: Shimmer animation (1.5s ease-in-out infinite)
- Shimmer: Linear gradient moving left to right
- Elements: Maintain layout, show content placeholders

Progressive Loading:
- Content: Fade in as it becomes available
- Images: Blur to sharp (300ms ease-out)
- Lists: Stagger item appearances (50ms delays)
```

### 9.3 Feedback Animations

#### Success States
```
Form Submission Success:
- Checkmark icon: Scale in + rotate (400ms ease-out)
- Form: Gentle scale pulse (300ms)
- Color: Transition to Success Green
- Sound: Subtle success chime (optional)
```

#### Error States
```
Form Validation Error:
- Shake animation: X-axis translation (400ms)
- Color: Border to Error Red (200ms)
- Icon: Error icon scale in (300ms)
- Message: Slide down + fade in (250ms)
```

#### Focus Indicators
```
Focus Ring:
- Appearance: Scale from 0 (200ms ease-out)
- Color: Primary Blue with 20% opacity background
- Width: 2px solid
- Offset: 2px from element edge
```

---

## 10. Implementation Guidelines for Developers

### 10.1 Flutter-Specific Design Implementation

#### Theme Configuration
```dart
// Primary theme structure
ThemeData lightTheme = ThemeData(
  primarySwatch: MaterialColor(0xFF0066CC, {
    50: Color(0xFFE6F2FF),
    100: Color(0xFFCCE5FF),
    // ... color swatch definition
  }),
  
  // Typography theme
  textTheme: TextTheme(
    displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.w700),
    displayMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
    // ... complete typography scale
  ),
  
  // Component themes
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Color(0xFF0066CC),
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    ),
  ),
);
```

#### Design Token Structure
```dart
class DesignTokens {
  // Spacing
  static const double spaceXs = 4.0;
  static const double spaceSm = 8.0;
  static const double spaceMd = 16.0;
  static const double spaceLg = 24.0;
  static const double spaceXl = 32.0;
  
  // Border radius
  static const double radiusSm = 4.0;
  static const double radiusMd = 8.0;
  static const double radiusLg = 12.0;
  static const double radiusXl = 16.0;
  
  // Shadows
  static const BoxShadow shadowSm = BoxShadow(
    offset: Offset(0, 1),
    blurRadius: 2,
    color: Color(0x0D000000),
  );
  
  // Animation durations
  static const Duration animationFast = Duration(milliseconds: 150);
  static const Duration animationMedium = Duration(milliseconds: 250);
  static const Duration animationSlow = Duration(milliseconds: 400);
}
```

#### Custom Widget Examples
```dart
// Timer Display Widget
class TimerDisplay extends StatelessWidget {
  final Duration duration;
  final bool isActive;
  final TimerSize size;
  
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: DesignTokens.animationMedium,
      curve: Curves.easeOut,
      child: Text(
        _formatDuration(duration),
        style: _getTimerTextStyle(size, isActive),
      ),
    );
  }
  
  TextStyle _getTimerTextStyle(TimerSize size, bool isActive) {
    final baseStyle = Theme.of(context).textTheme;
    final color = isActive 
      ? DesignTokens.focusPurple 
      : DesignTokens.gray900;
      
    switch (size) {
      case TimerSize.large:
        return baseStyle.displayLarge?.copyWith(
          fontFamily: 'JetBrains Mono',
          fontWeight: FontWeight.w300,
          color: color,
        );
      // ... other sizes
    }
  }
}
```

### 10.2 Component Implementation Guidelines

#### Button Components
```dart
// Primary Button Implementation
class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Widget? leadingIcon;
  
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: DesignTokens.primaryBlue,
        foregroundColor: Colors.white,
        disabledBackgroundColor: DesignTokens.gray300,
        disabledForegroundColor: DesignTokens.gray500,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: DesignTokens.spaceLg,
          vertical: DesignTokens.spaceMd,
        ),
      ),
      child: isLoading 
        ? SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (leadingIcon != null) ...[
                leadingIcon!,
                SizedBox(width: DesignTokens.spaceSm),
              ],
              Text(text),
            ],
          ),
    );
  }
}
```

#### Card Components
```dart
// Standard Card Implementation
class StandardCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).cardColor,
      borderRadius: BorderRadius.circular(DesignTokens.radiusLg),
      elevation: 1,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(DesignTokens.radiusLg),
        child: Container(
          padding: padding ?? EdgeInsets.all(DesignTokens.spaceLg),
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).dividerColor,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(DesignTokens.radiusLg),
          ),
          child: child,
        ),
      ),
    );
  }
}
```

### 10.3 Layout Implementation Patterns

#### Responsive Grid System
```dart
class ResponsiveGrid extends StatelessWidget {
  final List<Widget> children;
  final double crossAxisSpacing;
  final double mainAxisSpacing;
  
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int columns = _calculateColumns(constraints.maxWidth);
        
        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: crossAxisSpacing,
            mainAxisSpacing: mainAxisSpacing,
            childAspectRatio: _calculateAspectRatio(columns),
          ),
          itemCount: children.length,
          itemBuilder: (context, index) => children[index],
        );
      },
    );
  }
  
  int _calculateColumns(double width) {
    if (width >= 1440) return 4;
    if (width >= 1024) return 3;
    if (width >= 768) return 2;
    return 1;
  }
}
```

#### Dashboard Layout Structure
```dart
class DashboardLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Sidebar
          Container(
            width: 280,
            child: NavigationSidebar(),
          ),
          
          // Main Content
          Expanded(
            child: Column(
              children: [
                // Header
                Container(
                  height: 64,
                  child: TopNavigationBar(),
                ),
                
                // Content Area
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(DesignTokens.spaceXl),
                    child: DashboardContent(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
```

### 10.4 Animation Implementation

#### Custom Animation Controllers
```dart
class FadeSlideTransition extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Offset offset;
  
  @override
  _FadeSlideTransitionState createState() => _FadeSlideTransitionState();
}

class _FadeSlideTransitionState extends State<FadeSlideTransition>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: widget.offset,
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));
    
    _controller.forward();
  }
  
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return SlideTransition(
          position: _slideAnimation,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: widget.child,
          ),
        );
      },
    );
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
```

### 10.5 Accessibility Implementation

#### Screen Reader Support
```dart
class AccessibleTimerDisplay extends StatelessWidget {
  final Duration duration;
  final bool isRunning;
  
  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: _buildSemanticLabel(),
      liveRegion: true,
      child: TimerDisplay(
        duration: duration,
        isActive: isRunning,
        size: TimerSize.large,
      ),
    );
  }
  
  String _buildSemanticLabel() {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    final seconds = duration.inSeconds % 60;
    
    String timeText = '';
    if (hours > 0) timeText += '$hours hours, ';
    if (minutes > 0) timeText += '$minutes minutes, ';
    timeText += '$seconds seconds';
    
    return isRunning 
      ? 'Timer running: $timeText'
      : 'Timer stopped at: $timeText';
  }
}
```

#### Focus Management
```dart
class FocusableCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onActivate;
  
  @override
  _FocusableCardState createState() => _FocusableCardState();
}

class _FocusableCardState extends State<FocusableCard> {
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;
  
  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
  }
  
  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: _focusNode,
      onKey: _handleKeyPress,
      child: Container(
        decoration: BoxDecoration(
          border: _isFocused 
            ? Border.all(
                color: DesignTokens.primaryBlue,
                width: 2,
              )
            : null,
          borderRadius: BorderRadius.circular(DesignTokens.radiusLg),
        ),
        child: widget.child,
      ),
    );
  }
  
  KeyEventResult _handleKeyPress(FocusNode node, RawKeyEvent event) {
    if (event is RawKeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.enter ||
          event.logicalKey == LogicalKeyboardKey.space) {
        widget.onActivate?.call();
        return KeyEventResult.handled;
      }
    }
    return KeyEventResult.ignored;
  }
  
  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }
}
```

---

## 11. Asset Requirements & Specifications

### 11.1 Icon System

#### Icon Library
```
Primary: Feather Icons (consistent, minimal style)
Backup: Phosphor Icons or Heroicons
Format: SVG (scalable, crisp rendering)
Sizes: 16px, 20px, 24px, 32px (multiples of 4)
```

#### Required Icons
```
Navigation:
- Dashboard: home
- Projects: folder
- Calendar: calendar
- Analytics: bar-chart-2
- Settings: settings

Actions:
- Play: play
- Pause: pause
- Stop: square
- Edit: edit-2
- Delete: trash-2
- Add: plus
- Search: search
- Filter: filter
- Export: download
- Import: upload

Status:
- Success: check-circle
- Warning: alert-triangle
- Error: alert-circle
- Info: info
- Loading: loader (animated)

Wellness:
- Break: coffee
- Health: heart
- Exercise: activity
- Focus: eye
- Notification: bell
```

#### Icon Implementation
```dart
class AppIcons {
  static const String iconPath = 'assets/icons/';
  
  // Navigation icons
  static const IconData dashboard = FeatherIcons.home;
  static const IconData projects = FeatherIcons.folder;
  static const IconData calendar = FeatherIcons.calendar;
  
  // Custom SVG icons for specific needs
  static Widget customIcon(String name, {
    double size = 24,
    Color? color,
  }) {
    return SvgPicture.asset(
      '$iconPath$name.svg',
      width: size,
      height: size,
      color: color,
    );
  }
}
```

### 11.2 Illustration Requirements

#### Empty States
```
Purpose: Guide users when no data exists
Style: Minimal line art, single color
Format: SVG
Size: 240×180px
Colors: Gray 400 (#9CA3AF) with optional accent color

Required Illustrations:
- No Projects: Folder with plus icon
- No Time Entries: Clock with question mark  
- No Analytics: Chart with dotted lines
- Error State: Document with X mark
- Offline State: Cloud with slash
```

#### Onboarding Graphics
```
Purpose: Welcome new users, explain features
Style: Consistent with empty states
Format: SVG
Size: 320×240px
Colors: Primary Blue accent with gray elements

Concepts:
- Welcome: Handshake or greeting gesture
- Timer Setup: Clock with settings gear
- Project Creation: Folder being created
- First Session: Play button with timer
```

### 11.3 Application Icons

#### Desktop Application Icons
```
Sizes Required:
- 16×16px   (taskbar, small)
- 32×32px   (standard)
- 48×48px   (medium)
- 64×64px   (large)
- 128×128px (extra large)
- 256×256px (high DPI)
- 512×512px (retina)

Design Elements:
- Simple stopwatch or clock icon
- Primary Blue (#0066CC) background
- White symbol
- Rounded corners (20% of size)
- Subtle shadow for depth
```

#### Favicon Design
```
Sizes: 16×16, 32×32, 48×48
Format: ICO file with PNG fallbacks
Design: Simplified version of app icon
Colors: Primary Blue background, white symbol
```

### 11.4 Brand Assets

#### Logo Variations
```
Primary Logo:
- Wordmark: "Trackich" in custom typography
- Symbol: Stylized clock/timer icon
- Lockup: Symbol + wordmark horizontal

Variations:
- Horizontal lockup (primary)
- Vertical lockup (compact spaces)
- Symbol only (very small spaces)
- Monochrome versions (accessibility)

Colors:
- Primary: Primary Blue (#0066CC) on white
- Reversed: White on Primary Blue
- Monochrome: Gray 900 (#111827)
```

#### Typography Logo
```
Font: Custom modification of Inter
Weight: 600 (Semibold)
Character spacing: -0.02em (tight)
Modifications: Rounded 'k' characters
Size relationships: Consistent with system typography
```

### 11.5 Asset Organization

#### File Structure
```
assets/
├── icons/
│   ├── navigation/
│   ├── actions/  
│   ├── status/
│   └── wellness/
├── illustrations/
│   ├── empty-states/
│   ├── onboarding/
│   └── errors/
├── logos/
│   ├── primary/
│   ├── variations/
│   └── app-icons/
└── brand/
    ├── wordmarks/
    └── symbols/
```

#### Naming Conventions
```
Format: kebab-case
Pattern: [category]-[name]-[variant].[extension]

Examples:
- icon-play-24.svg
- illustration-no-projects.svg
- logo-primary-horizontal.svg
- app-icon-512.png
- brand-wordmark-white.svg
```

#### Export Specifications
```
SVG Icons:
- Viewbox: 0 0 24 24 (for 24px icons)
- Stroke width: 1.5px (consistent)
- No fills (stroke only for flexibility)
- Optimized code (remove unnecessary elements)

PNG Icons:
- High DPI: 2x and 3x variants
- Transparency: Maintained where needed
- Compression: Optimized for file size
- Color profile: sRGB
```

---

## 12. Performance & Technical Considerations

### 12.1 UI Performance Guidelines

#### Rendering Performance
```
Target: 60 FPS for all animations
Smooth Scrolling: Hardware acceleration
Efficient Layouts: Minimize rebuild frequency
Image Optimization: Proper sizing and compression

Flutter-Specific:
- Use const constructors where possible
- Implement efficient list builders
- Optimize widget trees (avoid deep nesting)
- Use AutomaticKeepAliveClientMixin for tab content
```

#### Memory Management
```
Image Caching: Reasonable cache limits
State Management: Proper disposal of controllers
Animation Controllers: Always dispose
Large Lists: Implement pagination or virtual scrolling

Guidelines:
- Dispose of resources in widget dispose()
- Use weak references where appropriate
- Monitor memory usage in development
- Test with large datasets
```

### 12.2 Responsive Performance

#### Window Resizing
```
Smooth Transitions: Use LayoutBuilder efficiently
State Preservation: Maintain user context during resize
Breakpoint Changes: Graceful layout transitions
Performance: Avoid expensive calculations during resize
```

#### Cross-Platform Considerations
```
Windows: Native window controls integration
macOS: Proper title bar handling
Linux: Various desktop environment support
Font Rendering: Consistent across platforms
```

### 12.3 Accessibility Performance

#### Screen Reader Performance
```
Efficient ARIA: Avoid excessive live regions
Semantic Updates: Batch related changes
Focus Management: Smooth focus transitions
Text Alternatives: Provide without performance penalty
```

#### Animation Performance
```
Reduced Motion: Honor system preferences
Alternative Feedback: Non-visual alternatives
Battery Consideration: Disable animations when needed
CPU Usage: Monitor animation overhead
```

---

This comprehensive UI/UX design specification provides everything needed to implement Trackich with a professional, Claude-style interface. The specification balances visual appeal with functional efficiency, ensuring the application serves its core purpose of time tracking while maintaining an excellent user experience.

The design system is built to scale, with clear component definitions and implementation guidelines that will help maintain consistency as the application grows and evolves.