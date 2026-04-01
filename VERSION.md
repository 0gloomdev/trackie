# Trackie - Versioning System

## Versioning Model: Semantic Versioning (SemVer)

### Format: `MAJOR.MINOR.PATCH[-PRERELEASE][+BUILD]`

---

## Internal Versions (Code Names)

### "Liquid" Series (Major Releases)
| Version | Code | Description | Status |
|---------|------|-------------|--------|
| 0.1.0 | Liquid Alpha | Initial prototype | ✅ Completed |
| 0.2.0 | Liquid Beta | First functional version | ✅ Completed |
| 0.5.0 | Liquid Glass | Complete Glassmorphism UI | 🔄 Current |
| 1.0.0 | Liquid Flow | First stable version | ⏳ Planned |

### "Evolution" Series (Sub-versions)
| Code | Description |
|------|-------------|
| v0.5.1 "Droplet" | Bug fixes and minor improvements |
| v0.5.2 "Stream" | Small new features |
| v0.5.3 "River" | Performance improvements |
| v0.5.4 "Lake" | Internal refactoring |
| v0.5.5 "Ocean" | Dependency updates |

---

## Branches (Branching Strategy)

```
main (production)
├── develop (active development)
│   ├── feature/dashboard-v2
│   ├── feature/search-advanced
│   ├── feature/bulk-actions
│   ├── feature/url-metadata
│   ├── feature/collections
│   ├── feature/import-export
│   └── feature/reader-view
├── hotfix/urgent (critical fixes)
├── release/v0.5.0 (pre-release)
└── experimental/* (testing)
```

### Branch Conventions
- `feature/*` - New features
- `fix/*` - Bug fixes
- `hotfix/*` - Critical production fixes
- `refactor/*` - Code refactoring
- `docs/*` - Documentation
- `experimental/*` - Testing/exploration

---

## Automatic Changelog

### v1.0.0 - Liquid Nebula (Current)
- ✅ Complete shadcn/ui-inspired design migration
- ✅ Full internationalization (English/Spanish)
- ✅ All 16 screens migrated to new UI
- ✅ Keyboard shortcuts implementation
- ✅ Pomodoro timer with session tracking
- ✅ Notes and reminders system

### v0.5.0 - Liquid Glass
- ✅ Improved dashboard with visual statistics
- ✅ Pinned items system
- ✅ Advanced real-time search
- ✅ Filters by type, status, priority
- ✅ Bulk actions (multi-select)
- ✅ Duplicate items
- ✅ Auto-fetch URL metadata
- ✅ Context menu with quick actions

### v0.4.0 - Crystal Clear
- ✅ Glassmorphism UI
- ✅ Dark/light theme
- ✅ Smooth navigation

### v0.3.0 - Solid Foundation
- ✅ Complete data model
- ✅ Hive repositories
- ✅ Provider state management

### v0.2.0 - First Flow
- ✅ Basic screens
- ✅ Item CRUD

### v0.1.0 - First Drop
- ✅ Initial prototype

---

## Upcoming Milestones

### v0.6.0 - "Deep Blue"
- Collections (item grouping)
- Import/Export JSON
- Smart tag system
- Customizable dashboard

### v0.7.0 - "Abyss"
- Integrated content reader
- Advanced markdown notes
- URL preservation (screenshots)

### v1.0.0 - "Liquid Flow"
- Full stability
- Complete documentation
- Installable PWA
- Test coverage >80%

---

## Issue Labels

| Label | Color | Use |
|-------|-------|-----|
| `enhancement` | 🟢 green | New features |
| `bug` | 🔴 red | Bugs |
| `help wanted` | 🔵 blue | Help needed |
| `priority:high` | 🟣 purple | High priority |
| `priority:medium` | 🟡 yellow | Medium priority |
| `good first issue` | 💚 light green | For beginners |
| `documentation` | 📚 gray | Docs |
| `refactoring` | 🔧 orange | Refactoring |

---

## Commit Workflow

```
<type>(<scope>): <description>

[Optional Body]

[Optional Footer]
```

### Types
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation
- `style`: Formatting (no code change)
- `refactor`: Refactoring
- `test`: Tests
- `chore`: Maintenance

### Examples
```
feat(dashboard): add pinned items section
fix(search): resolve filter not clearing properly
docs(readme): update installation instructions
refactor(models): simplify LearningItem class
```
