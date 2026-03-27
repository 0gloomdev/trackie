# Trackie - Sistema de Versionado

## Modelo de Versionado: Semantic Versioning (SemVer)

### Formato: `MAJOR.MINOR.PATCH[-PRERELEASE][+BUILD]`

---

## Versiones Internas (Code Names)

### Serie "Liquid" (Lanzamientos principales)
| Versión | Código | Descripción | Estado |
|---------|--------|-------------|--------|
| 0.1.0 | Liquid Alpha | Prototype inicial | ✅ Completado |
| 0.2.0 | Liquid Beta | Primera versión funcional | ✅ Completado |
| 0.5.0 | Liquid Glass | UI Glassmorphism completa | 🔄 Actual |
| 1.0.0 | Liquid Flow | Primera versión estable | ⏳ Planeado |

### Serie "Evolution" (Sub-versiones)
| Código | Descripción |
|--------|-------------|
| v0.5.1 "Droplet" | Fixes y mejoras menores |
| v0.5.2 "Stream" | Nuevas funcionalidades pequeñas |
| v0.5.3 "River" | Mejoras de rendimiento |
| v0.5.4 "Lake" | Refactoring interno |
| v0.5.5 "Ocean" | Actualización de dependencias |

---

## Ramas (Branching Strategy)

```
main (producción)
├── develop (desarrollo activo)
│   ├── feature/dashboard-v2
│   ├── feature/search-advanced
│   ├── feature/bulk-actions
│   ├── feature/url-metadata
│   ├── feature/collections
│   ├── feature/import-export
│   └── feature/reader-view
├── hotfix/urgente (fixes críticos)
├── release/v0.5.0 (pre-lanzamiento)
└── experimental/* (pruebas)
```

### Convenciones de Ramas
- `feature/*` - Nuevas funcionalidades
- `fix/*` - Bug fixes
- `hotfix/*` - Fixes críticos de producción
- `refactor/*` - Refactoring de código
- `docs/*` - Documentación
- `experimental/*` - Pruebas/eksploración

---

## Changelog Automático

### v0.5.0 - Liquid Glass (Actual)
- ✅ Dashboard mejorado con estadísticas visuales
- ✅ Sistema de items fijados (Pinned)
- ✅ Búsqueda avanzada en tiempo real
- ✅ Filtros por tipo, estado, prioridad
- ✅ Bulk actions (selección múltiple)
- ✅ Duplicar items
- ✅ Auto-fetch de metadatos de URLs
- ✅ Menú contextual con acciones rápidas

### v0.4.0 - Crystal Clear
- ✅ UI Glassmorphism
- ✅ Tema oscuro/claro
- ✅ Navegación fluida

### v0.3.0 - Solid Foundation
- ✅ Modelo de datos completo
- ✅ Repositorios Hive
- ✅ Provider state management

### v0.2.0 - First Flow
- ✅ Pantallas básicas
- ✅ CRUD de items

### v0.1.0 - First Drop
- ✅ Prototipo inicial

---

## Próximos Hitos

### v0.6.0 - "Deep Blue"
- Colecciones (agrupación de items)
- Import/Export JSON
- Sistema de etiquetas inteligentes
- Dashboard personalizable

### v0.7.0 - "Abyss"
- Lector de contenido integrado
- Notas avanzadas con markdown
- Preservación de URLs (screenshots)

### v1.0.0 - "Liquid Flow"
- Estabilidad total
- Documentación completa
- PWA instalable
- Tests覆盖率 >80%

---

## Labels para Issues

| Label | Color | Uso |
|-------|-------|-----|
| `enhancement` | 🟢 verde | Nuevas features |
| `bug` | 🔴 rojo | Bugs |
| `help wanted` | 🔵 azul | Ayuda necesaria |
| `priority:high` | 🟣 morado | Alta prioridad |
| `priority:medium` | 🟡 amarillo | Prioridad media |
| `good first issue` | 💚 verde claro | Para beginners |
| `documentation` | 📚 gris | Docs |
| `refactoring` | 🔧 naranja | Refactoring |

---

## Workflow de Commits

```
<tipo>(<alcance>): <descripción>

[.Body opcional]

[Footer opcional]
```

### Tipos
- `feat`: Nueva funcionalidad
- `fix`: Bug fix
- `docs`: Documentación
- `style`: Formateo (sin cambio de código)
- `refactor`: Refactoring
- `test`: Tests
- `chore`: Mantenimiento

### Ejemplos
```
feat(dashboard): add pinned items section
fix(search): resolve filter not clearing properly
docs(readme): update installation instructions
refactor(models): simplify LearningItem class
```
