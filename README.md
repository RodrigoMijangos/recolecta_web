# 🗑️ Recolecta Web

> Sistema integral de gestión y seguimiento de rutas de recolección de residuos

**Versión:** `0.1.0-alpha` | **Estado:** En desarrollo 🚧

---

## 📋 Descripción del Proyecto

**Recolecta** es una plataforma web que permite:

- 📍 **Gestión de Rutas** - Planificación y asignación de rutas de recolección
- 🚗 **Seguimiento de Camiones** - Monitoreo en tiempo real de vehículos
- 📊 **Dashboard Inteligente** - Visualización de datos y reportes
- 🔔 **Sistema de Alertas** - Notificaciones de anomalías y mantenimiento
- 📈 **Análisis de Datos** - Estadísticas y reportes de eficiencia

### 🏗️ Stack Tecnológico

| Componente | Tecnología | Descripción |
|-----------|-----------|-----------|
| **Frontend** | React + TypeScript + Vite | Interfaz moderna y rápida |
| **Backend** | Go + Gin | API REST de alto rendimiento |
| **Infraestructura** | Docker + Docker Compose | Containerización y orquestación |
| **Web Server** | Nginx | Reverse proxy y servidor estático |

---

## 🚀 Inicio Rápido (Quick Start)

### 📋 Requisitos Previos

- **Docker** 20.10+
- **Docker Compose** 2.0+
- **Git** 2.30+

Verifica que tengas todo instalado:

```bash
docker --version
docker-compose --version
git --version
```

### ⚡ Ejecutar en Desarrollo (3 pasos)

#### 1️⃣ Clonar el repositorio con submódulos

```bash
git clone https://github.com/tu-usuario/recolecta_web.git
cd recolecta_web

# Inicializar submódulos (frontend y backend)
git submodule init
git submodule update
```

#### 2️⃣ Configurar variables de entorno

Copia el archivo de ejemplo y edítalo con tus valores:

```bash
cp .env.example .env
```

**Variables principales:**

```env
# Backend
API_PORT=8080
DATABASE_URL=postgresql://user:password@db:5432/recolecta

# Frontend
VITE_API_URL=http://localhost:8080

# Docker
ENVIRONMENT=development
```

#### 3️⃣ Iniciar los servicios

```bash
# Desarrollo
docker-compose -f docker/docker.compose.dev.yml up -d

# Ver logs en tiempo real
docker-compose -f docker/docker.compose.dev.yml logs -f
```

**✅ Listo!** Tu aplicación estará disponible en:

- 🌐 **Frontend:** http://localhost:3000
- 🔌 **Backend API:** http://localhost:8080
- 📊 **Nginx:** http://localhost

---

## 📦 Comandos Docker Útiles

### Desarrollo

```bash
# Iniciar servicios en background
docker-compose -f docker/docker.compose.dev.yml up -d

# Ver logs en vivo
docker-compose -f docker/docker.compose.dev.yml logs -f

# Ver solo logs del servicio específico
docker-compose -f docker/docker.compose.dev.yml logs -f frontend

# Detener servicios
docker-compose -f docker/docker.compose.dev.yml down

# Limpiar volúmenes (CUIDADO: borra datos)
docker-compose -f docker/docker.compose.dev.yml down -v

# Reiniciar un servicio
docker-compose -f docker/docker.compose.dev.yml restart backend
```

### Producción

```bash
# Construcción e inicio
docker-compose -f docker/docker.compose.yml up -d

# Ver estado de servicios
docker ps

# Actualizar código (recrear contenedores)
docker-compose -f docker/docker.compose.yml up -d --pull always
```

### Debugging

```bash
# Ejecutar comando dentro de contenedor
docker-compose -f docker/docker.compose.dev.yml exec backend bash

# Inspeccionar contenedor
docker inspect <container-id>

# Ver estadísticas de recursos
docker stats

# Verificar conectividad
docker-compose -f docker/docker.compose.dev.yml exec frontend ping backend
```

---

## 📁 Estructura del Proyecto

```
recolecta_web/
├── frontend/                    # React + TypeScript (submódulo)
│   ├── src/
│   │   ├── components/         # Componentes reutilizables
│   │   ├── Pages/              # Páginas principales
│   │   ├── Router/             # Configuración de rutas
│   │   └── main.tsx
│   ├── package.json
│   └── vite.config.ts
│
├── gin-backend/                 # Go + Gin (submódulo)
│   ├── src/
│   │   ├── alerta_mantenimiento/
│   │   ├── anomalia/
│   │   ├── camion/
│   │   ├── ruta/
│   │   └── ... [otros módulos]
│   ├── main.go
│   └── go.mod
│
├── docker/                      # Configuración Docker
│   ├── docker.compose.dev.yml  # Desarrollo
│   ├── docker.compose.yml      # Producción
│   ├── Dockerfile.nginx        # Imagen Nginx
│   └── nginx/
│       └── nginx.conf/         # Configuración Nginx
│
├── map-navigator/              # Módulo de mapas
├── CHANGELOG.md               # Registro de cambios
├── README.md                  # Este archivo
└── .env.example              # Variables de entorno ejemplo
```

---

## 🔄 Submódulos Git

El proyecto usa **submódulos Git** para el frontend y backend:

### Actualizar submódulos

```bash
# Actualizar todos los submódulos
git submodule update --remote --merge

# Actualizar un submódulo específico
cd frontend
git pull origin main
cd ..
git add frontend
git commit -m "chore: update frontend submodule"
```

### Clonar con submódulos

```bash
# Opción 1: Clonar e inicializar de una vez
git clone --recurse-submodules <url>

# Opción 2: Clonar e inicializar después
git clone <url>
cd recolecta_web
git submodule update --init --recursive
```

---

## 🛠️ Desarrollo

### Cambios en Frontend

```bash
cd frontend
npm install
npm run dev
```

Los cambios se reflejan automáticamente gracias a Vite.

### Cambios en Backend

```bash
cd gin-backend
go mod download
go run main.go
```

El backend se reinicia automáticamente con hot-reload (depende de configuración).

---

## 🐛 Solución de Problemas

### ❌ Puerto ya en uso

```bash
# Encontrar qué proceso usa el puerto
netstat -tulpn | grep :3000

# O cambiar el puerto en docker-compose.yml
```

### ❌ Permisos denegados en Docker

```bash
# Agregar usuario al grupo docker (Linux)
sudo usermod -aG docker $USER
newgrp docker

# En Windows/Mac, reinicia Docker Desktop
```

### ❌ Submódulos no se clonaron

```bash
git submodule update --init --recursive
```

### ❌ Contenedores no inician

```bash
# Ver logs detallados
docker-compose -f docker/docker.compose.dev.yml logs

# Verificar sintaxis del compose
docker-compose -f docker/docker.compose.dev.yml config
```

---

## 📚 Documentación Adicional

| Documento | Propósito |
|-----------|-----------|
| [CHANGELOG.md](CHANGELOG.md) | Registro de cambios y versiones |
| [docker/README.md](docker/README.md) | Detalles de configuración Docker |
| [frontend/README.md](frontend/README.md) | Guía del frontend |
| [gin-backend/README.md](gin-backend/README.md) | Guía del backend |

---

## 🤝 Contribución

### Workflow de Desarrollo

1. **Crea una rama** desde `main`:
   ```bash
   git checkout -b feature/mi-nueva-funcionalidad
   ```

2. **Haz cambios** y actualiza el [CHANGELOG.md](CHANGELOG.md):
   ```bash
   # Añade tu cambio a la sección [Sin liberar]
   ```

3. **Haz commit** con mensaje descriptivo:
   ```bash
   git commit -am "feat: agregar nueva funcionalidad"
   ```

4. **Abre Pull Request** con descripción clara

5. **Espera revisión** del equipo

### Convención de Commits

```
<tipo>: <descripción corta>

feat:    Nueva funcionalidad
fix:     Corrección de bug
chore:   Cambios de configuración
docs:    Cambios en documentación
refactor: Reorganización de código
test:    Cambios en tests
```

---

## 📞 Soporte

- 📧 Email: support@recolecta.local
- 💬 Discord: [Tu servidor]
- 🐛 Issues: [GitHub Issues](https://github.com/tu-usuario/recolecta_web/issues)

---

## 📄 Licencia

Este proyecto está bajo licencia **MIT**. Ver [LICENSE](LICENSE) para más detalles.

---

## 👥 Equipo

- **Product Owner:** [Nombre]
- **Tech Lead:** [Nombre]
- **Desarrolladores:** [Nombres]

---

**Última actualización:** 20 de Enero de 2026 | **Versión:** 0.1.0-alpha
