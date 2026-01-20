# 🔗 Integración: Workflow + GitHub Project

Cómo hacer que todo funcione en conjunto: el script, los submódulos y el GitHub Project.

---

## 🎯 Objetivo Final

```
Tú trabajas localmente (submódulos)
       ↓
Script automatiza commits en padre
       ↓
PRs en GitHub
       ↓
GitHub Project ve todo en tiempo real
```

---

## 📋 Checklist de Configuración (Una sola vez)

### 1. GitHub Project: Campos Personalizados

Ya están configurados en tu Project "RECOLECTA SISTEMA NOTIFICACIONES":
- ✅ `Fase`: F1 (Planificación) a F7 (Cerrado)
- ✅ `Area`: Frontend, Backend, Infra
- ✅ `Tipo`: Feature, Bug, Docs
- ✅ `Urgencia`: Baja, Media, Alta

**Nota:** Status se edita en la UI del Project (Backlog, En progreso, En revisión, Bloqueado, Hecho).

### 2. GitHub Project: Automatizaciones (Opcional pero Recomendado)

En tu Project, ve a **"Settings" → "Workflows"** y habilita:

- ✅ **"Auto-add when items are created or updated"**
  - Repo: `recolecta_web`
  - Automáticamente añade Issues nuevos al Project

- ✅ **"Close when pull request is merged"**
  - Si PR está linkead a Issue (Closes #X), cierra Issue automáticamente
  - Ya lo hace GitHub, pero con esto Project lo refleja instantáneamente

- ✅ **"Auto-archive when issues are closed"**
  - Opcional: archiva Issues cerrados automáticamente

---

## 🚀 Workflow Completo: Paso a Paso

### Paso 1: Crear Issue (5 min)

**En GitHub web:**

```
URL: https://github.com/RodrigoMijangos/recolecta_web/issues/new

Crear Issue:
┌─────────────────────────────────────────┐
│ Título: [Frontend] Add logout button    │
│                                         │
│ Descripción:                            │
│ Agregar botón de logout en navbar      │
│ - Cerrar sesión                         │
│ - Limpiar localStorage                  │
│                                         │
│ Etiquetas (side right):                 │
│ ✓ Area: Frontend                        │
│ ✓ Fase: F2-Desarrollo                   │
│ ✓ Tipo: Feature                         │
│ ✓ Urgencia: Media                       │
└─────────────────────────────────────────┘

✅ Crear Issue → Obtienes Issue #42
```

**Resultado en Project:**
```
Si tienes "Auto-add" habilitado:
  - Issue #42 aparece automáticamente en el Project
  - Fase: F2-Desarrollo
  - Area: Frontend
  - Tipo: Feature
  - Status: Backlog (por defecto)
```

### Paso 2: Iniciar Trabajo Localmente (2 min)

**En PowerShell:**

```powershell
cd C:\Users\RodrigoMijangos\Documents\GithubProjects\recolecta_web

# Crear rama de trabajo
.\workflow-submodules.ps1 -action init-branch -branch feature/issue-42 -issueNumber 42

# Resultado:
# ✅ Rama feature/issue-42 creada
# ✅ Trackeando origin/main
# ✅ HEAD en feature/issue-42
```

**Cambio en Project:**
```
Esperas aquí... Project no ve cambios aún
(porque no hay commits ni PRs)
```

### Paso 3: Desarrollar (15 min)

**En PowerShell:**

```powershell
# Entrar a frontend
.\workflow-submodules.ps1 -action work -submodule frontend

# Resultado: Terminal en C:\...\recolecta_web\frontend
```

**Dentro de frontend:**

```powershell
# Editar archivos
code src/components/Navigation/Navbar.tsx

# Agregar cambios
git add src/components/Navigation/Navbar.tsx
git commit -m "feat: add logout button to navbar"

# Pushear
git push origin main

# Volver al padre
cd ..
```

**Cambio en Project:**
```
Frontend tiene nuevos commits
Pero Project TODAVÍA no ve cambios
(porque padre sigue apuntando a SHA viejo)
```

### Paso 4: Registrar Cambio (1 min)

**En PowerShell:**

```powershell
# Actualizar referencia en padre
.\workflow-submodules.ps1 -action update-parent -submodule frontend

# Resultado:
# - Commit en padre: "chore: update frontend ref"
# - Padre pusheado a feature/issue-42
```

**Cambio en Project:**
```
Si usas interfaz GitHub:
  - Branch feature/issue-42 tiene nuevo commit
  - Aún no hay PR

O si usas API/webhook (automático):
  - Project ve actividad en la rama
  - Status podrías cambiar a "En progreso" manualmente
```

### Paso 5: Crear Pull Request (5 min)

**En GitHub web:**

```
URL: https://github.com/RodrigoMijangos/recolecta_web/pulls/new

Crear PR:
┌──────────────────────────────────────────────┐
│ Base: main                                   │
│ Compare: feature/issue-42                    │
│                                              │
│ Título: Closes #42: [Frontend] Add logout   │
│ button                                       │
│                                              │
│ Description:                                 │
│ Implemented logout button in navbar          │
│ - Added button styling                       │
│ - Connected to auth service                  │
│                                              │
│ Closes #42                                   │
│ (GitHub detecta automáticamente)             │
└──────────────────────────────────────────────┘

✅ Crear PR → Obtienes PR #43
```

**Cambio en Project:**
```
GitHub automáticamente:
  - Linkea PR #43 con Issue #42
  - El Project ve: "Linked to PR #43"
  - Si tienes webhook, podrías cambiar Status a "En revisión"
```

### Paso 6: Mergear PR (2 min)

**En GitHub web:**

```
En PR #43:

✅ Se ve "Able to merge" (o esperas reviews)
✅ Click "Merge pull request"
   ├─ Merge commit (predeterminado)
   ├─ Squash and merge (limpia history)
   └─ Rebase and merge (linear)

Resultado:
  - PR #43 → Merged
  - Branch feature/issue-42 → Merged a main
```

**Cambio Automático en GitHub:**
```
GitHub ve "Closes #42" en PR #43
  ↓
Cuando PR se mergea
  ↓
Issue #42 se cierra automáticamente ✅
```

**Cambio en Project:**
```
Automático (si tienes webhook):
  - Issue #42 → Status: Done ✓
  - PR #43 → Status: Merged ✓
  - Timeline visible:
    • Created: Jan 20, 10:00
    • Linked to PR: Jan 20, 10:30
    • PR Merged: Jan 20, 11:00
    • Closed: Jan 20, 11:00
```

---

## 📊 Vista Final en el Project

```
Proyecto: RECOLECTA SISTEMA NOTIFICACIONES

┌─────────────────────────────────────────────────────┐
│ Issue #42: [Frontend] Add logout button             │
│ Status: Done                                        │
│ Fase: F2-Desarrollo                                 │
│ Area: Frontend                                      │
│ Tipo: Feature                                       │
│ Urgencia: Media                                     │
│ Linked PR: #43 (Merged)                             │
│                                                     │
│ Timeline:                                           │
│ - Created: Jan 20, 10:00                            │
│ - PR Created: Jan 20, 10:30                         │
│ - PR Merged: Jan 20, 11:00                          │
│ - Closed: Jan 20, 11:00                             │
│                                                     │
│ Commits en repo padre:                              │
│ - "chore: update frontend ref"                      │
└─────────────────────────────────────────────────────┘
```

---

## 🔄 Patrón Repetible

Para cada Issue/Feature:

```
Issue #42 → init-branch → work + commit/push → update-parent 
  ↓
  └→ (si hay más cambios en otro submódulo)
     work (backend) → commit/push → update-parent
  
  ↓
  Crear PR en web (Closes #42)
  
  ↓
  Mergear PR → Issue cierra automáticamente
  
  ↓
  Project: Visible como Done
```

---

## 🎓 Máximo Entendimiento: Internamente

Cuando haces todo esto, GitHub internamente:

```
1. Creas Issue #42
   └─ GitHub almacena: Issue #42 en recolecta_web
   
2. Inicias rama feature/issue-42
   └─ Git almacena: rama local + remote

3. Haces cambios en frontend
   └─ Frontend repo: nuevos commits
   
4. update-parent en padre
   └─ Padre: nuevo commit (actualiza ref de frontend)
   └─ Padre: commit en feature/issue-42
   
5. Creas PR #43 "Closes #42"
   └─ GitHub linkea: PR #43 → Issue #42
   └─ GitHub detecta: "Closes #42" en descripción
   
6. Mergeas PR #43
   └─ main: recibe commits de feature/issue-42
   └─ GitHub: cierra Issue #42 automáticamente
   
7. Project (si tiene webhooks)
   └─ Ve Issue #42 → Done
   └─ Ve PR #43 → Merged
   └─ Ve timeline completa
```

---

## 🛠️ Configuración de Project (Si lo necesitas)

### En GitHub Project UI:

1. Abre tu Project: "RECOLECTA SISTEMA NOTIFICACIONES"

2. Click **"Settings"** (gear icon)

3. En "Workflows", habilita:
   ```
   ✓ Auto-add items
   ✓ Auto-archive closed items (opcional)
   ```

4. En "Custom fields", verifica:
   ```
   ✓ Fase (options: F1 a F7)
   ✓ Area (options: Frontend, Backend, Infra)
   ✓ Tipo (options: Feature, Bug, Docs)
   ✓ Urgencia (options: Baja, Media, Alta)
   ```

5. En "Status", edita opciones si quieres:
   ```
   Backlog → En progreso → En revisión → Bloqueado → Done
   (Puedes cambiar nombres)
   ```

---

## 🎯 Checklist Final: Antes de Empezar

- [ ] Issues creados en `recolecta_web` (no en otros repos)
- [ ] Etiquetas asignadas (Area, Fase, Tipo, Urgencia)
- [ ] Project tiene custom fields configurados
- [ ] Script `workflow-submodules.ps1` descargado en repo padre
- [ ] Entiendes: Issue → Rama → Cambios → Update Ref → PR → Merge
- [ ] Sabes usar: `init-branch`, `work`, `update-parent`

---

## 💡 Pro Tips

1. **Usa "Closes #X" siempre** en PRs para cierre automático
   
2. **Etiqueta Issues inmediatamente** al crearlos
   - Si no, el Project no sabe categorizarlos

3. **Ejecuta `status` regularmente** para asegurar todo está consistente
   ```powershell
   .\workflow-submodules.ps1 -action status
   ```

4. **Sincroniza submódulos antes de empezar rama nueva**
   ```powershell
   .\workflow-submodules.ps1 -action sync-all
   ```

5. **Una rama = Una feature**
   - No mezcles Issues en una rama
   - Si necesitas multiple features: múltiples ramas, múltiples PRs

---

## ❓ Preguntas

**P: ¿GitHub cierra Issue automáticamente?**
R: Sí, si usas "Closes #X" en PR y mergeas. No necesitas hacerlo manual.

**P: ¿El Project se actualiza solo?**
R: Issues sí, automáticamente. PRs si tienes webhook. Status manual o via webhook.

**P: ¿Qué pasa si no actualizo ref?**
R: El submódulo tiene cambios, padre no. Todo queda desincronizado y Project no ve actividad.

**P: ¿Debo usar el script?**
R: No es obligatorio, pero es más fácil. Puedes hacer todo manualmente si entiendes los pasos.

**P: ¿Cuánto tarda todo?**
R: Issue + Desarrollo: 20-30 min
   PR + Merge: 5 min
   Total: 25-35 min por feature pequeña

---

## 🚀 Empezar Ahora

```powershell
# 1. Ver status
.\workflow-submodules.ps1 -action status

# 2. Crear rama de prueba
.\workflow-submodules.ps1 -action init-branch -branch test/workflow -issueNumber 999

# 3. Entrar a frontend
.\workflow-submodules.ps1 -action work -submodule frontend

# 4. Salir (Ctrl+C o escribir exit)
cd ..

# 5. Ver que branch está configurada
git branch -v
```

¡Listo para empezar!
