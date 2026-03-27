#!/bin/bash

# Trackie - Script de Despliegue a GitHub
# Uso: ./deploy.sh

echo "🚀 Trackie - Despliegue a GitHub"
echo "=================================="

# Verificar si gh está instalado
if ! command -v gh &> /dev/null; then
    echo "❌ GitHub CLI (gh) no está instalado."
    echo "   Instala con: https://cli.github.com/"
    echo ""
    echo "Alternativamente, puedes crear el repositorio manualmente:"
    echo "1. Ve a https://github.com/new"
    echo "2. Nombra el repositorio: trackie"
    echo "3. Ejecuta los siguientes comandos:"
    echo "   git remote add origin https://github.com/TU_USUARIO/trackie.git"
    echo "   git push -u origin main"
    exit 1
fi

# Verificar autenticación
if ! gh auth status &> /dev/null; then
    echo "❌ No has iniciado sesión en GitHub."
    echo "   Ejecuta: gh auth login"
    exit 1
fi

# Nombre del repositorio
REPO_NAME="trackie"

echo "📁 Verificando archivos..."
if [ ! -d ".git" ]; then
    echo "❌ No es un repositorio git"
    exit 1
fi

echo "📝 Creando repositorio en GitHub..."
gh repo create $REPO_NAME --public --source=. --description "Trackie - Personal Learning Management App - Liquid Glass UI" --push

echo ""
echo "✅ ¡Despliegue completado!"
echo ""
echo "📋 Ramas creadas:"
echo "   - main (producción)"
echo "   - develop (desarrollo)"
echo "   - feature/collections"
echo "   - feature/import-export"
echo "   - feature/reader-view"
echo "   - refactor/performance"
echo ""
echo "🔗 URLs útiles:"
echo "   - Repositorio: https://github.com/$(gh api user --jq '.login')/$REPO_NAME"
echo "   - Issues: https://github.com/$(gh api user --jq '.login')/$REPO_NAME/issues"
echo "   - Actions: https://github.com/$(gh api user --jq '.login')/$REPO_NAME/actions"
