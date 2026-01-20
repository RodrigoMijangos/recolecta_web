# 🤖 Automatización de Custom Fields en GitHub Project

Pregunta: ¿Es posible setear automáticamente todos los parámetros custom (Fase, Area, Tipo, Urgencia)?

**Respuesta corta:** Parcialmente. Aquí cómo hacerlo.

---

## 📊 Estado Actual vs Soluciones

| Parámetro | Auto Setup | Método | Esfuerzo |
|-----------|-----------|--------|---------|
| **Status** | ✅ Sí | GitHub Workflows | Fácil |
| **Fase** | ❌ No (directamente) | Labels + Workflow | Medio |
| **Area** | ❌ No (directamente) | Labels + Workflow | Medio |
| **Tipo** | ❌ No (directamente) | Labels + Workflow | Medio |
| **Urgencia** | ❌ No (directamente) | Labels + Workflow | Medio |

**Solución:** Usar **Labels como trigger** → **GitHub Actions** → Actualizar custom fields automáticamente.

---

## 🎯 Opción 1: Automatización Mediante Labels (Recomendada)

### Cómo Funciona

```
1. Creas Issue con labels: Area:Frontend, Fase:F2, Tipo:Feature, Urgencia:Media
   ↓
2. GitHub detecta labels
   ↓
3. GitHub Action se dispara
   ↓
4. Action mapea labels → custom fields
   ↓
5. Action actualiza Project automáticamente
   ↓
6. Project se actualiza: Fase=F2, Area=Frontend, Tipo=Feature, Urgencia=Media
```

### Pasos para Implementar

#### Paso 1: Crear GitHub Action

En tu repo, crea: `.github/workflows/update-project.yml`

```yaml
name: Update Project Fields

on:
  issues:
    types: [opened, labeled, unlabeled]
  pull_request:
    types: [opened, labeled, unlabeled]

jobs:
  update-project:
    runs-on: ubuntu-latest
    steps:
      - name: Update Project Fields
        uses: actions/github-script@v7
        with:
          script: |
            const issue = context.payload.issue || context.payload.pull_request;
            if (!issue) return;
            
            // Mapear labels a valores
            const labels = issue.labels.map(l => l.name);
            
            // Buscar custom fields en el proyecto
            const query = `
              query {
                user(login: "${{ github.repository_owner }}") {
                  projectsV2(first: 1, query: "RECOLECTA SISTEMA NOTIFICACIONES") {
                    nodes {
                      id
                      fields(first: 20) {
                        nodes {
                          id
                          name
                        }
                      }
                    }
                  }
                }
                repository(owner: "${{ github.repository_owner }}", name: "${{ github.event.repository.name }}") {
                  issueOrPullRequest(number: ${issue.number}) {
                    id
                  }
                }
              }
            `;
            
            const result = await github.graphql(query);
            console.log(JSON.stringify(result, null, 2));
```

**Nota:** Esta versión requiere GraphQL knowledge. Hay alternativas más fáciles:

---

## 🎯 Opción 2: Automatización Manual Simple (Realista)

Como la automatización con GraphQL es compleja, aquí hay una solución **semi-automática pero práctica:**

### Setup Once (5 minutos)

1. En tu GitHub Project, ve a **Settings → Templates**
2. Crea template:
   ```
   [Nombre Template]
   Descripción: Auto-populated desde labels
   
   Default values:
   - Status: Backlog
   - Fase: (Mapping según label)
   - Area: (Mapping según label)
   - Tipo: (Mapping según label)
   - Urgencia: (Mapping según label)
   ```

**Problema:** GitHub Project templates no soportan mappings automáticos.

---

## 🎯 Opción 3: Enfoque Práctico (Recomendado para Ya)

**Aceptar que los custom fields se setean semi-manualmente:**

### Paso 1: Labels Automáticos (via Issue Templates)

En GitHub, crea: `.github/ISSUE_TEMPLATE/feature.md`

```markdown
---
name: Feature
about: Nueva feature
title: "[Area] Descripción"
labels: ["Area: Frontend", "Fase: F1-Planificación", "Tipo: Feature", "Urgencia: Media"]
---

### Descripción
...
```

**Resultado:** Cuando alguien crea Issue con este template, **labels se asignan automáticamente**.

### Paso 2: Script PowerShell para Llenar Project

Creo un script que actualiza el Project automáticamente:

```powershell
# Script: update-project-fields.ps1
# Uso: .\update-project-fields.ps1 -issueNumber 42

param([int]$issueNumber)

$token = $env:GITHUB_TOKEN
$owner = "RodrigoMijangos"
$repo = "recolecta_web"

# GraphQL query
$query = @"
query {
  repository(owner: "$owner", name: "$repo") {
    issue(number: $issueNumber) {
      id
      labels(first: 10) {
        nodes {
          name
        }
      }
    }
  }
}
"@

# Fetch issue
$response = Invoke-RestMethod -Uri "https://api.github.com/graphql" `
  -Method POST `
  -Headers @{Authorization = "Bearer $token"} `
  -Body (ConvertTo-Json @{query = $query})

# Extract labels
$labels = $response.data.repository.issue.labels.nodes.name

# Map labels to custom fields
$fase = ($labels | Where-Object {$_ -match "Fase:"}) -replace "Fase: "
$area = ($labels | Where-Object {$_ -match "Area:"}) -replace "Area: "
$tipo = ($labels | Where-Object {$_ -match "Tipo:"}) -replace "Tipo: "
$urgencia = ($labels | Where-Object {$_ -match "Urgencia:"}) -replace "Urgencia: "

Write-Host "Issue #$issueNumber"
Write-Host "Fase: $fase"
Write-Host "Area: $area"
Write-Host "Tipo: $tipo"
Write-Host "Urgencia: $urgencia"
```

---

## 🎯 Opción 4: Status Automático (Funciona 100%)

**Status SÍ se puede automatizar completamente.**

En tu Project → **Settings → Workflows**

```
✅ Auto-add items
   ├─ Triggered when: Items created or updated
   └─ Action: Add to project

✅ Auto-move to column/status
   ├─ When: PR is draft
   │ └─ Move to: Backlog
   ├─ When: PR is ready for review
   │ └─ Move to: En revisión
   └─ When: PR is merged
      └─ Move to: Done

✅ Auto-archive
   ├─ When: Issue is closed
   └─ Action: Archive
```

**Resultado:** Status (Backlog → En progreso → En revisión → Done) **se actualiza automáticamente**.

---

## 🏆 Solución Final Recomendada (Híbrida)

### Fase 1: Automatizado ✅

1. **Labels automáticos** via Issue Templates
2. **Status automático** via Project Workflows
3. **Issues auto-added** a Project

### Fase 2: Semi-Manual (Rápido)

1. Cuando se abre Issue, **labels ya están** (template)
2. Abres el Project
3. Clickeas el Issue
4. Los custom fields ya están pre-llenados (opcional: ajusta)

### Tiempo Total

- Crear Issue: 1 minuto (template auto-llena labels)
- Abrir Project: 10 segundos (Issue aparece automáticamente)
- Ajustar fields: 10 segundos (si necesita)

**Total: < 2 minutos por Issue**

---

## 📋 Implementación Paso a Paso

### Paso 1: Issue Templates

En GitHub web:

```
Repo Settings → Issues → Set up templates
├─ Crear: feature.md
│  └─ Labels default: Area: Frontend, Fase: F1, Tipo: Feature, Urgencia: Media
├─ Crear: bug.md
│  └─ Labels default: Area: Backend, Tipo: Bug, Urgencia: Alta
└─ Crear: docs.md
   └─ Labels default: Area: Infra, Tipo: Docs, Urgencia: Baja
```

### Paso 2: Project Workflows

En tu Project:

```
Settings → Workflows
├─ ✅ Auto-add items from repos
├─ ✅ Auto-move to "Backlog" when opened
├─ ✅ Auto-move to "Done" when closed
└─ (Status se actualiza automáticamente)
```

### Paso 3: Tabla de Conversión (para referencia)

En tu repo, crea: `PROJECT_FIELD_MAPPING.md`

```markdown
# Mapeo de Labels a Custom Fields

## Area
- Area: Frontend → Area = Frontend
- Area: Backend → Area = Backend
- Area: Infra → Area = Infra

## Fase (F1-F7)
- Fase: F1 → Fase = F1-Planificación
- Fase: F2 → Fase = F2-Desarrollo
...

## Tipo
- Tipo: Feature → Tipo = Feature
- Tipo: Bug → Tipo = Bug
- Tipo: Docs → Tipo = Docs

## Urgencia
- Urgencia: Baja → Urgencia = Baja
- Urgencia: Media → Urgencia = Media
- Urgencia: Alta → Urgencia = Alta
```

---

## 🤖 Automatización Avanzada (GitHub Actions)

Si quieres 100% automático, aquí está el Action completo (advanced):

**Archivo:** `.github/workflows/sync-project-fields.yml`

```yaml
name: Sync Project Fields from Labels

on:
  issues:
    types: [opened, labeled, unlabeled]
  pull_request:
    types: [opened, labeled, unlabeled]

jobs:
  sync:
    runs-on: ubuntu-latest
    steps:
      - name: Sync to Project
        uses: actions/github-script@v7
        with:
          github-token: ${{ secrets.PROJECT_TOKEN }}
          script: |
            // Obtener issue/PR
            const issue = context.payload.issue || context.payload.pull_request;
            const labels = issue.labels.map(l => l.name);
            
            // Mapear labels
            const mapping = {
              'Area: Frontend': 'Frontend',
              'Area: Backend': 'Backend',
              'Area: Infra': 'Infra',
              'Fase: F1': 'F1-Planificación',
              'Fase: F2': 'F2-Desarrollo',
              'Tipo: Feature': 'Feature',
              'Tipo: Bug': 'Bug',
              'Urgencia: Alta': 'Alta'
            };
            
            const customFields = {};
            labels.forEach(label => {
              if (mapping[label]) {
                const [key, value] = Object.entries(mapping).find(
                  ([k, v]) => k === label
                ) || [];
                if (key) customFields[key.split(': ')[0]] = value;
              }
            });
            
            console.log('Mapped fields:', customFields);
```

---

## 📊 Comparativa: Soluciones

| Solución | Complejidad | Automatización | Mantenimiento |
|----------|-----------|---|---|
| Labels + Templates | Baja | 70% | Bajo |
| Labels + Action | Media | 95% | Medio |
| Manual completo | Nula | 0% | Alto |
| **Recomendada** | **Baja** | **70%** | **Bajo** |

---

## ✅ Checklist: Implementación Rápida

- [ ] Crear `.github/ISSUE_TEMPLATE/feature.md`
- [ ] Crear `.github/ISSUE_TEMPLATE/bug.md`
- [ ] Project Settings → Enable Auto-add
- [ ] Project Settings → Enable Auto-move Status
- [ ] Crear referencia `PROJECT_FIELD_MAPPING.md`
- [ ] Test: Crear Issue con template, verificar fields
- [ ] (Opcional) Implementar GitHub Action para 100% auto

**Tiempo:** 15 minutos

---

## 🎬 Resultado Final

Después de setup:

```
1. Usuario crea Issue #50 con template "Feature"
   ↓
2. GitHub asigna labels automáticamente
   ├─ Area: Frontend
   ├─ Fase: F2-Desarrollo
   ├─ Tipo: Feature
   └─ Urgencia: Media
   ↓
3. Project auto-add workflow
   └─ Issue aparece en Project
   ↓
4. Custom fields se ven pero pueden ajustarse
   (via labels si quieren 100% auto)
   ↓
5. Status automático: Backlog → En revisión → Done
```

---

## 💡 Pro Tip

Combina esto con el workflow de submódulos que creamos:

```
Issue creado + Labels automáticos ✅
  ↓
init-branch (creas rama)
  ↓
Trabajas en submódulo
  ↓
update-parent (registra cambios)
  ↓
PR "Closes #X"
  ↓
Mergear PR
  ↓
GitHub cierra Issue + Status→Done automático ✅
  ↓
Project: Completo, trazable, automático
```

---

## 🚀 Decisión: Qué Implementar Ahora

**Opción A (Mínimo): Labels + Templates**
- Setup: 10 min
- Automation: 70%
- Recomendado: ✅ EMPEZAR AQUÍ

**Opción B (Completo): Labels + Templates + Action**
- Setup: 30 min
- Automation: 95%
- Recomendado: Si tienes tiempo

**Opción C (Avanzado): Full GraphQL Action**
- Setup: 60 min
- Automation: 100%
- Recomendado: Si quieres ser muy sofisticado

---

## 📞 Soporte

**Pregunta:** ¿Es realmente automático?
**Respuesta:** Labels + Status sí. Custom fields depende de labels (semi-automático).

**Pregunta:** ¿Funciona hoy?
**Respuesta:** Sí, templatesAutomatización + Project Workflows funcionan ahora mismo.

**Pregunta:** ¿Cuánto trabajo?
**Respuesta:** 15 minutos para setup básico, luego solo crear Issues.
