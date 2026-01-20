# Configuración del GitHub Project - Roadmap Notificaciones

> **📋 Antes de crear issues:** Lee [PLANTILLA_UNIVERSAL_ISSUES.md](PLANTILLA_UNIVERSAL_ISSUES.md) para entender cómo estructurar tus issues correctamente.

## Instrucciones para crear el Project con Tablero Visual

### Paso 1: Crear el Project
1. Ve a: https://github.com/RodrigoMijangos/recolecta_web
2. Click en la pestaña **"Projects"**
3. Click en **"New project"**
4. Nombre: `Roadmap Notificaciones - Fases 1-7`
5. Tipo: Selecciona **"Table"** o **"Board"** (recomendado: Board para ver flujo visual)
6. Click **"Create project"**

### Paso 2: Distribuir Issues en Repositorios (Recomendado)

Los issues deben distribuirse de la siguiente manera:

#### Repositorio: `recolecta_web` (Infraestructura Principal)
- ✅ FASE 1 (Issues #1-3): Docker, variables de entorno, migraciones
- ✅ FASE 5 (Issues #14-16): Testing e integración
- ✅ FASE 6 (Issues #17-19): Wiki y documentación
- ✅ FASE 7 (Issues #20-24): Logging, métricas, producción

#### Repositorio: `gin-backend` (Backend Go)
- ✅ FASE 2 (Issues #4-6): Redis y estructuras
- ✅ FASE 3 (Issues #7-10): Sistema de notificaciones, FCM, endpoints

#### Repositorio: `frontend` (Frontend React)
- ✅ FASE 4 (Issues #11-13): FCM frontend, Dashboard, token FCM

### Paso 3: Crear Issues Usando la Plantilla Universal

**Recomendación:** Antes de crear cada issue, revisa [PLANTILLA_UNIVERSAL_ISSUES.md](PLANTILLA_UNIVERSAL_ISSUES.md) y usa la estructura propuesta para mantener consistencia.

### Paso 4: Transferir Issues (Manual)

**Nota:** GitHub CLI no soporta transferencia automática. Usa esto como referencia:

#### Mover a `vicpoo/API_recolecta` (Backend):
1. Abre cada issue (#4-10)
2. Click en **⋯** (menú) → **"Transfer issue"**
3. Selecciona `vicpoo/API_recolecta`
4. Confirma

Issues a transferir:
- #4 - Implementar cliente Redis y conexión
- #5 - Definir estructuras de datos Redis
- #6 - Documentar estructura de Redis
- #7 - Crear servicio de detección de proximidad
- #8 - Integrar Firebase Cloud Messaging (FCM)
- #9 - Crear endpoints REST para notificaciones
- #10 - Tests unitarios para notificaciones

#### Mover a `Denzel-Santiago/RecolectaWeb` (Frontend):
1. Abre cada issue (#11-13)
2. Click en **⋯** (menú) → **"Transfer issue"**
3. Selecciona `Denzel-Santiago/RecolectaWeb`
4. Confirma

Issues a transferir:
- #11 - Integrar Firebase Messaging en Frontend
- #12 - Mostrar notificaciones en Dashboard
- #13 - Guardar token FCM en registro de usuario

### Paso 4: Agregar Issues al Project

1. Ve a https://github.com/RodrigoMijangos/recolecta_web/projects
2. Abre el proyecto **"Roadmap Notificaciones - Fases 1-7"**
3. Click en **"Add item"** o **"+ Add column"** para crear columnas:
   - **Backlog** (por hacer)
   - **En Progreso** (asignado y trabajando)
   - **Review** (listo para revisar)
   - **Completado** (hecho)

4. Agrega los issues al proyecto (puedes arrastrar desde el sidebar)

### Estructura Recomendada del Project (Board View)

```
┌─────────────────────────────────────────────────────────────┐
│ FASE 1: Config    │ FASE 2-3: Backend │ FASE 4: Frontend   │
├─────────────────────────────────────────────────────────────┤
│ Backlog           │ Backlog           │ Backlog            │
│ • #1 Docker       │ • #4 Redis CLI    │ • #11 FCM Web      │
│ • #2 .env         │ • #5 Redis struct │ • #12 Dashboard    │
│ • #3 DB migrations│ • #6 Redis docs   │ • #13 Token FCM    │
│                   │ • #7 Proximidad   │                    │
│                   │ • #8 FCM Backend  │                    │
│                   │ • #9 Endpoints    │                    │
│                   │ • #10 Tests       │                    │
├─────────────────────────────────────────────────────────────┤
│ En Progreso       │ En Progreso       │ En Progreso        │
│ (asignados)       │ (asignados)       │ (asignados)        │
├─────────────────────────────────────────────────────────────┤
│ Review            │ Review            │ Review             │
│ (listos para PR)  │ (listos para PR)  │ (listos para PR)   │
├─────────────────────────────────────────────────────────────┤
│ Completado        │ Completado        │ Completado         │
│ (merged)          │ (merged)          │ (merged)           │
└─────────────────────────────────────────────────────────────┘
```

### Paso 5: Configurar Automatizaciones (Opcional)

En el proyecto, puedes agregar automatizaciones:
1. Click en **⋯** → **"Settings"**
2. Activa automations:
   - Cuando se cierra un PR → Mover a "Completado"
   - Cuando se abre un PR → Mover a "Review"
   - Cuando se asigna → Mover a "En Progreso"

---

## Links Rápidos

- **Issues actuales:** https://github.com/RodrigoMijangos/recolecta_web/issues
- **Proyecto (una vez creado):** https://github.com/RodrigoMijangos/recolecta_web/projects
- **Gin Backend Repo:** https://github.com/RodrigoMijangos/gin-backend
- **Frontend Repo:** https://github.com/RodrigoMijangos/frontend

---

## Mapeo de Issues por Repositorio

| FASE | Issue | Título | Repositorio |
|------|-------|--------|-------------|
| 1 | #1 | Validar Docker Compose | recolecta_web |
| 1 | #2 | Configurar .env | recolecta_web |
| 1 | #3 | Migraciones DB | recolecta_web |
| 2 | #4 | Cliente Redis | **gin-backend** |
| 2 | #5 | Estructuras Redis | **gin-backend** |
| 2 | #6 | Docs Redis | **gin-backend** |
| 3 | #7 | Proximidad | **gin-backend** |
| 3 | #8 | FCM Backend | **gin-backend** |
| 3 | #9 | Endpoints | **gin-backend** |
| 3 | #10 | Tests Backend | **gin-backend** |
| 4 | #11 | FCM Frontend | **frontend** |
| 4 | #12 | Dashboard | **frontend** |
| 4 | #13 | Token FCM | **frontend** |
| 5 | #14 | Test E2E | recolecta_web |
| 5 | #15 | Redis Persist | recolecta_web |
| 5 | #16 | Load Testing | recolecta_web |
| 6 | #17 | Wiki Structure | recolecta_web |
| 6 | #18 | Redis Wiki | recolecta_web |
| 6 | #19 | Diagramas | recolecta_web |
| 7 | #20 | Logging | recolecta_web |
| 7 | #21 | Prometheus | recolecta_web |
| 7 | #22 | HTTPS/Prod | recolecta_web |
| 7 | #23 | Alertas | recolecta_web |
| 7 | #24 | Disaster Recovery | recolecta_web |

---

## Próximos Pasos

1. ✅ Issues creados en recolecta_web
2. 📋 Transferir issues a gin-backend y frontend (manual)
3. 🎯 Crear Project y agregar todos los issues
4. 👥 Asignar issues a colaboradores
5. 🚀 Comenzar FASE 1
