# 🎯 Trazabilidad de Trabajo: Workflow Explicado

## 📊 Diagrama del Flujo

```
GITHUB PROJECT
│
├─ Issue #5: "[Frontend] Update navbar"
│  ├─ Estado: Open → In Progress → Done
│  ├─ Etiquetas: Frontend, F2-Desarrollo, Feature
│  └─ Linked PR: #10
│
└─ Issue #6: "[Backend] Add endpoint"
   ├─ Estado: Open → In Progress → Done
   ├─ Etiquetas: Backend, F2-Desarrollo, Feature
   └─ Linked PR: #11


REPO: recolecta_web (PADRE)
│
├─ Rama: main
│  └─ Commits regulares
│
└─ Rama: feature/issue-5
   ├─ Commit 1: "chore: update frontend ref" ← Update-parent llamado
   ├─ Commit 2: "chore: update frontend ref" ← Update-parent llamado
   └─ Commit 3: "chore: sync all submodule refs" ← Sync-all
   
   
REPO: frontend (SUBMÓDULO)
│
└─ Rama: main
   ├─ Commit A: "feat: update navbar style" ← Tu trabajo
   ├─ Commit B: "feat: add notification icon" ← Tu trabajo
   └─ (pusheado a origin/main)


FLUJO TEMPORAL:
│
├─ T1: Creas Issue #5 en GitHub (en recolecta_web)
│  └─ Project: Muestra Issue #5 como "Open"
│
├─ T2: Creas rama feature/issue-5
│  └─ Repo padre se mantiene en estado inicial
│
├─ T3: Trabajas en frontend/, haces cambios, git add/commit/push
│  └─ Frontend ahora tiene nuevos commits en origin/main
│  └─ Pero padre TODAVÍA apunta a SHA viejo
│
├─ T4: Ejecutas update-parent → commit en padre
│  ├─ Padre hace commit "chore: update frontend ref"
│  ├─ Padre pushea a feature/issue-5
│  └─ Project: Detecta cambio en la rama (commit nuevo)
│
├─ T5: (Repetir T3-T4 si hay más cambios)
│  └─ Cada update-parent es un nuevo commit visible
│
├─ T6: Crean PR #10 en GitHub
│  ├─ De: feature/issue-5
│  ├─ Hacia: main
│  ├─ Body: "Closes #5"
│  └─ Project: Linkea PR #10 con Issue #5
│
├─ T7: PR #10 se mergea
│  └─ Project: Issue #5 se cierra automáticamente (porque tiene "Closes #5")
│
└─ T8: Final
   └─ Project muestra: Issue #5 → Done, Linked to PR #10 (Merged)
```

---

## 🔍 ¿Qué Ve el Project en Cada Momento?

### Antes de actualizar ref (❌ PROBLEMA)

```
Submódulo tiene cambios: ✅
Padre apunta a SHA viejo: ❌
Project ve Issues: ✅
Project ve Commits en padre: ❌

Resultado: Issue abierto, pero sin actividad visible
Tiempo: Parece que no estás trabajando
```

### Después de actualizar ref (✅ CORRECTO)

```
Submódulo tiene cambios: ✅
Padre apunta a SHA nuevo: ✅
Project ve Issues: ✅
Project ve Commits en padre: ✅

Resultado: Issue abierto, actividad visible (commits)
Tiempo: Se ve que estás desarrollando
```

---

## 📈 Timeline Visible en el Project

Cuando mergeas PR con "Closes #X":

```
Issue #5 Timeline (visible en GitHub):

Created:        Jan 20, 2026  ←─── Cuando creas Issue
Linked to PR:   Jan 20, 2026  ←─── Cuando creas PR (después de cambios)
PR Merged:      Jan 20, 2026  ←─── Cuando mergeas
Closed:         Jan 20, 2026  ←─── Automático al mergear

Activity (Commits):
  Jan 20, 10:00 - Commit: "chore: update frontend ref" (padre)
  Jan 20, 10:15 - Commit: "chore: update frontend ref" (padre)
  Jan 20, 10:30 - PR created
  Jan 20, 11:00 - PR merged

Se ve CUÁNDO empezó, CUÁNDO estuvo en desarrollo, CUÁNDO terminó
```

---

## 🛠️ ¿Por Qué Es Importante Actualizar Ref?

### Sin update-parent

```
Objetivo: Cambiar navbar en frontend

1. git checkout feature/issue-5
2. Entras a frontend/
3. Editas Navbar.tsx
4. git commit + git push en frontend
5. Vuelves a padre
6. git push (pero sin actualizar ref) ← ❌ PROBLEMA

Resultado:
- Frontend tiene nuevos commits
- Padre todavía apunta a SHA viejo
- Project: No ve cambios en el padre
- Cuando cierres Issue: No habrá trazabilidad de dónde vinieron los cambios
```

### Con update-parent

```
Objetivo: Cambiar navbar en frontend

1. git checkout feature/issue-5
2. Entras a frontend/
3. Editas Navbar.tsx
4. git commit + git push en frontend
5. Vuelves a padre
6. update-parent → commit en padre ← ✅ CORRECTO
7. git push

Resultado:
- Frontend tiene nuevos commits
- Padre apunta a SHA nuevo (commit actualiza ref)
- Project: Ve commit en padre ("chore: update frontend ref")
- Cuando cierres Issue: Hay trazabilidad clara del trabajo
```

---

## 📋 Desglose de Cada Paso

### Paso 1: Crear Issue (GitHub Web)

```
Página: https://github.com/RodrigoMijangos/recolecta_web/issues

✍️ Crear Issue:
   Título: "[Frontend] Update navbar style"
   Description:
     - Cambiar colores del navbar
     - Agregar notificaciones
   Etiquetas:
     - Area: Frontend
     - Fase: F2-Desarrollo
     - Tipo: Feature

Resultado: Issue #5 creado
```

### Paso 2: Crear Rama (Local)

```
PowerShell: C:\...\recolecta_web

$ .\workflow-submodules.ps1 -action init-branch -branch feature/issue-5 -issueNumber 5

Detrás de escenas:
  git fetch origin
  git checkout -b feature/issue-5 --track origin/main
  
Resultado:
  - Rama local: feature/issue-5 (basada en origin/main)
  - HEAD apunta a feature/issue-5
```

### Paso 3: Trabajar en Submódulo

```
PowerShell: C:\...\recolecta_web

$ .\workflow-submodules.ps1 -action work -submodule frontend

Resultado:
  - Cambio a directorio: C:\...\recolecta_web\frontend
  - Terminal lista para editar archivos

Ejemplo:
  $ cd C:\...\recolecta_web\frontend
  $ code src/components/Navigation/Navbar.tsx  # Editar
  $ git add src/components/Navigation/Navbar.tsx
  $ git commit -m "feat: update navbar colors"
  $ git push origin main
  $ cd ..  # Volver a padre
```

### Paso 4: Actualizar Ref

```
PowerShell: C:\...\recolecta_web

$ .\workflow-submodules.ps1 -action update-parent -submodule frontend -message "feat: update navbar colors"

Detrás de escenas:
  cd recolecta_web
  git add frontend
  git commit -m "chore: update frontend ref"
  git push origin feature/issue-5
  
Resultado:
  - Padre ahora apunta al nuevo SHA de frontend
  - Commit en padre linkea el cambio
  - PR future verá este commit
```

### Paso 5: Crear PR (GitHub Web)

```
Página: https://github.com/RodrigoMijangos/recolecta_web/pulls

✍️ Crear PR:
   Base: main
   Compare: feature/issue-5
   
   Título: "Closes #5: [Frontend] Update navbar style"
   Description:
     - Updated navbar colors
     - Added notification icon
     
     Refs: #5
   
   ✅ Crear PR

Resultado: PR #10 creado, linkea a Issue #5
```

### Paso 6: Mergear PR (GitHub Web)

```
En PR #10:
  ✅ Mergea (squash o merge commit según prefieras)
  
Automático (GitHub):
  - PR #10 → merged
  - Issue #5 → closed (porque tiene "Closes #5")
  - Timeline actualizada

Resultado: Issue #5 → Status: Done
```

---

## 🎬 Video Mental: Secuencia Completa

```
T=0:00  Creas Issue #5 en web
        Project: Issue #5 = Open

T=0:05  Ejecutas init-branch
        Local: Rama feature/issue-5 creada

T=0:10  Entras a frontend, editas Navbar.tsx, commiteas y pusheas
        Frontend/main: Nuevo commit

T=0:15  Ejecutas update-parent
        Padre: Nuevo commit, apunta a nuevo SHA

T=0:20  Creas PR en web (Closes #5)
        GitHub: PR #10 linked a Issue #5
        Project: Detecta PR linkead

T=0:30  Mergeas PR
        GitHub: Issue #5 Closed automáticamente
        Project: Issue #5 = Done

T=1:00  Ves en Project:
        - Issue #5 → Status: Done
        - PR #10 → Merged
        - Tiempo de inicio → Tiempo de cierre
        - Actividad durante desarrollo
```

---

## ✅ Checklist Final

Antes de considerar que terminaste:

- [ ] Issue en GitHub con etiquetas (Area, Fase, Tipo)
- [ ] Rama de trabajo creada (feature/issue-X)
- [ ] Cambios en submódulos commitados y pusheados
- [ ] update-parent ejecutado después de cada cambio
- [ ] PR creado con "Closes #X" en descripción
- [ ] PR merged
- [ ] Verificas en Project que Issue está "Done" y PR está "Merged"

Si todo ✅, tu trabajo tiene **trazabilidad completa** en el Project.

---

## 🚨 Troubleshooting

| Problema | Solución |
|----------|----------|
| No veo cambios en Project | Asegúrate de hacer `update-parent` después de `git push` en submódulo |
| PR no linkea Issue | Usa exactamente "Closes #X" en el description (case-sensitive) |
| Issue no se cierra al mergear | Ciérralo manualmente en web, o asegúrate PR tiene "Closes #X" |
| Submódulo tiene cambios pero no se ven | Ejecuta `update-parent` ahora; padre debe commitear la ref |
| ¿Dónde veo los cambios reales? | En el repo frontend/backend, no en el padre; el padre solo linkea |

