# 📋 Plantillas de Pull Request (PR)

Usa estas plantillas cuando crees un PR en GitHub. Copia y ajusta según sea necesario.

---

## 📝 Plantilla 1: Feature Simple (Recomendada)

```markdown
## Closes #X: [Area] Descripción breve

### Descripción
Breve resumen de qué se hizo.

### Cambios
- Cambio 1
- Cambio 2
- Cambio 3

### Submódulos Afectados
- [ ] Frontend
- [ ] Backend
- [ ] GinBackend
- [ ] Infra

### Testing
¿Cómo testear esto?
- Paso 1
- Paso 2

### Notas
Cualquier nota adicional.
```

**Uso:** Para features pequeñas a medianas

**Ejemplo:**
```markdown
## Closes #42: [Frontend] Add logout button

### Descripción
Se agregó botón de logout en el navbar que cierra la sesión del usuario.

### Cambios
- Nuevo componente LogoutButton.tsx
- Integración con auth service
- Estilos CSS actualizados

### Submódulos Afectados
- [x] Frontend
- [ ] Backend
- [ ] GinBackend
- [ ] Infra

### Testing
- Click en el botón logout
- Verificar que limpia localStorage
- Verificar redirect a login

### Notas
Requiere actualización del navbar CSS
```

---

## 📝 Plantilla 2: Feature Compleja (Múltiples Submódulos)

```markdown
## Closes #X: [Epígrafe] Descripción

### Descripción Detallada
Explicación completa de qué se implementó y por qué.

### Cambios en Frontend
- Cambio 1
- Cambio 2

### Cambios en Backend
- Cambio 1
- Cambio 2

### Cambios en Infra
- Cambio 1
- Cambio 2

### API Endpoints (si aplica)
```
POST /api/notifications
GET /api/notifications/:id
DELETE /api/notifications/:id
```

### Base de Datos (si aplica)
- Nueva tabla: `notifications`
- Migraciones: `001_create_notifications.sql`

### Submódulos Afectados
- [x] Frontend
- [x] Backend
- [x] GinBackend
- [ ] Infra

### Testing
#### Frontend
- Paso 1
- Paso 2

#### Backend
- Paso 1
- Paso 2

### Screenshots/GIFs (si aplica)
![Navbar update](link-to-screenshot)

### Notas de Deployment
- Requiere variables de entorno: `NOTIFICATION_API_KEY`
- Requiere migración DB
- Requiere rebuild de Docker

### Checklist
- [ ] Tests pasados localmente
- [ ] Documentación actualizada
- [ ] Sin console.log() de debug
- [ ] Códigos de error documentados
```

**Uso:** Para features grandes que afecten múltiples submódulos

---

## 📝 Plantilla 3: Bugfix

```markdown
## Closes #X: [Area] Fix - Descripción del bug

### Descripción del Bug
Explicar qué estaba roto y por qué.

### Causa Raíz
Explicar por qué sucedía.

### Solución
Cómo se arregló.

### Cambios
- Cambio 1
- Cambio 2

### Testing
Cómo verificar que el bug está arreglado:
- Paso 1
- Paso 2

### Submódulos Afectados
- [x] Frontend
- [ ] Backend
- [ ] GinBackend
- [ ] Infra

### Notas
Cualquier nota importante.
```

**Ejemplo:**
```markdown
## Closes #38: [Backend] Fix - API returns 500 on invalid notification ID

### Descripción del Bug
Cuando se llama a GET /api/notifications con un ID inválido, el servidor retorna 500 en lugar de 404.

### Causa Raíz
El handler no validaba que el ID fuera un UUID válido antes de consultar la DB.

### Solución
Se agregó validación de UUID en el handler.

### Cambios
- Función ValidateUUID en notification_handler.go
- Error handling mejorado

### Testing
- GET /api/notifications/invalid-id → Retorna 400
- GET /api/notifications/00000000-0000-0000-0000-000000000000 → Retorna 404

### Submódulos Afectados
- [ ] Frontend
- [x] Backend
- [ ] GinBackend
- [ ] Infra
```

---

## 📝 Plantilla 4: Documentation

```markdown
## Closes #X: [Docs] Descripción

### Archivos Actualizados
- Archivo 1
- Archivo 2

### Cambios
- Cambio 1
- Cambio 2

### Notas
Contexto adicional.
```

---

## 🎯 Patrón Obligatorio

**Cada PR DEBE contener:**

```
Closes #X
```

Esto es lo más importante. GitHub usará esto para:
- Linkear el PR con el Issue
- **Cerrar automáticamente el Issue cuando mergees el PR**
- Actualizar el Project

### Formato Correcto:
```markdown
## Closes #42: [Frontend] Add logout button
```

### Formatos Que También Funcionan:
```markdown
Closes #42
Fixes #42
Resolves #42
```

### ⚠️ Importante:
- Case-sensitive (usa "Closes", no "closes" - aunque GitHub es flexible)
- Debe estar en el título o en la descripción
- Si hay múltiples issues: `Closes #42, #43, #44`

---

## 🚀 Paso a Paso: Crear PR

### En GitHub Web:

1. Ve a **Pull Requests** → **New Pull Request**

2. Selecciona:
   - **Base:** `main`
   - **Compare:** tu rama (ej: `feature/issue-42`)

3. Título:
   ```
   Closes #42: [Frontend] Add logout button
   ```

4. Descripción (elige plantilla según tipo):
   - Simple: Plantilla 1
   - Compleja: Plantilla 2
   - Bug: Plantilla 3
   - Docs: Plantilla 4

5. Click **"Create Pull Request"**

6. GitHub linkea automáticamente con Issue #42

7. (Opcional) Add labels, reviewers, etc.

8. Click **"Merge Pull Request"** cuando esté listo

9. GitHub cierra Issue #42 automáticamente ✅

---

## 💡 Pro Tips

1. **Sé claro y conciso**
   - El PR es documentación de qué cambió y por qué
   - Alguien del equipo lo leerá en el futuro

2. **Usa checkboxes para validación**
   ```markdown
   ### Checklist
   - [ ] Tests pasados
   - [ ] Sin console.log()
   - [ ] Documentación actualizada
   ```

3. **Incluye ejemplos de uso**
   ```markdown
   ### Uso
   ```javascript
   const result = newFunction({ option: true });
   ```
   ```

4. **Agrega screenshots si es visual**
   ```markdown
   ![Navbar changes](https://path-to-screenshot.png)
   ```

5. **Menciona warnings/breaking changes**
   ```markdown
   ⚠️ Breaking Change: removeOldAPI() fue removida
   ```

---

## 📊 Checksum: PR Completo

Antes de mergear, verifica:

- [ ] Título contiene "Closes #X"
- [ ] Descripción clara de cambios
- [ ] Submódulos correctos marcados
- [ ] Testing section completa
- [ ] Notas si hay breaking changes
- [ ] Screenshots si es visual
- [ ] Todo tus cambios están incluidos

---

## 🎬 Ejemplo Completo: Real

```markdown
## Closes #50: [Backend] Implement two-factor authentication endpoint

### Descripción
Se implementó el endpoint para two-factor authentication. Los usuarios pueden ahora:
- Generar códigos TOTP
- Validar códigos TOTP
- Habilitar/deshabilitar 2FA en su cuenta

### Cambios en Backend
- Nuevo handler: `notification_handler.go`
- Nuevo servicio: `totp_service.go`
- Nueva migración: `002_add_totp_columns.sql`
- Actualizado: `user_model.go` (campos totp_secret, totp_enabled)

### API Endpoints
```
POST /api/users/totp/enable → Retorna secret
POST /api/users/totp/validate → Valida código
DELETE /api/users/totp/disable → Deshabilita 2FA
```

### Base de Datos
```sql
ALTER TABLE users ADD COLUMN totp_secret VARCHAR(32);
ALTER TABLE users ADD COLUMN totp_enabled BOOLEAN DEFAULT FALSE;
ALTER TABLE users ADD COLUMN totp_backup_codes TEXT[];
```

### Submódulos Afectados
- [ ] Frontend (próximo PR)
- [x] Backend
- [ ] GinBackend
- [ ] Infra

### Testing
```bash
# 1. Generate TOTP secret
curl -X POST http://localhost:8080/api/users/totp/enable \
  -H "Authorization: Bearer TOKEN"
# Response: { "secret": "...", "qr_code": "..." }

# 2. Validate TOTP code
curl -X POST http://localhost:8080/api/users/totp/validate \
  -H "Authorization: Bearer TOKEN" \
  -d '{"code": "123456"}'
# Response: { "success": true }
```

### Notas
- TOTP usa estándar RFC 6238
- Backup codes generados automáticamente (8 códigos)
- Requiere variable env: `TOTP_WINDOW_SIZE` (default: 1)

### Checklist
- [x] Tests unitarios pasados (100% coverage)
- [x] Tests de integración pasados
- [x] Documentación API actualizada
- [x] Sin console.log() de debug
- [x] Handled error cases (invalid code, expired, etc)
```

---

## 🎓 Estructura Mínima (Si tienes prisa)

```markdown
## Closes #X: Descripción

### Cambios
- Cambio 1
- Cambio 2

### Testing
- Cómo testear
```

**Usable pero no recomendado. Mejor usar una plantilla.**

---

## 📌 Recordatorios

1. **SIEMPRE "Closes #X"** - Es lo más importante
2. **Describe QUÉ cambió** - Los reviewers necesitan entender
3. **Explica POR QUÉ** - Para auditoría futura
4. **Incluye testing steps** - Para que otros validen
5. **Menciona cambios breaking** - Si los hay

**Buen PR = Buena documentación del proyecto**
