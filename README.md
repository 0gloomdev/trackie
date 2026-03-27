<div align="center">
  <img src="assets/logo.svg" width="120" alt="Trackie Logo" />
  <h1>Trackie</h1>
  <p>Tu centro de aprendizaje personal</p>
  
  <p>
    <img src="https://img.shields.io/badge/version-0.5.0-purple?style=flat-square" alt="version" />
    <img src="https://img.shields.io/badge/Flutter-3.24-blue?style=flat-square" alt="Flutter" />
    <img src="https://img.shields.io/badge/License-MIT-green?style=flat-square" alt="License" />
    <img src="https://img.shields.io/badge/Platform-Web%20%7C%20Mobile%20%7C%20Desktop-blueviolet?style=flat-square" alt="Platform" />
  </p>
</div>

---

## Acerca de

**Trackie** es una aplicación de código abierto para gestionar tu aprendizaje personal. Organiza cursos, libros, PDFs, podcasts, videos y más en un solo lugar con una hermosa interfaz "Liquid Glass".

### Código: `v0.5.0 - Liquid Glass`

---

## Características

| Categoría | Funcionalidades |
|-----------|-----------------|
| **Gestión** | CRUD completo de items, tipos múltiples de contenido |
| **Organización** | Categorías, etiquetas, favoritos, items fijados |
| **Búsqueda** | Filtros avanzados, búsqueda en tiempo real |
| **Acciones** | Bulk actions, duplicar, importar/exportar |
| **UI/UX** | Liquid Glass UI, temas claro/oscuro |
| **Estadísticas** | Dashboard con gráficos de progreso |
| **Metadatos** | Auto-fetch de URLs (título, thumbnail, favicon) |

---

## Tech Stack

- **Framework**: Flutter 3.24+
- **Lenguaje**: Dart 3.5+
- **Estado**: Riverpod
- **Storage**: Hive (100% local, funciona en web)
- **UI**: Material Design 3 + Custom Glassmorphism

---

## Instalación

```bash
# Clonar repositorio
git clone https://github.com/tu-usuario/trackie.git
cd trackie

# Instalar dependencias
flutter pub get

# Ejecutar en desarrollo
flutter run

# Build web
flutter build web --release

# Build Android
flutter build apk --debug
```

---

## Estructura del Proyecto

```
lib/
├── core/
│   ├── constants/     # App constants, content types
│   ├── services/     # URL metadata service
│   └── theme/         # App theme (light/dark)
├── data/
│   ├── models/        # LearningItem, Category, Tag, Settings
│   └── repositories/  # Hive repositories
├── domain/
│   └── providers/     # Riverpod state management
└── presentation/
    └── screens/       # UI screens (home, library, detail, etc.)
```

---

## Ramas del Repositorio

| Rama | Propósito |
|------|-----------|
| `main` | Producción estable |
| `develop` | Desarrollo activo |
| `feature/*` | Nuevas funcionalidades |
| `fix/*` | Bug fixes |
| `refactor/*` | Refactoring |

---

## Contribuir

¡Toda contribución es bienvenida! Lee [CONTRIBUTING.md](CONTRIBUTING.md) para más detalles.

1. Fork el repositorio
2. Crea tu rama (`git checkout -b feature/amazing-feature`)
3. Commit tus cambios (`git commit -m 'feat: add amazing feature'`)
4. Push a la rama (`git push origin feature/amazing-feature`)
5. Abre un Pull Request

---

## Changelog

### v0.5.0 - Liquid Glass (Actual)
- Dashboard mejorado con estadísticas visuales
- Sistema de items fijados (Pinned)
- Búsqueda avanzada en tiempo real
- Filtros por tipo, estado, prioridad
- Bulk actions (selección múltiple)
- Duplicar items
- Auto-fetch de metadatos URL

### v0.4.0 - Crystal Clear
- UI Glassmorphism completa
- Tema oscuro/claro

### v0.3.0 - Solid Foundation
- Modelo de datos completo
- Repositorios Hive

---

## Roadmap

- [ ] Colecciones (agrupación de items)
- [ ] Import/Export JSON
- [ ] Lector de contenido integrado
- [ ] Notas avanzadas con markdown
- [ ] PWA instalable
- [ ] Tests unitarios

---

## Licencia

MIT License - ver [LICENSE](LICENSE) para detalles.

---

<div align="center">
  ⭐ Hecho con ❤️ por la comunidad
</div>
