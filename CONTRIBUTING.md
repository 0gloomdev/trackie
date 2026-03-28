# Contributing to Trackie

¡Gracias por tu interés en contribuir a Trackie! 🎉

## Código de Conducta

Este proyecto se adhiere al [Código de Conducta de Trackie](). Al participar, se espera que mantengas este código.

## ¿Cómo contribuir?

### 1. Reportar Bugs

Si encuentras un bug, por favor crea un issue con:
- Título descriptivo
- Pasos para reproducir
- Comportamiento esperado vs actual
- Screenshots si aplica

### 2. Proponer Features

Antes de crear una feature:
1. Busca issues existentes
2. Si no existe, crea uno con la etiqueta `enhancement`
3. Describe tu propuesta detalladamente

### 3. Pull Requests

#### Proceso:
1. Fork el repositorio
2. Crea una rama: `git checkout -b feature/tu-feature`
3. Haz tus cambios siguiendo las convenciones
4. Commit con mensajes claros: `git commit -m "feat: add new feature"`
5. Push a tu fork: `git push origin feature/tu-feature`
6. Abre un Pull Request

#### Convenciones de Commits:

```
feat(core): add new dashboard widget
fix(ui): resolve search filter bug
docs(readme): update installation guide
refactor(models): simplify data layer
test(auth): add unit tests for login
chore(deps): update flutter version
```

#### Convenciones de Ramas:
- `feature/*` - Nuevas funcionalidades
- `fix/*` - Bug fixes
- `refactor/*` - Refactoring
- `docs/*` - Documentación

## Estándares de Código

### Flutter/Dart
- Sigue las [guías oficiales](https://dart.dev/guides/language/effective-dart)
- Usa `flutter analyze` antes de commitear
- Mantén coverage de tests >70%

### Estructura de Archivos
```
lib/
├── core/           # Constants, themes, utils
├── data/           # Models, repositories
├── domain/         # Providers, business logic
└── presentation/   # UI screens, widgets
```

## Configuración de Desarrollo

```bash
# Clonar
git clone https://github.com/tu-usuario/trackie.git
cd trackie

# Instalar dependencias
flutter pub get

# Ejecutar análisis
flutter analyze

# Ejecutar tests
flutter test

# Build web
flutter build web
```

## Recursos

- [Documentación](https://docs.trackie.app)
- [Issue Tracker](https://github.com/trackie/trackie/issues)
- [Discussions](https://github.com/trackie/trackie/discussions)

---

¡esperamos tu contribución! 🚀
