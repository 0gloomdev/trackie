# Trackie

<div align="center">
  <img src="assets/logo.svg" width="120" alt="Trackie Logo" />
  <h3>Tu centro de aprendizaje personal</h3>
</div>

---

## Acerca de

Trackie es una aplicación de código abierto para gestionar tu aprendizaje personal. Organiza cursos, libros, PDFs, podcasts, videos y más en un solo lugar.

## Características

- 📚 **Múltiples tipos de contenido**: Cursos, libros, PDFs, EPUB, audio, video, artículos, podcasts, notas y enlaces
- 🎯 **Seguimiento de progreso**: Visualiza tu avance con estadísticas detalladas
- 🏷️ **Organización flexible**: Categorías y etiquetas personalizadas
- ⭐ **Favoritos**: Guarda tus recursos más importantes
- 🔍 **Búsqueda y filtros**: Encuentra rápido lo que necesitas
- 🌙 **Temas**: Claro, oscuro y automático
- 📱 **Multiplataforma**: Web, Android, iOS y Desktop

## Instalación

```bash
git clone https://github.com/tu-usuario/trackie.git
cd trackie
flutter pub get
flutter run
```

## Contribución

1. Fork el repositorio
2. Crea una rama (`git checkout -b feature/nueva-caracteristica`)
3. Commit tus cambios
4. Push a la rama
5. Abre un Pull Request

## Estructura

```
lib/
├── core/           # Constantes y theme
├── data/           # Modelos y repositorios
├── domain/         # Providers (Riverpod)
└── presentation/   # UI y pantallas
```

## Tech Stack

- Flutter + Dart
- Riverpod (estado)
- Hive (DB local)
- fl_chart (gráficos)

## Licencia

MIT License

---

⭐ Hecho con ❤️ por la comunidad
