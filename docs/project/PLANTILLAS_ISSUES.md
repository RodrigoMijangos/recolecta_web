# Plantillas Originales de Issues - Referencia

Este archivo contiene todas las plantillas de issues creados para referencia y reutilización.

> **📋 Ver también:** [Plantilla Universal de Issues](PLANTILLA_UNIVERSAL_ISSUES.md) - Usa esta plantilla para crear nuevos issues de forma consistente.

---

## Guía Rápida: Cómo Usar la Plantilla Universal

### 1. **Preparación**
   - Abre [PLANTILLA_UNIVERSAL_ISSUES.md](PLANTILLA_UNIVERSAL_ISSUES.md)
   - Copia el contenido del bloque de código markdown

### 2. **Crear el Issue**
   - Ve a GitHub → "Issues" → "New issue"
   - Pega la plantilla en el campo de descripción
   - Completa solo las secciones relevantes para tu tipo de issue

### 3. **Completar Secciones**
   | Tipo | Secciones Obligatorias |
   |------|------------------------|
   | **Bug** | Resumen, Tipo, Pasos, Comportamiento esperado, Comportamiento observado, Entorno |
   | **Feature** | Resumen, Tipo, Criterios de aceptación, Impacto y prioridad |
   | **Task** | Resumen, Tipo, Criterios de aceptación |
   | **Docs** | Resumen, Tipo, Descripción del cambio |
   | **Pregunta** | Resumen, Tipo, Contexto |

### 4. **Agregar Etiquetas**
   - `bug`, `feature`, `enhancement`, `documentation`, `question`
   - `priority-high`, `priority-medium`, `priority-low`
   - `backend`, `frontend`, `infrastructure`, `database`

### 5. **Vinculación**
   - Usa `#numero-del-issue` para enlazar issues relacionados
   - Usa `Closes #numero` para auto-cerrar desde PRs

---

## FASE 1: Configuración Base

### Issue #1: Validar y completar Docker Compose
**Labels:** infrastructure, docker, phase-1

Asegurar que Docker Compose incluya todos los servicios necesarios con configuración correcta.

- [ ] Revisar `docker/docker.compose.yml` incluye PostgreSQL 16-alpine en puerto 5432
- [ ] Revisar que Redis 7.2-alpine está en puerto 6379 con volumen para AOF
- [ ] Revisar que Nginx está en puertos 80 y 443
- [ ] Revisar que Go backend está en puerto 8080
- [ ] Crear/actualizar `docker/redis.conf` con `appendonly yes`
- [ ] Agregar `maxmemory-policy allkeys-lru` en redis.conf
- [ ] Agregar `timeout 300` en redis.conf
- [ ] Validar que todos los volúmenes están mapeados correctamente
- [ ] Ejecutar `docker-compose up` y confirmar que todos arrancan sin errores

**Criterios de aceptación:**
- Todos los servicios inician correctamente
- Los puertos están accesibles
- Redis persiste datos con AOF

---

### Issue #2: Configurar variables de entorno (.env)
**Labels:** configuration, environment, phase-1

Crear archivos .env en backend y frontend con las variables necesarias para desarrollo.

- [ ] Crear .env en gin-backend/ con DB_HOST, DB_PORT, DB_USER, DB_PASSWORD, DB_NAME, REDIS_HOST, REDIS_PORT, FCM_SERVER_KEY, CORS_ORIGINS
- [ ] Crear .env en frontend/ con VITE_API_URL, VITE_FCM_PUBLIC_KEY
- [ ] Agregar .env a .gitignore (backend y frontend)
- [ ] Validar que .env NO está comiteado

**Criterios de aceptación:**
- .env existe en ambas carpetas
- Variables contienen valores válidos
- .env no está en repositorio

---

### Issue #3: Inicializar base de datos (migraciones SQL)
**Labels:** database, migration, phase-1

Crear e ejecutar script de migraciones para inicializar PostgreSQL.

- [ ] Crear gin-backend/migrations/001_init.sql con tabla usuarios
- [ ] Crear tabla rutas con referencias a usuarios
- [ ] Crear tabla puntos_recoleccion
- [ ] Crear tabla notificaciones_enviadas
- [ ] Crear script para ejecutar migraciones al iniciar backend
- [ ] Validar conectividad backend ↔ PostgreSQL con test simple

**Criterios de aceptación:**
- Migraciones ejecutan sin errores
- Backend puede consultar tablas
- Datos se persisten correctamente

---

## FASE 2: Cliente Redis

### Issue #4: Implementar cliente Redis y conexión
**Labels:** redis, backend, phase-2
**Repositorio:** vicpoo/API_recolecta (Backend)

Crear funciones para conectar y gestionar el cliente Redis.

- [ ] Crear gin-backend/src/core/redis.go con conexión
- [ ] Crear gin-backend/src/core/redis_init.go para cargar puntos
- [ ] Agregar inicialización en main.go
- [ ] Tests básicos: conexión y GEOADD

**Criterios de aceptación:**
- Backend se conecta exitosamente a Redis
- Puntos de recolección se cargan en Redis al iniciar
- Comandos Redis se ejecutan sin errores

---

### Issue #5: Definir estructuras de datos Redis
**Labels:** redis, architecture, phase-2
**Repositorio:** vicpoo/API_recolecta (Backend)

Documentar y crear las claves y estructuras que se usarán en Redis.

- [ ] Definir clave conductor:{id}:position con TTL 5 min
- [ ] Definir clave puntos:geo como Sorted Set
- [ ] Definir clave notifications:pending con TTL 24h
- [ ] Definir clave events:log con TTL 7 días
- [ ] Crear documento con ejemplos de cada estructura

**Criterios de aceptación:**
- Estructuras definidas en documento
- Ejemplos JSON para cada clave
- TTLs y políticas definidas

---

### Issue #6: Documentar estructura de Redis
**Labels:** documentation, redis, phase-2
**Repositorio:** vicpoo/API_recolecta (Backend)

Crear documento detallado de estructura y uso de Redis en el proyecto.

- [ ] Crear gin-backend/REDIS_DOCUMENTATION.md
- [ ] Tabla de claves con nombre, tipo, TTL, descripción
- [ ] Sección de comandos Redis usados
- [ ] Sección de inicialización
- [ ] Sección de troubleshooting
- [ ] Ejemplos de queries con go-redis

**Criterios de aceptación:**
- Documento existe y es legible
- Todos los ejemplos funcionan
- Link a documento en README del backend

---

## FASE 3: Backend - Notificaciones

### Issue #7: Crear servicio de detección de proximidad
**Labels:** notifications, backend, phase-3
**Repositorio:** vicpoo/API_recolecta (Backend)

Implementar lógica para detectar cuando un conductor está cerca de un punto de recolección.

- [ ] Crear gin-backend/src/notificacion/domain/proximidad.go
- [ ] Crear gin-backend/src/notificacion/infrastructure/proximidad_repository.go
- [ ] Crear gin-backend/src/notificacion/application/proximidad_usecase.go
- [ ] Función DetectProximity con búsqueda en Redis
- [ ] Tests unitarios con 3 casos diferentes

**Criterios de aceptación:**
- Detección funciona correctamente
- Tests pasan
- Latencia < 200ms

---

### Issue #8: Integrar Firebase Cloud Messaging (FCM)
**Labels:** notifications, backend, phase-3
**Repositorio:** vicpoo/API_recolecta (Backend)

Implementar envío de notificaciones push a través de FCM.

- [ ] Crear cuenta Firebase y obtener Server Key
- [ ] Crear gin-backend/src/core/fcm.go con cliente FCM
- [ ] Crear gin-backend/src/notificacion/application/fcm_sender.go
- [ ] Función SendProximityNotification con manejo de errores
- [ ] Tests: envío exitoso, tokens inválidos, reintentos

**Criterios de aceptación:**
- Notificaciones se envían a FCM
- Errores se manejan correctamente
- Logs registran intentos

---

### Issue #9: Crear endpoints REST para notificaciones
**Labels:** api, backend, phase-3
**Repositorio:** vicpoo/API_recolecta (Backend)

Implementar endpoints que comuniquen frontend, conductores, y sistema de notificaciones.

- [ ] POST /api/conductor/posicion con detectar proximidad
- [ ] POST /api/usuario/registrar-fcm-token
- [ ] GET /api/notificaciones/historial
- [ ] GET /api/ruta/estado
- [ ] Agregar middleware CORS
- [ ] Logging en cada endpoint
- [ ] Tests con curl o Postman

**Criterios de aceptación:**
- Todos los endpoints devuelven respuestas correctas
- Manejo de errores 400, 404, 500
- Tests incluidos

---

### Issue #10: Tests unitarios para notificaciones
**Labels:** testing, backend, phase-3
**Repositorio:** vicpoo/API_recolecta (Backend)

Crear suite de tests para lógica de proximidad y FCM.

- [ ] Test DetectProximity: punto cercano
- [ ] Test DetectProximity: punto lejano
- [ ] Test DetectProximity: múltiples puntos
- [ ] Test SendNotification: envío exitoso
- [ ] Test SendNotification: token inválido
- [ ] Test endpoints: POST y GET
- [ ] Coverage mínimo 80%

**Criterios de aceptación:**
- Tests pasan
- Coverage >= 80%
- CI/CD ejecuta tests automáticamente

---

## FASE 4: Frontend

### Issue #11: Integrar Firebase Messaging en Frontend
**Labels:** notifications, frontend, phase-4
**Repositorio:** Denzel-Santiago/RecolectaWeb (Frontend)

Configurar recepción de notificaciones push en el navegador.

- [ ] Instalar firebase package
- [ ] Crear frontend/src/services/fcm.ts
- [ ] Crear frontend/public/firebase-messaging-sw.js
- [ ] Actualizar frontend/index.html
- [ ] Función requestFCMToken()
- [ ] Registrar Service Worker
- [ ] Tests: solicitud, token, envío

**Criterios de aceptación:**
- Notificaciones llegan en background
- Token se registra en backend
- Tests pasan

---

### Issue #12: Mostrar notificaciones en Dashboard
**Labels:** ui, frontend, phase-4
**Repositorio:** Denzel-Santiago/RecolectaWeb (Frontend)

Crear componentes para mostrar notificaciones en tiempo real.

- [ ] Crear componente NotificationBanner.tsx
- [ ] Actualizar Dashboard.tsx
- [ ] Actualizar EstadoRuta.tsx con mapa
- [ ] Agregar polling a GET /api/ruta/estado
- [ ] Botón 'Ver en mapa'
- [ ] Auto-dismiss tras 5 segundos
- [ ] Tests de UI

**Criterios de aceptación:**
- Notificaciones se muestran
- Mapa actualiza posición
- Tests pasan

---

### Issue #13: Guardar token FCM en registro de usuario
**Labels:** auth, frontend, phase-4
**Repositorio:** Denzel-Santiago/RecolectaWeb (Frontend)

Integrar FCM token en flujo de autenticación/registro.

- [ ] Actualizar página de Login
- [ ] Obtener FCM token tras login exitoso
- [ ] Enviar token a POST /api/usuario/registrar-fcm-token
- [ ] Guardar en localStorage
- [ ] Crear hook useFCMToken()
- [ ] Re-registrar token si expira
- [ ] Tests: token enviado al login

**Criterios de aceptación:**
- Token se registra correctamente
- Token se persiste tras logout/login
- Tests pasan

---

## FASE 5: Testing

### Issue #14: Test flujo completo end-to-end
**Labels:** testing, integration, phase-5

Validar el flujo completo desde GPS hasta Dashboard.

- [ ] Test manual: GPS → Proximidad → Notificación → Dashboard
- [ ] Medir latencia completa
- [ ] Objetivo: < 3 segundos
- [ ] Crear script de test automatizado
- [ ] Validar casos de error
- [ ] Documentar pasos en README

**Criterios de aceptación:**
- Flujo completo funciona sin errores
- Latencia < 3 segundos
- Casos de error manejados

---

### Issue #15: Validar persistencia de Redis
**Labels:** infrastructure, redis, phase-5

Confirmar que Redis recupera datos tras reiniciar.

- [ ] Verificar Redis con AOF activo
- [ ] Test 1: Reiniciar contenedor Redis
- [ ] Verificar que puntos se recargan
- [ ] Verificar historial disponible
- [ ] Test 2: Verificar archivo appendonly.aof
- [ ] Test 3: Pérdida de datos con TTL
- [ ] Documentar procedimiento

**Criterios de aceptación:**
- Redis recupera datos tras reinicio
- AOF funciona correctamente
- No hay pérdida de datos críticos

---

### Issue #16: Testing de carga: múltiples conductores
**Labels:** performance, testing, phase-5

Validar que el sistema aguanta múltiples conductores simultáneamente.

- [ ] Crear script de carga con 50+ conductores
- [ ] Envíos GPS cada 5 segundos
- [ ] Usar herramienta: Apache Bench o wrk
- [ ] Simular 1000 conductores por 5 minutos
- [ ] Medir latencia promedio, p50, p99
- [ ] Validar tasa de error < 1%
- [ ] Documentar resultados

**Criterios de aceptación:**
- Sistema aguanta 1000 conductores
- Latencias dentro de especificación
- Resultados documentados

---

## FASE 6: Documentación

### Issue #17: Crear estructura Wiki en GitHub
**Labels:** documentation, wiki, phase-6

Crear todas las páginas de la Wiki con contenido base.

- [ ] Página 1: Resumen del proyecto
- [ ] Página 2: Tecnologías y arquitectura
- [ ] Página 3: Despliegue
- [ ] Página 4: Gestión de usuarios y seguridad
- [ ] Página 5: Configuración inicial
- [ ] Página 6: Resumen de tecnologías
- [ ] Página 7: API endpoints
- [ ] Página 8: Troubleshooting y FAQ
- [ ] Agregar tabla de contenidos

**Criterios de aceptación:**
- Todas las páginas existen
- Contenido es coherente y legible
- Links internos funcionan

---

### Issue #18: Crear página Wiki 'Redis - Estructura de datos'
**Labels:** documentation, redis, wiki, phase-6

Documentar la estructura completa de Redis en la Wiki.

- [ ] Crear página en Wiki: 'Redis Structure'
- [ ] Tabla con nombre clave, tipo, TTL, descripción, ejemplo JSON
- [ ] Agregar ejemplos de comandos Redis
- [ ] Agregar sección de operaciones comunes
- [ ] Agregar sección de troubleshooting
- [ ] Link desde página 'Resumen de tecnologías'

**Criterios de aceptación:**
- Página existe y es clara
- Todos los ejemplos son correctos
- Fácil de entender para nuevos developers

---

### Issue #19: Agregar diagramas Mermaid en Wiki
**Labels:** documentation, wiki, phase-6

Crear diagramas Mermaid para visualizar arquitectura del proyecto.

- [ ] Diagrama de arquitectura general con componentes
- [ ] Diagrama de secuencia: GPS → Proximidad → Notificación
- [ ] Diagrama ER de base de datos
- [ ] Agregar todos a páginas correspondientes de Wiki
- [ ] Validar que se renderizan correctamente
- [ ] Crear markdown con ejemplos

**Criterios de aceptación:**
- Diagramas se renderizan correctamente
- Son fáciles de entender
- Están en formato Mermaid

---

## FASE 7: Producción

### Issue #20: Implementar logging completo en backend
**Labels:** observability, logging, phase-7

Agregar logs detallados en cada paso del flujo de notificaciones.

- [ ] Instalar logrus
- [ ] Crear gin-backend/src/core/logger.go
- [ ] Agregar logs en main.go
- [ ] Agregar logs en cliente Redis
- [ ] Agregar logs en endpoints
- [ ] Agregar logs en proximidad
- [ ] Agregar logs en FCM
- [ ] Frontend logging: token, notificación

**Criterios de aceptación:**
- Logs aparecen en console
- Archivo de logs se crea
- Información es relevante

---

### Issue #21: Agregar métricas Prometheus
**Labels:** observability, monitoring, phase-7

Agregar métricas para monitoreo en Prometheus.

- [ ] Instalar prometheus client_golang
- [ ] Crear métricas: proximity_detection_duration_seconds
- [ ] Crear métrica: notifications_sent_total
- [ ] Crear métrica: notifications_errors_total
- [ ] Crear métrica: fcm_send_latency_seconds
- [ ] Crear métrica: redis_operations_total
- [ ] Endpoint /metrics en backend
- [ ] Docker-compose para Prometheus
- [ ] Dashboard Grafana

**Criterios de aceptación:**
- Métricas se exponen en /metrics
- Prometheus scrappea datos
- Grafana visualiza

---

### Issue #22: Configurar HTTPS, certificados y producción
**Labels:** security, infrastructure, phase-7

Preparar infraestructura para producción segura.

- [ ] HTTPS en Nginx: generar certificados Let's Encrypt
- [ ] Configurar redirect HTTP → HTTPS
- [ ] Variables de entorno seguras
- [ ] NO commitear .env
- [ ] Backups automáticos PostgreSQL (script cron)
- [ ] Almacenamiento externo para backups
- [ ] Rotación de logs (logrotate)
- [ ] Hardening Docker: non-root users
- [ ] Read-only filesystems donde sea posible

**Criterios de aceptación:**
- HTTPS funciona
- Certificados válidos
- Backups se crean diariamente
- Logs no crecen indefinidamente

---

### Issue #23: Configurar alertas Prometheus
**Labels:** observability, monitoring, phase-7

Crear reglas de alerta para eventos críticos.

- [ ] Alerta: Redis no disponible
- [ ] Alerta: PostgreSQL sin espacio
- [ ] Alerta: FCM tasa de errores > 5%
- [ ] Alerta: Latencia detección > 5s
- [ ] Alerta: Backend no responding
- [ ] Archivo prometheus-rules.yml
- [ ] Alertmanager configurado
- [ ] Webhooks para Slack o email (opcional)
- [ ] Tests: simular condiciones

**Criterios de aceptación:**
- Alertas se disparan
- Notificaciones se envían
- Documentado en Troubleshooting

---

### Issue #24: Crear plan de desastre y recuperación
**Labels:** operations, disaster-recovery, phase-7

Documentar procedimientos de recuperación ante fallos.

- [ ] Crear documento DISASTER_RECOVERY.md:
  - Escenario: Redis caído
  - Escenario: PostgreSQL corrupto
  - Escenario: Backend caído
  - Escenario: Múltiple fallos
- [ ] RTO (Recovery Time Objective) por servicio
- [ ] RPO (Recovery Point Objective) por servicio
- [ ] Contactos y escalación
- [ ] Checklist validación post-recuperación
- [ ] Equipo sabe cómo usar

**Criterios de aceptación:**
- Documento completo y claro
- Procedimientos documentados
- Equipo entrenado
