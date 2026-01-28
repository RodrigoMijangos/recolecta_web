# 📋 Changelog

> Todos los cambios importantes en este proyecto están documentados aquí.

El formato está basado en [Keep a Changelog](https://keepachangelog.com/es-ES/1.0.0/) y el proyecto sigue [Versionado Semántico](https://semver.org/lang/es/).

---

# 0.4.1-alpha - 2026-01-27
## Rodrigo Mijangos [Issue #40](https://github.com/RodrigoMijangos/recolecta_web/issues/40)
### 🔧 Arreglado
- Restauración de carpeta `docs/` que fue eliminada accidentalmente por cherry-pick en issue #33.
- Cherry-pick del commit `3a526dd` (de issue #34) para recuperar documentación estructurada.
- Cherry-pick del commit `e25b7bd` para recuperar documentación de tests de Redis.

### 📝 Notas
- Los archivos recuperados incluyen:
  - `docs/01-setup-local.md` (305 líneas)
  - `docs/02-database-operations.md` (343 líneas)
  - `docs/testing/redis-tests.md` (192 líneas) - Documenta suite de tests de Redis
- Esta restauración asegura que toda la documentación eliminada sea recuperada.
- Conflictos en README.md y .gitignore resueltos manteniendo versiones actuales.

# 0.4.0-alpha - 2026-01-27
## Rodrigo Mijangos [Issue #33](https://github.com/RodrigoMijangos/recolecta_web/issues/33)
### 🆕 Agregado
- Scripts de inicialización de base de datos en Docker.
- Scripts de seed automático de base de datos en Docker.
- Scripts para dump y restore de base de datos en Docker.
- Creación de Seeders para tablas principales.
- Gitattributes para manejo de archivos sensibles a fin de línea.

## ✏️ Cambiado
- Configuración de Docker Compose para PostgreSQL.
- Configuración de la persistencia de Datos de PostgreSQL.

# 0.3.0-alpha - 2026-01-27
## Rodrigo Mijangos [Issue #34](https://github.com/RodrigoMijangos/recolecta_web/issues/34)
### 🆕 Agregado
- Documentación inicial para operaciones de base de datos con Docker.
- Documentación de setup local con Docker Compose.
- Documentación de testing local para redis.
- Documentación de seeding automático de base de datos.
- Documentación de estructura del proyecto.
- Documentación de orquestación con Docker Compose.
- Documentación de configuración de variables de entorno.
- Documentación de requisitos previos para desarrollo local.
- Documentación de quick start para levantar ambiente local.
- Documentación de enlaces rápidos para setup local y operaciones de base de datos.

## 0.2.0-alpha - 2026-01-20

### Agregado
- Se agrega información util para nuevos desarrolladores.
- Información sobre como ejecutar contenedores de Docker.
- Información sobre los servicios de docker.
- Quickstart.

### Cambiado
- Información que muestra README.md actualizada.
- Configuración de Docker Compose actualizada.
- Redis requiere una contraseña de manera obligatoria.
  
---

## 0.1.0-alpha - 2026-01-20

### Agregado
- Submódulo del **frontend** integrado al repositorio
- Submódulo del **backend** (Gin) integrado al repositorio
- Configuración de **Docker Compose** para desarrollo
- Configuración de **Docker Compose** para producción
- Dockerfile personalizado para **Nginx**
- Archivo `.gitignore` para proteger variables de entorno (`.env`)

### Configurado
- Archivo `.gitignore` para archivos `.env`
- Docker Compose de desarrollo con servicios base
- Docker Compose de producción optimizado
- Configuración temporal para ejecutar Docker en desarrollo
- Archivo de configuración `.gitignore` refinado para ignorar docs y scripts auxiliares

### Eliminado
- Archivo de ejemplo para Docker Compose

---

## 📖 Guía del Changelog

### 🎯 Cómo Leerlo

Cada versión está dividida en **categorías** que te ayudan a identificar qué tipo de cambios se hicieron:

| Categoría | Significa | Ejemplo |
|-----------|-----------|---------|
| **🆕 Agregado** | Nuevas funcionalidades | Nueva página de login |
| **🔧 Configurado** | Cambios en configuración | Actualización de variables de entorno |
| **✏️ Cambiado** | Cambios en funcionalidad existente | Refactor de componentes |
| **🐛 Arreglado** | Bug fixes | Corrección de error en validación |
| **🗑️ Eliminado** | Código o archivos removidos | Componentes deprecados |
| **⚠️ Deprecado** | Features que pronto desaparecerán | Método antiguo que será reemplazado |
| **🔒 Seguridad** | Parches de seguridad | Actualización de dependencias críticas |

### 🏗️ Cómo Mantenerlo

Cada vez que hagas cambios importantes, **debes actualizar el changelog** ANTES de hacer el commit:

#### En Desarrollo (rama activa)

```markdown
## [Sin liberar]

### 🆕 Agregado
- Nueva funcionalidad X

### 🐛 Arreglado
- Bug en el componente Y
```

#### ✅ Al Hacer Release

1. **Reemplaza `[Sin liberar]` con la versión** en formato `X.Y.Z`
2. **Añade la fecha** en formato `YYYY-MM-DD`
3. **Crea un nuevo tag** en Git

```bash
# Ejemplo:
git tag -a v0.2.0 -m "Release version 0.2.0"
git push origin v0.2.0
```

---

## 📊 Sistema de Versionado (Versionado Semántico)

Usamos **SemVer**: `MAJOR.MINOR.PATCH(-prerelease)(+metadata)`

### Formato: X.Y.Z

```
0.1.0
├── 0 = MAJOR (cambios incompatibles)
├── 1 = MINOR (nuevas funcionalidades)
└── 0 = PATCH (bug fixes)
```

### 📈 Reglas de Versionado

| Cambio | Incrementa | Ejemplo |
|--------|-----------|---------|
| Bug fixes y mejoras pequeñas | PATCH | 0.1.0 → 0.1.1 |
| Nuevas funcionalidades | MINOR | 0.1.0 → 0.2.0 |
| Cambios incompatibles | MAJOR | 0.1.0 → 1.0.0 |

### 🔤 Estados Especiales (Prerelease)

Para versiones en desarrollo, usamos sufijos:

```
0.1.0-alpha    → Versión muy temprana, inestable
0.1.0-beta     → Más estable pero en pruebas
0.1.0-rc.1     → Release Candidate (casi lista)
1.0.0          → Versión estable final
```

### 📋 Hoja de Referencia Rápida

```bash
# Versión actual
git describe --tags

# Ver todos los tags
git tag -l

# Crear nuevo tag (cuando hagas release)
git tag -a v0.2.0 -m "Release version 0.2.0"

# Ver cambios desde último tag
git log $(git describe --tags --abbrev=0)..HEAD --oneline
```

---

## 💡 Consejos para Desarrolladores

### ✍️ Al Hacer Cambios

1. **Trabaja en tu rama** (ej: `feature/nueva-funcionalidad`)
2. **Actualiza el changelog** en la sección `[Sin liberar]`
3. **Sé descriptivo** pero conciso:
   - ✅ `Agregado: Modal de confirmación en validación de rutas`
   - ❌ `fixed stuff`

### 🔍 Antes de hacer un Pull Request

```bash
# Verifica que el changelog esté actualizado
git diff main -- CHANGELOG.md

# Lee tu changelog
cat CHANGELOG.md
```

### 📦 Al Hacer Release (Solo para Admin)

```bash
# 1. Actualizar versión en package.json (frontend)
# 2. Reemplazar [Sin liberar] en CHANGELOG.md
# 3. Hacer commit
git commit -am "chore: release v0.2.0"

# 4. Crear tag
git tag -a v0.2.0 -m "Release version 0.2.0"

# 5. Hacer push
git push origin main
git push origin v0.2.0
```

---

## 📦 Estructura del Proyecto

```
recolecta_web/
├── frontend/              (React + TypeScript + Vite)
├── gin-backend/          (Go + Gin)
├── docker/               (Configuración Docker)
├── map-navigator/        (Módulo separado)
└── docker-compose.yml    (Orquestación de servicios)
```
