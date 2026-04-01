# Contributing to Trackie

Thank you for your interest in contributing to Trackie! 🎉

## Code of Conduct

This project adheres to the [Trackie Code of Conduct](). By participating, you are expected to uphold this code.

## How to Contribute

### 1. Report Bugs

If you find a bug, please create an issue with:
- Descriptive title
- Steps to reproduce
- Expected vs actual behavior
- Screenshots if applicable

### 2. Propose Features

Before creating a feature:
1. Search for existing issues
2. If it doesn't exist, create one with the `enhancement` label
3. Describe your proposal in detail

### 3. Pull Requests

#### Process:
1. Fork the repository
2. Create a branch: `git checkout -b feature/your-feature`
3. Make your changes following the conventions
4. Commit with clear messages: `git commit -m "feat: add new feature"`
5. Push to your fork: `git push origin feature/your-feature`
6. Open a Pull Request

#### Commit Conventions:

```
feat(core): add new dashboard widget
fix(ui): resolve search filter bug
docs(readme): update installation guide
refactor(models): simplify data layer
test(auth): add unit tests for login
chore(deps): update flutter version
```

#### Branch Conventions:
- `feature/*` - New features
- `fix/*` - Bug fixes
- `refactor/*` - Refactoring
- `docs/*` - Documentation

## Code Standards

### Flutter/Dart
- Follow the [official guides](https://dart.dev/guides/language/effective-dart)
- Run `flutter analyze` before committing
- Maintain test coverage >70%

### File Structure
```
lib/
├── core/           # Constants, themes, utils
├── data/           # Models, repositories
├── domain/         # Providers, business logic
└── presentation/   # UI screens, widgets
```

## Development Setup

```bash
# Clone
git clone https://github.com/0gloomdev/trackie.git
cd trackie

# Install dependencies
flutter pub get

# Run analysis
flutter analyze

# Run tests
flutter test

# Build for web
flutter build web

# Build for Android
flutter build apk --debug
```

## Resources

- [Documentation](https://docs.trackie.app)
- [Issue Tracker](https://github.com/0gloomdev/trackie/issues)
- [Discussions](https://github.com/0gloomdev/trackie/discussions)

---

We look forward to your contribution! 🚀
