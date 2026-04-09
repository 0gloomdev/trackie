# Master CRD - Aura Learning (Trackie)

## Document Information
- **Created**: 2026-04-08
- **Version**: 1.0
- **Status**: Active Development
- **Author**: Development Team

---

## 1. Project Overview

### 1.1 Basic Information

| Property | Value |
|----------|-------|
| Project Name | Aura Learning |
| Package Name | trackie |
| Type | Cross-platform Flutter Learning Management App |
| Platform | Linux, macOS, Windows, iOS, Android |
| Min Flutter SDK | 3.0.0 |
| Dart SDK | >=3.0.0 |

### 1.2 Technology Stack

| Layer | Technology |
|-------|------------|
| Framework | Flutter 3+ |
| Language | Dart 3+ |
| State Management | Riverpod (flutter_riverpod) |
| Local Storage | Hive (hive_flutter) |
| Animations | flutter_animate |
| Architecture | Clean Architecture |

### 1.3 Directory Structure

```
trackie/
├── lib/
│   ├── core/
│   │   ├── constants/     # App constants
│   │   ├── services/     # Business services
│   │   ├── theme/       # Design system
│   │   ├── utils/       # Utilities
│   │   └── widgets/     # Shared widgets
│   ├── data/
│   │   ├── models/      # Data models
│   │   └── repositories/ # Data layer
│   ├── domain/
│   │   └── providers/  # State management
│   ├── presentation/
│   │   └── screens/   # UI screens
│   └── main.dart
├── test/
└── pubspec.yaml
```

---

## 2. Architecture

### 2.1 Clean Architecture Layers

```
┌─────────────────────────────────────────┐
│           PRESENTATION LAYER            │
│  (Screens, Widgets, Components)         │
├─────────────────────────────────────────┤
│             DOMAIN LAYER                 │
│  (Providers, Notifiers, Business Logic)   │
├─────────────────────────────────────────┤
│              DATA LAYER                 │
│  (Repositories, Models, Hive Boxes)     │
└─────────────────────────────────────────┘
```

### 2.2 Data Flow

1. **UI触发** → Screen calls Provider method
2. **Domain处理** → Notifier processes business logic
3. **Data持久化** → Repository saves to Hive
4. **状态更新** → UI rebuilds via Riverpod

---

## 3. Data Models

### 3.1 Core Entities

#### LearningItem
**Purpose**: Core learning content entity

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| id | String | UUID | Unique identifier |
| title | String | - | Item title (required) |
| type | String | - | Content type: course, video, book, pdf, podcast, article |
| description | String? | null | Item description |
| url | String? | null | External URL |
| urlFavicon | String? | null | URL favicon |
| urlThumbnail | String? | null | URL thumbnail |
| localPath | String? | null | Local file path |
| progress | int | 0 | Progress percentage (0-100) |
| status | String | pending | pending, in_progress, completed |
| priority | String? | null | low, medium, high |
| categoryId | String? | null | Category reference |
| tags | List<String> | [] | Tag list |
| notes | String? | null | Personal notes |
| isFavorite | bool | false | Favorite flag |
| isPinned | bool | false | Pinned flag |
| lastAccessedAt | DateTime? | null | Last access time |
| createdAt | DateTime | now | Creation timestamp |
| updatedAt | DateTime | now | Update timestamp |

**JSON Schema**:
```json
{
  "id": "uuid-string",
  "title": "Flutter Complete Guide",
  "type": "course",
  "description": "Complete Flutter course",
  "url": "https://...",
  "progress": 50,
  "status": "in_progress",
  "priority": "high",
  "categoryId": "cat-uuid",
  "tags": ["flutter", "dart"],
  "isFavorite": true,
  "isPinned": false,
  "createdAt": "2026-01-01T00:00:00.000Z",
  "updatedAt": "2026-01-15T00:00:00.000Z"
}
```

---

#### Category
**Purpose**: Content categorization

| Field | Type | Default |
|-------|------|-------|
| id | String | UUID |
| name | String | - |
| color | int | 0xFF6366F1 |
| createdAt | DateTime | now |

---

#### Tag
**Purpose**: Content tagging

| Field | Type | Default |
|-------|------|-------|
| id | String | UUID |
| name | String | - |
| color | int | 0xFF6366F1 |
| category | String? | null |
| usageCount | int | 0 |
| createdAt | DateTime | now |

---

#### AppSettings
**Purpose**: Application configuration

| Field | Type | Default |
|-------|------|-------|
| theme | String | system |
| showOnboarding | bool | true |
| notificationsEnabled | bool | true |
| pomodoroNotifications | bool | true |
| achievementsNotifications | bool | true |
| defaultView | String | grid |
| compactMode | bool | false |
| pinLockEnabled | bool | false |
| pinCode | String? | null |
| autoBackupEnabled | bool | false |
| autoBackupFrequency | int | 7 |
| lastBackupDate | DateTime? | null |
| locale | String | en |

---

### 3.2 Engagement Entities

#### DailyGoal
**Purpose**: Daily learning targets

| Field | Type | Default |
|-------|------|-------|
| id | String | Date string |
| date | DateTime | now |
| itemsToComplete | int | 3 |
| itemsCompleted | int | 0 |
| minutesToStudy | int | 30 |
| minutesStudied | int | 0 |
| completed | bool | false |

---

#### Reminder
**Purpose**: Scheduled notifications

| Field | Type | Default |
|-------|------|-------|
| id | String | UUID |
| title | String | - |
| message | String? | null |
| scheduledTime | DateTime | - |
| itemId | String? | null |
| isCompleted | bool | false |
| repeatType | String | once |
| daysOfWeek | List<int>? | null |

---

#### LearningSession
**Purpose**: Study session tracking

| Field | Type | Default |
|-------|------|-------|
| id | String | UUID |
| itemId | String? | null |
| type | String | pomodoro |
| durationMinutes | int | 25 |
| startTime | DateTime | now |
| endTime | DateTime? | null |
| completed | bool | false |
| notes | String? | null |

---

#### PomodoroSession
**Purpose**: Pomodoro timer sessions

| Field | Type | Default |
|-------|------|-------|
| id | String | timestamp |
| startTime | DateTime | now |
| endTime | DateTime? | null |
| durationMinutes | int | 25 |
| relatedItemId | String? | null |
| completed | bool | false |

---

### 3.3 Gamification Entities

#### UserProfile
**Purpose**: User statistics and progress

| Field | Type | Default |
|-------|------|-------|
| id | String | timestamp |
| nombre | String | Usuario |
| avatarUrl | String? | null |
| nivel | int | 1 |
| xp | int | 0 |
| streak | int | 0 |
| longestStreak | int | 0 |
| lastActivityDate | DateTime? | null |
| createdAt | DateTime | now |

**Level Calculation**: `level = (xp / 100) + 1` (simplified)

---

#### Achievement
**Purpose**: Gamification milestones

| Field | Type | Default |
|-------|------|-------|
| id | String | - |
| title | String | - |
| description | String | - |
| icon | String | - |
| unlocked | bool | false |
| unlockedAt | DateTime? | null |
| xpReward | int | 0 |
| type | String | milestone |

**Default Achievements**:
- primer_paso (50 XP) - Complete first item
- avido (100 XP) - Complete 5 items
- estudiante (150 XP) - Complete 10 items
- bibliotecario (250 XP) - Complete 25 items
- maestro (500 XP) - Complete 50 items
- velocista (75 XP) - Complete in <24 hours
- racha_7 (100 XP) - 7-day streak
- racha_30 (300 XP) - 30-day streak
- coleccionista (100 XP) - 10 favorites
- prioritas (100 XP) - 5 urgent items
- analista (50 XP) - View stats 20 times
- noctambulo (25 XP) - Study after midnight

---

### 3.4 Social Entities

#### CommunityPost
**Purpose**: Social feed posts

| Field | Type | Default |
|-------|------|-------|
| id | String | timestamp |
| type | String | item_completed |
| content | String | - |
| timestamp | DateTime | now |
| anonymous | bool | true |
| userId | String? | null |
| userName | String? | null |
| userAvatar | String? | null |
| likes | int | 0 |
| comments | List<Comment> | [] |
| relatedItemId | String? | null |
| relatedAchievementId | String? | null |
| isUserPost | bool | false |

---

#### Comment
**Purpose**: Post comments

| Field | Type | Default |
|-------|------|-------|
| id | String | timestamp |
| userId | String | - |
| userName | String | - |
| content | String | - |
| timestamp | DateTime | now |

---

### 3.5 Notes Entities

#### Note
**Purpose**: Note-taking system

| Field | Type | Default |
|-------|------|-------|
| id | String | UUID |
| title | String | - |
| content | String | - |
| itemId | String? | null |
| tags | List<String> | [] |
| isPinned | bool | false |
| createdAt | DateTime | now |
| updatedAt | DateTime | now |

---

### 3.6 Analytics Entities

#### StreakAnalytics
**Purpose**: Streak tracking

| Field | Type | Default |
|-------|------|-------|
| currentStreak | int | 0 |
| longestStreak | int | 0 |
| lastActivityDate | DateTime? | null |
| weeklyActivity | List<DailyActivity> | [] |
| monthlyCompletions | Map<String,int> | {} |

---

#### DailyActivity
**Purpose**: Daily analytics

| Field | Type | Default |
|-------|------|-------|
| date | DateTime | now |
| itemsCompleted | int | 0 |
| minutesStudied | int | 0 |
| xpEarned | int | 0 |

---

### 3.7 Support Entities

#### FAQ
**Purpose**: Help content

| Field | Type |
|-------|------|
| pregunta | String |
| respuesta | String |
| categoria | String |

---

#### CustomDomain
**Purpose**: Custom domain configuration

| Field | Type | Default |
|-------|------|-------|
| id | String | timestamp |
| domain | String | - |
| status | DomainVerificationStatus | pending |
| description | String? | null |
| verificationCode | String? | null |
| createdAt | DateTime | now |
| verifiedAt | DateTime? | null |
| errorMessage | String? | null |

**DomainVerificationStatus**: pending, verifying, verified, failed

---

## 4. Repositories

### 4.1 Repository List

| Repository | Box Name | Purpose |
|-----------|---------|----------|
| LearningRepository | learning_items | Learning content CRUD |
| CategoryRepository | categories | Category CRUD |
| TagRepository | tags | Tag CRUD |
| SettingsRepository | settings | App settings |
| AchievementsRepository | achievements | Achievement management |
| ProfileRepository | profile | User profile |
| CommunityRepository | community | Social posts |
| NotesRepository | notes | Notes CRUD |
| RemindersRepository | reminders | Reminders CRUD |
| LearningSessionsRepository | learning_sessions | Session tracking |

### 4.2 LearningRepository Methods

```dart
// CRUD Operations
List<LearningItem> getAll()
List<LearningItem> getByType(String type)
List<LearningItem> getByStatus(String status)
List<LearningItem> getFavorites()
LearningItem? getById(String id)
Future<void> add(LearningItem item)
Future<void> update(LearningItem item)
Future<void> delete(String id)
Future<void> deleteAll()
List<LearningItem> search(String query)

// Statistics
int get totalCount
int get completedCount
int get inProgressCount
int get pendingCount
Map<String, int> getCountByType()
Map<String, int> getCountByStatus()

// Import/Export
List<Map<String, dynamic>> exportToJson()
Future<void> importFromJson(List<dynamic> data)
```

### 4.3 SettingsRepository Methods

```dart
AppSettings get()
Future<void> save(AppSettings s)
Map<String, dynamic> exportToJson()
Future<void> importFromJson(Map<String, dynamic> data)
```

---

## 5. Providers

### 5.1 Provider Groups

#### Core Providers
| Provider | Type | Purpose |
|----------|------|----------|
| settingsProvider | StateNotifier | App settings |
| learningItemsProvider | StateNotifier | Learning items |
| categoriesProvider | StateNotifier | Categories |
| tagsProvider | StateNotifier | Tags |
| achievementsProvider | StateNotifier | Achievements |
| userProfileProvider | StateNotifier | User profile |

#### Filter Providers
| Provider | Type | Purpose |
|----------|------|----------|
| filterProvider | StateProvider | Active filters |
| filteredItemsProvider | Provider | Filtered items |
| advancedFilteredItemsProvider | Provider | Advanced filter |
| searchProvider | StateProvider | Search query |
| searchHistoryProvider | StateNotifier | Search history |

#### Analytics Providers
| Provider | Type | Purpose |
|----------|------|----------|
| statisticsProvider | Provider | Basic stats |
| analyticsProvider | Provider | Full analytics |
| dailyGoalsProvider | StateNotifier | Daily goals |
| pomodoroStateProvider | StateProvider | Timer state |
| pomodoroTimeProvider | StateProvider | Timer value |
| pomodoroSessionsProvider | StateNotifier | Pomodoro sessions |

#### Feature Providers
| Provider | Type | Purpose |
|----------|------|----------|
| communityFeedProvider | StateNotifier | Social feed |
| notesProvider | StateNotifier | Notes |
| remindersProvider | StateNotifier | Reminders |
| learningSessionsProvider | StateNotifier | Learning sessions |
| customDomainsProvider | StateNotifier | Custom domains |

### 5.2 Derived Providers

```dart
// Item Providers
final pinnedItemsProvider = Provider<List<LearningItem>>((ref) { ... })
final favoriteItemsProvider = Provider<List<LearningItem>>((ref) { ... })
final recentInProgressItemsProvider = Provider<List<LearningItem>>((ref) { ... })
final recentItemsProvider = Provider<List<LearningItem>>((ref) { ... })

// Streak Providers
final nextStreakMilestoneProvider = Provider<int>((ref) { ... })
final streakProgressProvider = Provider<double>((ref) { ... })
final streakDaysRemainingProvider = Provider<int>((ref) { ... })
final achievedMilestonesProvider = Provider<List<int>>((ref) { ... })

// Study Time Providers
final todayStudyMinutesProvider = Provider<int>((ref) { ... })
final todaySessionsCountProvider = Provider<int>((ref) { ... })
final weeklyStudyMinutesProvider = Provider<Map<String, int>>((ref) { ... })
final totalStudyMinutesProvider = Provider<int>((ref) { ... })
```

---

## 6. Customization Settings

### 6.1 Visual Settings

| Setting | Type | Default | Description |
|---------|------|---------|-------------|
| themePreset | String | cosmic | Theme preset |
| accentColor | int | 0xFFd3bfff | Primary accent |
| secondaryColor | int | 0xFF5ce6ff | Secondary accent |
| glassmorphismIntensity | double | 0.5 | Glass blur intensity |
| glassEffects | bool | true | Enable glass effects |
| neonAccents | bool | true | Enable neon effects |
| enableGlowEffects | bool | true | Enable glow effects |
| borderRadiusStyle | String | rounded | Corner style |
| animationStyle | String | smooth | Animation curve |
| showShimmerLoading | bool | true | Loading shimmer |

### 6.2 Layout Settings

| Setting | Type | Default |
|---------|------|---------|
| animationSpeed | double | 1.0 |
| fontScale | double | 1.0 |
| iconScale | double | 1.0 |
| compactMode | bool | false |
| layoutDensity | String | comfortable |
| enableAnimations | bool | true |
| enableHapticFeedback | bool | true |

### 6.3 Theme Presets

| ID | Name | Primary | Secondary | Style |
|----|------|---------|----------|--------|
| cosmic | Cosmic | 0xFFd3bfff | 0xFF5ce6ff | glassmorphism |
| ocean | Ocean | 0xFF5ce6ff | 0xFF22C55E | gradient |
| forest | Forest | 0xFF22C55E | 0xFF5ce6ff | flat |
| fire | Fire | 0xFFff6b35 | 0xFFfbbf24 | vibrant |
| void | Void | 0xFF8b5cf6 | 0xFFec4899 | dark |
| sunset | Sunset | 0xFFffb5c8 | 0xFFfb923c | soft |
| minimal | Minimal | 0xFF64748B | 0xFF94a3b8 | flat |
| brutalist | Brutalist | 0xFF000000 | 0xFFffffff | bold |
| neon | Neon | 0xFF39FF14 | 0xFF00FFFF | glow |
| pastel | Pastel | 0xFFFCE7F3 | 0xFFA7F3D0 | soft |
| oceanic | Oceanic | 0xFF0EA5E9 | 0xFF06B6D4 | gradient |
| sunset-glow | Sunset Glow | 0xFFFB923C | 0xFFF97316 | gradient |

### 6.4 Border Radius Styles

| ID | Name | Radius |
|----|------|--------|
| rounded | Rounded | 16px |
| square | Square | 4px |
| pill | Pill | 999px |
| mixed | Mixed | Varied |

### 6.5 Animation Styles

| ID | Name | Curve |
|----|------|-------|
| smooth | easeInOut |
| elastic | elasticOut |
| bounce | bounceOut |
| linear | linear |

### 6.6 Layout Density

| ID | Name | Spacing |
|----|------|--------|
| comfortable | Standard |
| compact | Tight |
| spacious | Extra room |

---

## 7. Screens

### 7.1 Main Screens (10)

| Screen | Route | Purpose |
|-------|-------|----------|
| Home | / | Dashboard with stats |
| Library | /library | Learning items grid |
| Courses | /courses | Course list |
| Achievements | /achievements | Gamification |
| Community | /community | Social feed |
| Notes | /notes | Note-taking |
| Reminders | /reminders | Notifications |
| Analytics | /analytics | Stats dashboard |
| Help | /help | FAQ support |
| Settings | /settings | App config |

### 7.2 Detail/Modal Screens (5+)

| Screen | Type | Purpose |
|-------|------|----------|
| EditorScreen | Modal | Create/edit items |
| SearchScreen | Full | Advanced search |
| PomodoroScreen | Full | Timer interface |
| ItemDetailScreen | Full | Item details |
| OnboardingScreen | Full | First-run flow |

### 7.3 Screen Features

#### Home Screen
- HeroSection (glass container with greeting)
- StatsGrid (4 stat cards)
- WeeklyChart (bar chart)
- AchievementsPreview (milestone grid)
- RecentItemsSection (horizontal scroll)

#### Library Screen
- Filter/Sort controls
- Grid/List view toggle
- Search integration
- Category filtering

#### Settings Screen
- Theme dialog (glass container)
- Customization options
- Data export/import
- About section

---

## 8. Design System

### 8.1 Color Scheme

#### Light Theme
| Token | Hex | Usage |
|-------|-----|-------|
| primary | 0xFF6366F1 | Main actions |
| secondary | 0xFF8B5CF6 | Secondary actions |
| tertiary | 0xFF22C55E | Success states |
| surface | 0xFFFAFAFA | Background |
| surfaceContainer | 0xFFF5F5F5 | Card backgrounds |
| onSurface | 0xFF18181B | Text |
| onSurfaceVariant | 0xFF71717A | Secondary text |
| outline | 0xFFE4E4E7 | Borders |

#### Dark Theme
| Token | Hex | Usage |
|-------|-----|-------|
| primary | 0xFF818CF8 | Main actions |
| secondary | 0xFFA78BFA | Secondary actions |
| tertiary | 0xFF34D399 | Success states |
| surface | 0xFF09090B | Background |
| surfaceContainer | 0xFF18181B | Card backgrounds |
| onSurface | 0xFFFAFAFA | Text |
| onSurfaceVariant | 0xFFA1A1AA | Secondary text |
| outline | 0xFF27272A | Borders |

#### Neon Accent Colors
| Name | Hex |
|------|------|
| neonPurple | 0xFFd3bfff |
| neonPurpleStrong | 0xFF9333EA |
| neonCyan | 0xFF5ce6ff |
| neonCyanStrong | 0xFF00D4FF |

### 8.2 Typography

| Style | Size | Weight | Line Height |
|-------|------|--------|-----------|
| heroTitle | 56px | 700 | 1.1 |
| cardTitle | 18px | 600 | 1.4 |
| sectionTitle | 24px | 700 | 1.3 |
| subtitle | 16px | 500 | 1.5 |
| body | 14px | 400 | 1.6 |
| bodySmall | 12px | 400 | 1.5 |
| typeBadge | 11px | 500 | 1.4 |
| caption | 11px | 400 | 1.4 |
| statValue | 32px | 700 | 1.2 |

### 8.3 Component Library

#### Glass Components
- GlassContainer - Frosted glass card
- NeonCard - Glowing card
- GlassButton - Glass button
- NeonIconButton - Glowing icon button
- ShimmerLoading - Loading placeholder

#### Shadcn Components
- ShadcnCard - Card wrapper
- ShadcnButton - Button variants
- ShadcnInput - Input field

### 8.4 Animation Specifications

| Animation | Duration | Curve |
|-----------|----------|-------|
| Fade in | 400ms | easeOut |
| Slide | 300ms | easeInOut |
| Scale | 200ms | easeOut |
| Glow pulse | 1500ms | easeInOut (loop) |
| Tab switch | 300ms | easeOut |

---

## 9. Feature Implementation Matrix

### 9.1 CRUD Coverage

| Entity | Create | Read | Update | Delete |
|--------|--------|------|--------|--------|
| LearningItem | ✅ | ✅ | ✅ | ✅ |
| Category | ✅ | ✅ | ✅ | ✅ |
| Tag | ✅ | ✅ | ✅ | ✅ |
| Note | ✅ | ✅ | ✅ | ✅ |
| Reminder | ✅ | ✅ | ✅ | ✅ |
| LearningSession | ✅ | ✅ | ✅ | ✅ |
| Achievement | ❌ | ✅ | ❌ | ❌ |
| UserProfile | ❌ | ✅ | ✅ | ❌ |
| CommunityPost | ✅ | ✅ | ❌ | ✅ |

### 9.2 Planned Features

| Feature | Priority | Status |
|---------|----------|--------|
| Advanced Analytics | P1 | Pending |
| Community Polls | P2 | Pending |
| Multimedia Notes | P2 | Pending |
| Custom Domains | P1 | Partial |
| Auto Backup | P1 | Partial |
| Pomodoro Timer | P1 | Implemented |
| Daily Goals | P1 | Implemented |

---

## 10. Keyboard Shortcuts (Desktop)

| Shortcut | Action |
|----------|--------|
| Ctrl+1-9 | Navigate tabs |
| Ctrl+F | Open search |
| Ctrl+P | Open Pomodoro |
| Ctrl+N | Create item |
| Ctrl+T | Toggle theme |

---

## 11. Dependencies

### 11.1 Core Dependencies

```yaml
dependencies:
  flutter_riverpod: ^2.4.9
  hive_flutter: ^1.1.0
  flutter_animate: ^4.3.0
  uuid: ^4.2.2
```

### 11.2 Development Dependencies

```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.1
```

---

## 12. Storage Schema

### 12.1 Hive Boxes

| Box Name | Type | Purpose |
|---------|------|----------|
| settings | dynamic | App settings |
| items | dynamic | Learning items |
| categories | dynamic | Categories |
| tags | dynamic | Tags |
| achievements | dynamic | Achievements |
| profile | dynamic | User profile |
| community | dynamic | Community posts |
| notes | dynamic | Notes |
| reminders | dynamic | Reminders |
| sessions | dynamic | Learning sessions |
| domains | dynamic | Custom domains |
| customization_v2 | dynamic | Customization settings |

---

## 13. Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0.0 | 2026-04-08 | Initial CRD created |
| | | | - 15 data models |
| | | | - 10 repositories |
| | | | | - 50+ providers |
| | | | | - 20+ customization settings |
| | | | - Glass design system |

---

*End of Master CRD*