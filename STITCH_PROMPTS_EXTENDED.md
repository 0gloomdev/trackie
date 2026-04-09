# STITCH PROMPTS EXTENDED - Trackie Liquid Nebula

## Using These Prompts

These prompts are designed to be used directly in Google Stitch (stitch.withgoogle.com) with the **Trackie Liquid Nebula PRD** project. They follow the Liquid Nebula design system with glassmorphism, neon glows, and deep space aesthetic.

## Design System Reference

**Colors:**
- Background: `#060e20` (Deep Space)
- Primary: `#d3bfff` (Violet Liquid) / `#ba9eff` (Purple)
- Secondary: `#5ce6ff` (Electric Cyan)
- Tertiary: `#ffb5c8` (Soft Rose)

**Effects:**
- Glassmorphism: 25-40px blur, white/15 to white/5 gradient
- Ghost Border: 1.5px white/20
- Neon Glow: 15px blur at 30% + 40px spread at 10%

---

## EXTENDED PROMPTS

### 1. HOME DASHBOARD

```
Trackie Home Dashboard for learning management app

Layout Structure:
- Top navigation bar with logo (left), search input (center-right), notification bell, profile avatar (right)
- Sidebar (260px, fixed left) with: logo area, user level/XP badge, nav items (Dashboard, Library, Courses, Achievements, Community, Notes, Reminders, Help), Settings at bottom
- Main content area with:
  - Welcome section with user greeting and streak counter
  - Quick stats row: Active Courses, Hours Learned, Current Streak, XP Points
  - Today's Focus card with top priority task
  - Recent Activity feed (last 5 items)
  - Recommended Content carousel
  - Upcoming Reminders list

Visual Style:
- Dark mode with Deep Space background (#060e20)
- Glassmorphic cards with 30px blur, gradient fill white/15 to white/5
- Accent colors: violet (#d3bfff) for primary actions, cyan (#5ce6ff) for highlights
- Typography: Inter font, Black 900 for headlines, 60% opacity for secondary text
- Hover states: translate-x 4px with cyan glow
- Active nav item: violet background with left border accent
- FAB (bottom right): gradient violet-to-cyan with pulsing neon glow

Interactions:
- Search input with glass effect and Ctrl+K hint
- Nav items slide on hover (translate-x)
- Cards have subtle entrance animation (fade + scale)
- Stats cards with icon containers and gradient backgrounds
- Progress bars with cyan glow effect
```

### 2. LIBRARY SCREEN

```
Trackie Library screen for content management

Layout Structure:
- Top bar with "Library" title, view toggle (Grid/List), sort dropdown, search
- Filter chips row: All, Courses, Notes, Bookmarks, Recent
- Content grid (3-4 columns on desktop, 2 on tablet, 1 on mobile)
- Each card shows: thumbnail image, title, category badge, progress bar, last accessed date

Visual Style:
- Cards with glass effect (25px blur, 1.5px white/20 border)
- Category badges with colored dots (Courses=violet, Notes=cyan, etc.)
- Progress bars with gradient fill and subtle glow
- Hover: scale 1.02 with enhanced shadow
- Empty state with illustration and "Add your first item" CTA

Components:
- Grid/List view toggle with icon buttons
- Sort dropdown (Name, Date, Progress)
- Search with glass styling
- Category filter chips (horizontal scroll on mobile)
- Content cards with rounded corners (16px), thumbnail ratio 16:9
```

### 3. ACHIEVEMENTS SCREEN

```
Trackie Achievements/Gamification screen

Layout Structure:
- Top bar with "Achievements" title, total points counter, level badge
- Level progress section: current level, XP to next level, progress bar
- Achievement categories tabs: All, Badges, Streaks, Milestones
- Achievement grid (badges):
  - Locked badges (grayscale, locked icon overlay)
  - Unlocked badges (full color, glow effect)
  - Each badge shows: icon, name, description, date earned
- Streak section: current streak flame, longest streak, calendar heatmap
- Leaderboard section (optional): top users with avatars and scores

Visual Style:
- Badge cards circular with glow effect when unlocked
- Locked badges have lock icon overlay with 30% opacity
- Level progress with gradient fill (violet to cyan)
- Streak flame icon with animated glow
- Calendar heatmap: days colored by activity intensity
- Category tabs with underline accent on active

Animations:
- Badge unlock celebration (scale + glow pulse)
- Progress bar fill animation on load
- Streak counter with number roll animation
```

### 4. SETTINGS SCREEN

```
Trackie Settings screen with customization options

Layout Structure:
- Top bar with "Settings" title
- Settings categories (vertical list, expandable):
  - Profile (avatar, name, email, bio)
  - Appearance (theme toggle, accent color picker, font size)
  - Notifications (push, email, reminders toggle switches)
  - Data & Privacy (export data, clear cache, privacy policy)
  - Subscription (plan tier, billing, upgrade CTA)
  - About (version, changelog, support link)

Visual Style:
- Each section is a glass card with header and content
- Toggle switches with cyan accent when on
- Color picker: preset palette + custom color input
- Avatar with edit overlay on hover
- Section headers with icon and label
- Danger actions (clear data) with red accent

Components:
- Theme toggle: Light/Dark/System radio buttons
- Accent color: 6 preset options in circular buttons
- Notification toggles with label and description
- Export button with file icon
- Version info in footer with copyable text
```

### 5. ANALYTICS SCREEN

```
Trackie Analytics/Dashboard with data visualization

Layout Structure:
- Top bar with "Analytics" title, date range selector, export button
- Summary metrics row (4 cards):
  - Total Learning Hours (with trend arrow)
  - Current Streak days
  - Tasks Completed
  - Focus Score percentage
- Charts section:
  - Weekly activity bar chart (hours per day)
  - Category pie chart (time distribution)
  - Productivity line graph (last 30 days)
- Insights panel: AI-generated tips and observations
- Recent sessions list with duration and completion rate

Visual Style:
- Metric cards with icon (left), value (large), trend (right)
- Charts use gradient fills matching theme colors
- Pie chart with center total
- Grid background in chart areas (subtle)
- Insight cards with lightbulb icon and gradient left border

Data Visualization:
- Bar chart: vertical bars with rounded tops, cyan fill
- Pie chart: donut style with category colors
- Line graph: smooth curve with area fill gradient
- All charts have subtle glow on data points
```

### 6. COMMUNITY SCREEN

```
Trackie Community features screen

Layout Structure:
- Top bar with "Community" title, search, create post button
- Tabs: Feed, Polls, Leaderboard
- Feed section:
  - Post cards with user avatar, name, timestamp
  - Post content (text, optional image)
  - Interaction bar: like, comment, share counts
- Polls section:
  - Active polls with vote counts and percentage bars
  - Poll options with radio selection
  - Time remaining indicator
- Leaderboard section:
  - Top 10 users with rank, avatar, name, XP
  - Current user highlight if not in top 10

Visual Style:
- Post cards with glass effect, 20px border radius
- User avatars with gradient border
- Like button animates with heart fill on click
- Poll bars with gradient fill matching option color
- Rank badges (1st=gold, 2nd=silver, 3rd=bronze)

Interactions:
- Pull to refresh on feed
- Infinite scroll loading
- Vote animation (progress bar fill)
- Comment expansion (slide down)
```

### 7. NOTES SCREEN

```
Trackie Notes/Multimedia notes screen

Layout Structure:
- Top bar with "Notes" title, search, add note button
- Filter tabs: All, Text, Audio, Images, Tasks
- Notes grid/list with preview:
  - Text notes: title, first 2 lines, date
  - Audio notes: waveform visualization, duration, play button
  - Image notes: thumbnail grid, count badge
  - Task notes: checkbox list, progress indicator

Visual Style:
- Note cards with glass effect, 16px border radius
- Text preview with gradient fade for overflow
- Audio waveform with cyan accent color
- Image thumbnails with rounded corners, count badge overlay
- Task checkboxes with custom styling (cyan check)

Components:
- Note card shows: type icon, title, preview, date, tags
- Audio player: play/pause, progress bar, duration
- Image viewer: lightbox on click
- Task list: checkbox + text, strikethrough on complete
```

### 8. HELP/SCREEN

```
Trackie Help Center with cosmic theme

Layout Structure:
- Hero section: large title "How can we guide you?", search input, popular tags
- Knowledge domains (bento grid):
  - Getting Started (large, featured)
  - Billing & Plans
  - Privacy & Data
  - Integrations
  - Community Hub
- Trending articles list
- Support CTA section with contact options

Visual Style:
- Search with gradient glow on focus
- Domain cards with icon, title, description, link
- Featured card spans 2 columns, has larger icon
- Article list: number (large, faded) + title + preview + read time
- CTA section with background image overlay

Components:
- Search input with magnifying glass icon
- Domain cards hover: scale + glow effect
- Article cards with gradient number background
- Contact buttons: "Open Support Ticket", "Chat with Support"
- Average response time display
```

---

## PROMPT TIPS FOR BEST RESULTS

1. **Use the project**: Select "Trackie Liquid Nebula PRD" in Stitch before generating
2. **Dark mode first**: The design system is optimized for dark mode
3. **Reference colors**: Use exact hex codes from design system
4. **Mobile first**: Start with mobile designs, then adapt to desktop
5. **Iterate**: Generate, review, then refine with specific feedback

## API TROUBLESHOOTING

If you see "Cannot connect to API: socket connection closed":
- Wait 30 seconds and retry
- Check internet connection
- Verify API key is valid in Stitch settings
- Project may be loading - wait for "Ready" status