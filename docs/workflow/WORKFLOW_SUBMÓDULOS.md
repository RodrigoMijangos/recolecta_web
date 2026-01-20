# 🔄 Workflow: Trabajar con Submódulos y Mantener Trazabilidad

Este documento describe cómo trabajar con los submódulos (`frontend`, `backend`) manteniendo trazabilidad completa en el GitHub Project.

## 🎯 Objetivo

Garantizar que:
1. Cada cambio en submódulos esté registrado en GitHub.
2. Cada cambio esté vinculado a un Issue del Project.
3. El Project tenga visibilidad temporal clara (inicio → desarrollo → cierre).

---

## 📋 Flujo Completo

### Fase 1: Preparación (antes de trabajar)

1. **Crear Issue en GitHub**
   - Ve a [Repo: recolecta_web → Issues](https://github.com/RodrigoMijangos/recolecta_web/issues)
   - Crea Issue #X: `[Frontend/Backend] <Descripción>`
   - Etiquetas: `Area: Frontend/Backend`, `Fase: F1-Planificación`, `Tipo: Feature/Fix`
   - Nota: El Issue debe estar en `recolecta_web`, no en otros repos.

2. **Crear rama de trabajo**
   ```powershell
   .\workflow-submodules.ps1 -action init-branch -branch feature/issue-X -issueNumber X
   ```
   - Crea rama local `feature/issue-X` trackeando `origin/main`
   - Ahora estás listo para trabajar.

---

### Fase 2: Desarrollo (mientras haces cambios)

1. **Navegar al submódulo donde trabajarás**
   ```powershell
   .\workflow-submodules.ps1 -action work -submodule frontend
   ```
   - Se abre una terminal en `frontend/`
   - Haz cambios normales: edita archivos, añade features.

2. **Hacer cambios y commitear en el submódulo**
   ```powershell
   # Dentro de frontend/
   git add src/components/...
   git commit -m "feat: add notification component"
   ```

3. **Pushear cambios al remoto del submódulo**
   ```powershell
   # Dentro de frontend/
   git push origin main
   ```

4. **Volver al padre**
   ```powershell
   cd ..  # Vuelves a recolecta_web
   ```

---

### Fase 3: Actualizar Trazabilidad (después de cada cambio en submódulo)

1. **Actualizar referencia del submódulo en el padre**
   ```powershell
   .\workflow-submodules.ps1 -action update-parent -submodule frontend -message "feat: add notification component"
   ```
   - Hace commit en padre: `"chore: update frontend ref"`
   - Pushea el padre.
   - Ahora el padre apunta al nuevo SHA del submódulo.

2. **Repetir Fase 2 + 3 según necesites**
   - Cambios en frontend → pushear → actualizar ref.
   - Cambios en backend → pushear → actualizar ref.
   - Cada actualización de ref es un commit en el padre (visible en Project).

---

### Fase 4: Cierre (cuando terminas todos los cambios)

1. **Sincronizar todos los submódulos (opcional, pero recomendado)**
   ```powershell
   .\workflow-submodules.ps1 -action sync-all
   ```
   - Asegura que todos los submódulos estén en `main` actualizado.
   - Actualiza referencias en el padre.

2. **Crear Pull Request en repo padre**
   ```
   De: feature/issue-X
   Hacia: main
   Título: "Closes #X: [Frontend/Backend] <Descripción>"
   Body:
   - Cierra Issue #X
   - Resumen de cambios en submódulos
   ```
   - GitHub linkea automáticamente: cuando mergeas PR, cierra Issue.

3. **Mergear PR**
   - Una vez mergead, el Issue se cierra automáticamente.
   - El Project ahora ve: Issue #X abierto → PR #Y creado → PR merged → Issue cerrado.

---

## 🛠️ Comandos Disponibles

### `init-branch`
Crea una rama de trabajo trackeando `origin/main`.
```powershell
.\workflow-submodules.ps1 -action init-branch -branch feature/issue-42 -issueNumber 42
```
**Parámetros:**
- `-branch`: Nombre de la rama (ej: `feature/issue-42`, `bugfix/navbar`)
- `-issueNumber`: Número del Issue en recolecta_web (ej: `42`)

---

### `work`
Abre una terminal en el submódulo para trabajar.
```powershell
.\workflow-submodules.ps1 -action work -submodule frontend
```
**Parámetros:**
- `-submodule`: `frontend` o `backend` o `gin-backend`

---

### `commit-submodule`
Pushea cambios del submódulo a `origin/main` y actualiza la ref en padre.
```powershell
.\workflow-submodules.ps1 -action commit-submodule -submodule frontend
```
**Parámetros:**
- `-submodule`: `frontend` o `backend` o `gin-backend`

---

### `update-parent`
Actualiza la referencia del submódulo en el padre (solo si ya pusheaste el submódulo).
```powershell
.\workflow-submodules.ps1 -action update-parent -submodule frontend -message "feat: add notification"
```
**Parámetros:**
- `-submodule`: `frontend` o `backend` o `gin-backend`
- `-message`: Descripción del cambio (opcional, default: "Update submodule")

---

### `sync-all`
Sincroniza todos los submódulos a `main` y actualiza referencias en padre.
```powershell
.\workflow-submodules.ps1 -action sync-all
```
**Útil antes de empezar trabajo nuevo o antes de crear PR.**

---

### `status`
Ver estado completo del padre y submódulos.
```powershell
.\workflow-submodules.ps1 -action status
```

---

## 📊 Ejemplo Completo: Feature "Notificaciones en Navbar"

### 1. Preparación
```powershell
# Creas Issue #25 en GitHub manualmente
# Título: "[Frontend] Add notifications to navbar"

# Script
.\workflow-submodules.ps1 -action init-branch -branch feature/issue-25 -issueNumber 25
# ✅ Rama creada: feature/issue-25
```

### 2. Desarrollo
```powershell
# Entrar a frontend
.\workflow-submodules.ps1 -action work -submodule frontend

# Dentro de frontend/
git add src/components/Navigation/Navbar.tsx
git commit -m "feat: add notification bell icon"
git push origin main
cd ..

# Actualizar ref en padre
.\workflow-submodules.ps1 -action update-parent -submodule frontend
# ✅ Padre commitea y pushea: "chore: update frontend ref"
```

### 3. Más cambios
```powershell
# Si necesitas más cambios
.\workflow-submodules.ps1 -action work -submodule frontend
# ... editar más archivos ...
git add src/components/...
git commit -m "feat: add notification dropdown"
git push origin main
cd ..

.\workflow-submodules.ps1 -action update-parent -submodule frontend
# ✅ Padre commitea de nuevo
```

### 4. Cierre
```powershell
# Ver estado final
.\workflow-submodules.ps1 -action status

# Crear PR en GitHub
# De: feature/issue-25
# Hacia: main
# Body: "Closes #25"

# Mergear PR → GitHub cierra Issue automáticamente
# ✅ Project ve: Issue #25 → PR #30 → Merged → Closed
```

---

## 🔗 Cómo se Ve en el Project

Después de todo esto, en tu Project "RECOLECTA SISTEMA NOTIFICACIONES" verás:

| Issue | Estado | PR | Fase | Area | Tipo |
|-------|--------|----|----|------|------|
| #25   | Closed | #30 | F2-Desarrollo | Frontend | Feature |

Clicando en Issue #25 → ves la timeline completa:
- Creado: `<fecha>`
- Linked to PR #30: `<fecha>`
- PR merged: `<fecha>`
- Closed: `<fecha>`

Y en PR #30 → ves todos los commits en `recolecta_web` (que incluyen actualizaciones de refs), e inspeccionando el ref puedes ver los commits reales en `frontend/`.

---

## ⚠️ Consejos Importantes

1. **Siempre actualiza la ref después de pushear submódulo**
   - Sin esto: trabajo desincronizado, Project no ve trazabilidad.

2. **Crea Issues en `recolecta_web`, no en otros repos**
   - El Project solo ve issues de repos que agregaste a él (actualmente solo recolecta_web).

3. **Linkea Issues con Closes #X en el PR**
   - GitHub cierra automáticamente cuando mergeas.

4. **Un Issue = Una feature/bugfix**
   - Aunque afecte múltiples submódulos, todo es 1 Issue en el padre.
   - Si es muy grande, divídelo en sub-tasks (descripciones con checklist).

5. **Sincroniza regularmente con `sync-all`**
   - Antes de empezar rama nueva, asegura que todos estén actualizados.

---

## 🚀 Integración con Project

El Project `RECOLECTA SISTEMA NOTIFICACIONES` automáticamente:
1. Detect Issues en `recolecta_web`.
2. Asigna `Fase` según etiqueta (F1, F2, ..., F7).
3. Asigna `Area` (Frontend, Backend, Infra).
4. Detecta PRs linkadas.
5. Cambia estado cuando Issue se cierra.

**Asegúrate de:**
- Etiquetar Issues al crearlos.
- Usar patrón "Closes #X" en PR.

---

## ❓ FAQ

**P: ¿Qué pasa si olvido actualizar la ref?**
R: El submódulo tiene cambios, pero el padre sigue apuntando a SHA viejo. El Project ve el Issue pero no hay PR visible. Solución: ejecuta `update-parent` ahora.

**P: ¿Puedo trabajar en múltiples submódulos al mismo tiempo?**
R: Sí, con la rama `feature/issue-X`. Trabaja en frontend, pushea, actualiza ref. Luego trabaja en backend, pushea, actualiza ref. Mismo Issue, múltiples cambios.

**P: ¿Se ve en el Project mientras estoy desarrollando?**
R: Sí, cada `update-parent` es un commit en el padre. El Project ve la actividad. Cuando mergeas PR, cierra Issue.

**P: ¿Cómo veo los cambios reales en submódulos desde el Project?**
R: El Project linkea a issues/PRs del padre. Si clicas PR #30 → ves el commit que actualiza refs → allí ves el diff. Para ver cambios exactos en frontend, debes ir al repo frontend y revisar ese commit.

---

## 📞 Soporte

Si algo falla:
1. Ejecuta `.\workflow-submodules.ps1 -action status` para ver estado.
2. Revisa errores de git.
3. Contacta con el equipo si necesitas resetear una ref.
