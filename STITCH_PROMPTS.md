# Stitch UI Prompts - Aura Learning App

Basado en DESIGN.md y la estructura actual de la app.

---

## Configuración General del Proyecto

```
Project: Aura Learning (Trackie)
Type: Cross-platform Learning Management App
Platform: Responsive web (desktop-first, tablet, mobile)
Style: Glassmorphism dark theme, Cosmic Nebula aesthetic
Primary Color: #d3bfff (Luminous Lavender)
Secondary Color: #5ce6ff (Neon Cyan)
Background: #0b1325 (Cosmic Navy)
Card Background: #171f32 (Nebula Dark)
Border Radius: 12-20px
Blur Effect: 25px sigma for glass elements
Typography: Space Grotesk (headlines), Manrope (body), Inter (labels)
```

---

## Pestaña 1: HOME (Dashboard)

```
Learning management dashboard for Aura Learning app

Layout:
- Left sidebar with navigation icons (Home, Library, Courses, Achievements, Community, Notes, Reminders, Analytics, Help, Settings)
- Top bar with search input, notifications bell, user profile avatar
- Hero section with greeting "Welcome back" and user name, gradient background
- Stats grid showing: Total Items, Completed, In Progress, XP Points
- Weekly activity chart (bar chart with 7 days)
- Achievements preview (3-4 achievement badges)
- Recent items horizontal scroll (cards with thumbnail, title, progress bar)

Visual Style:
- Dark glassmorphism theme with purple/cyan neon accents
- Frosted glass effect (blur 25px) on sidebar and cards
- Subtle glow effects on hover (15px blur, 30% opacity)
- Card border radius: 20px
- Spacing: 24px between sections

Interactions:
- Hover on cards: subtle scale (1.02) and glow effect
- Click on stats cards: navigate to detail
- Horizontal scroll with grab cursor
- Sidebar items: glow highlight on active

Platform: Desktop (1440px), Tablet (1024px), Mobile (375px)
```

---

## Pestaña 2: LIBRARY (Learning Items Grid)

```
Learning library grid for Aura Learning app

Layout:
- Filter bar at top: Type dropdown (All, Course, Video, Book, PDF, Podcast, Article), Status dropdown, Sort dropdown
- View toggle: Grid/List icons
- Search bar integrated
- Content grid: 3-4 columns on desktop, 2 on tablet, 1 on mobile
- Each card shows: thumbnail/icon, title, type badge, progress bar, status indicator, favorite star, category tag

Visual Style:
- Dark theme matching dashboard
- Cards with gradient border on hover (purple to cyan)
- Progress bars with glow effect
- Type badges with colors: purple for courses, cyan for videos, etc.

Interactions:
- Hover: card lifts with shadow, border glows
- Click card: navigate to item detail
- Favorite toggle: heart icon fills with animation
- Grid/list view toggle with smooth transition

Platform: Responsive
```

---

## Pestaña 3: COURSES

```
Courses listing screen for Aura Learning app

Layout:
- Hero section with "Continue Learning" title
- Active course cards (large format) with:
  - Large thumbnail/image area
  - Course title and description
  - Progress percentage and progress bar
  - Continue button
- "Browse Courses" section below with smaller course cards
- Category filters: horizontal chips (All, Development, Design, Business, Science)

Visual Style:
- Course cards with image backgrounds
- Progress overlays with gradient (purple at bottom)
- "Continue" button with primary purple glow

Interactions:
- Click Continue: expand course detail or start learning
- Hover on course: show "View Details" overlay
- Category chips: filter with fade transition

Platform: Responsive
```

---

## Pestaña 4: ACHIEVEMENTS (Gamification)

```
Achievements and progress screen for Aura Learning app

Layout:
- User level badge at top with XP counter
- Level progress bar (shows progress to next level)
- Achievement badges grid (4 columns):
  - Locked: grayed out with lock icon
  - Unlocked: full color with glow
  - Badge icon, title, description, XP reward
- Stats row: Current Streak, Longest Streak, Total XP, Badges Unlocked
- Milestones timeline showing progress

Visual Style:
- Unlocked badges have neon glow effect
- Progress bars with gradient (purple to cyan)
- Level badge with circular design and glow

Interactions:
- Hover on badge: show tooltip with details
- Click unlocked badge: show celebration animation
- Click locked badge: show hint for unlocking

Platform: Responsive
```

---

## Pestaña 5: COMMUNITY (Social Feed)

```
Community feed for Aura Learning app

Layout:
- Left side (desktop): User stats (level, streak, completed items)
- Main area: Social feed with post cards
- Right side (desktop): Active polls section
- Post card shows:
  - User avatar and name (or "Anonymous")
  - Post type icon (item_completed, level_up, streak_milestone, etc.)
  - Content text
  - Timestamp
  - Like button and count
  - Comments section (expandable)
- Polls section with voting options and percentage bars

Visual Style:
- Posts with subtle glass effect
- Poll bars with gradient fills
- Achievement/celebration posts have special glow

Interactions:
- Like button: heart fills with micro-animation
- Click comment: expand comments section
- Click poll option: vote with instant percentage update
- Pull to refresh (mobile)

Platform: Responsive (sidebar hidden on mobile)
```

---

## Pestaña 6: NOTES

```
Notes management screen for Aura Learning app

Layout:
- Header with "Notes" title and Add Note button (+ icon)
- Search bar
- Notes grid/list with cards:
  - Title (or "Untitled" if empty)
  - Content preview (2 lines max)
  - Tags as chips
  - Created date
  - Pin icon (if pinned)
- Filter tabs: All, Pinned, Recent

Visual Style:
- Note cards with subtle border
- Tags as small pills with colors
- Type indicators for multimedia notes (image icon, mic icon)

Interactions:
- Click note: open note editor
- Click pin: toggle pin with animation
- Click tag: filter by tag
- Swipe to delete (mobile)

Platform: Responsive
```

---

## Pestaña 7: REMINDERS

```
Reminders and notifications screen for Aura Learning app

Layout:
- Header with "Reminders" title and Add Reminder button
- Toggle: Active / Completed tabs
- Reminder cards:
  - Time display (large)
  - Title and message
  - Repeat indicator (if recurring)
  - Toggle switch for enable/disable
- Empty state when no reminders

Visual Style:
- Time display prominent with secondary color
- Toggle switches with neon accent
- Active reminders have subtle glow

Interactions:
- Toggle: enable/disable with animation
- Click card: expand to edit
- Swipe to delete (mobile)

Platform: Responsive
```

---

## Pestaña 8: ANALYTICS

```
Analytics dashboard for Aura Learning app

Layout:
- Header with "Analytics" title and time filter (Week/Month/Year)
- Stats overview row: Total Study Time, Sessions, Streak, Focus Score
- Weekly Activity Distribution (bar chart, 7 bars)
- Learning Performance card:
  - Deep Focus Sessions progress bar
  - Information Retention progress bar
  - Peer Engagement progress bar
- Pomodoro Stats section:
  - Total focus periods count
  - Total flow time
  - Start Focus Session button
- Advanced Insights section:
  - Focus Score card with percentage
  - Consistency Score card with percentage
  - Peak Hour display
  - Growth indicators (week-over-week, month-over-month)

Visual Style:
- Progress bars with gradient fills and glow
- Chart bars with gradient (purple to cyan)
- Focus Score and Consistency as circular gauges
- Button with primary glow effect

Interactions:
- Time filter: smooth chart transition
- Hover on chart bars: show tooltip with value
- Click Start Focus Session: open Pomodoro timer

Platform: Desktop-focused (charts need space)
```

---

## Pestaña 9: HELP

```
Help and support screen for Aura Learning app

Layout:
- Header with "Help" title and search
- FAQ accordion sections:
  - Getting Started
  - Using the App
  - Account & Settings
  - Troubleshooting
- Each FAQ item: question (clickable), expandable answer
- Quick Links section with 4 cards:
  - Video Tutorials (icon: play_circle)
  - Documentation (icon: description)
  - Contact Support (icon: support_agent)
  - Community Forum (icon: forum)
- Footer with version info and links

Visual Style:
- Accordion with smooth expand/collapse
- Quick link cards with icon, title, subtitle
- Cards with subtle hover glow

Interactions:
- Click question: expand/collapse answer
- Hover quick link: scale and glow
- Search FAQ: filter results in real-time

Platform: Responsive
```

---

## Pestaña 10: SETTINGS

```
Settings screen for Aura Learning app

Layout:
- Header with "Settings" title
- Settings sections:
  - Appearance:
    - Theme selector (System/Light/Dark)
    - Accent color picker
    - Glass effects toggle
    - Neon accents toggle
    - Animation toggle
  - Personalization:
    - Compact mode toggle
    - Layout density (Compact/Comfortable/Spacious)
    - Font scale slider
  - Notifications:
    - Push notifications toggle
    - Pomodoro notifications toggle
    - Achievement notifications toggle
  - Data:
    - Export data button
    - Import data button
    - Clear all data (with confirmation)
  - About:
    - Version info
    - Licenses
    - Rate app link

Visual Style:
- Toggle switches with neon accent
- Color picker with preset swatches
- Section headers with icons

Interactions:
- Toggle: smooth on/off animation
- Click export: show file picker
- Long press Clear: show confirmation dialog
- Hover on setting: subtle highlight

Platform: Responsive
```

---

## Navigation & Shell Común

```
App shell for Aura Learning (used across all screens)

Layout:
- Desktop: Left sidebar (320px) + main content area
- Tablet: Collapsed sidebar (icons only) + content
- Mobile: Bottom navigation bar + content
- Top bar (desktop/tablet): Search, notifications, profile
- Floating action button (mobile)

Sidebar Items (with icons):
- Home (dashboard icon)
- Library (collections icon)
- Courses (school icon)
- Achievements (emoji events icon)
- Community (groups icon)
- Notes (note icon)
- Reminders (alarm icon)
- Analytics (analytics icon)
- Help (help icon)
- Settings (settings icon)

Visual Style:
- Sidebar with frosted glass effect (blur 25px, 70% opacity)
- Active item: purple glow background
- Icons: 24px, white/gray, cyan on active
- Hover: subtle background glow

Interactions:
- Click item: navigate with fade transition
- Hover item: highlight with glow
- Desktop: sidebar collapsible with toggle

Platform: Responsive (desktop-first)
```

---

## Nota de Implementación

Estos prompts están diseñados para ser usados con Google Stitch. El diseño actual de la app ya implementa muchos de estos elementos, pero los prompts pueden servir para:

1. **Regenerar pantallas** con mejor distribución
2. **Crear variantes** explorando diferentes direcciones de diseño
3. **Exportar a HTML/CSS** para componentes específicos
4. **Iterar y refinar** elementos específicos

Los colores y estilos deben coincidir con DESIGN.md para mantener consistencia.