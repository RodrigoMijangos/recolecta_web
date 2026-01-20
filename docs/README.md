# 📚 Documentación: recolecta_web

Bienvenido a la documentación del proyecto. Aquí encontrarás todo lo que necesitas para trabajar con el sistema de notificaciones.

---

## 🚀 Empezar Rápido

### Si eres Nuevo (5 minutos)

1. Lee: [INDICE_MAESTRO.md](./INDICE_MAESTRO.md)
2. Lee: [workflow/WORKFLOW_QUICK_CHECKLIST.md](./workflow/WORKFLOW_QUICK_CHECKLIST.md)
3. Crea tu primer Issue en GitHub

### Si Necesitas Trabajar Ahora

1. Sigue: [workflow/WORKFLOW_QUICK_CHECKLIST.md](./workflow/WORKFLOW_QUICK_CHECKLIST.md)
2. Usa: `docs/workflow/workflow-submodules.ps1`
3. Consulta: [workflow/PROJECT_WORKFLOW_INTEGRATION.md](./workflow/PROJECT_WORKFLOW_INTEGRATION.md)

---

## 📂 Estructura de Carpetas

```
docs/
├── README.md ............................ Este archivo
├── CHANGELOG.md ......................... Historial de versiones
├── INDICE_MAESTRO.md ................... Mapa de navegación principal
│
├── workflow/ ............................ Sistema de trabajo automatizado
│   ├── WORKFLOW_QUICK_CHECKLIST.md ..... Referencia rápida ⭐ EMPEZAR AQUÍ
│   ├── WORKFLOW_SUBMÓDULOS.md ......... Guía detallada
│   ├── TRAZABILIDAD_EXPLICADO.md ..... Conceptos + diagramas
│   ├── PROJECT_WORKFLOW_INTEGRATION.md  Integración con GitHub Project
│   ├── PLANTILLA_PR.md ............... 4 templates de Pull Requests
│   └── workflow-submodules.ps1 ....... Script PowerShell (automatización)
│
├── project/ ............................ Configuración del GitHub Project
│   ├── AUTOMATIZACION_PROJECT_FIELDS.md  Auto-setup custom fields
│   ├── PROJECT_SETUP.md .............. Setup inicial
│   ├── ROADMAP_SETUP.md ............ Roadmap setup
│   └── PLANTILLAS_ISSUES.md ....... Templates para issues
│
└── setup/ ............................. Setup y configuración
    ├── SETUP_COMPLETADO.md ......... Resumen ejecutivo
    └── SISTEMA_COMPLETADO.md ... Estado final del sistema
```

---

## 🎯 Por Dónde Empezar Según Tu Necesidad

### "Quiero empezar a trabajar ahora"
→ [workflow/WORKFLOW_QUICK_CHECKLIST.md](./workflow/WORKFLOW_QUICK_CHECKLIST.md) (5 min)

### "Quiero entender cómo funciona todo"
→ [INDICE_MAESTRO.md](./INDICE_MAESTRO.md) (10 min)

### "Quiero aprender los conceptos"
→ [workflow/TRAZABILIDAD_EXPLICADO.md](./workflow/TRAZABILIDAD_EXPLICADO.md) (15 min)

### "Quiero usar el GitHub Project efectivamente"
→ [workflow/PROJECT_WORKFLOW_INTEGRATION.md](./workflow/PROJECT_WORKFLOW_INTEGRATION.md) (20 min)

### "Quiero escribir buenos Pull Requests"
→ [workflow/PLANTILLA_PR.md](./workflow/PLANTILLA_PR.md) (5 min)

### "Quiero automatizar los custom fields"
→ [project/AUTOMATIZACION_PROJECT_FIELDS.md](./project/AUTOMATIZACION_PROJECT_FIELDS.md) (15 min)

### "Necesito resumen ejecutivo"
→ [setup/SETUP_COMPLETADO.md](./setup/SETUP_COMPLETADO.md) (10 min)

---

## 🛠️ Herramientas Disponibles

### Alias rápido: `wflow.ps1`

Wrapper en la raíz para no recordar rutas. Pasa los argumentos al script completo.

**Uso (raíz):**
```powershell
./wflow.ps1 -action status
./wflow.ps1 -action init-branch -branch feature/issue-42 -issueNumber 42
./wflow.ps1 -action work -submodule frontend
```

### workflow-submodules.ps1

Script PowerShell que automatiza todo el flujo de trabajo.

**Ubicación:** `docs/workflow/workflow-submodules.ps1` (llamado por `wflow.ps1`)

**Uso directo (si lo prefieres):**
```powershell
.\docs\workflow\workflow-submodules.ps1 -action <action> [opciones]
```

**Acciones disponibles:**
- `init-branch` - Crear rama de trabajo
- `work` - Entrar a submódulo
- `commit-submodule` - Pushear cambios
- `update-parent` - Actualizar referencias
- `sync-all` - Sincronizar submódulos
- `status` - Ver estado

---

## 📋 Flujo de Trabajo Estándar

```
1. Crear Issue en GitHub ✅
   └─ Etiquetas: Area, Fase, Tipo, Urgencia

2. init-branch ✅
   └─ .\workflow-submodules.ps1 -action init-branch -branch feature/issue-X

3. work en submódulo ✅
   └─ .\workflow-submodules.ps1 -action work -submodule frontend

4. Hacer cambios ✅
   └─ git add/commit/push

5. update-parent ✅
   └─ .\workflow-submodules.ps1 -action update-parent -submodule frontend

6. Crear PR en GitHub ✅
   └─ Título: "Closes #X: [Area] Descripción"
   └─ Usar plantilla: workflow/PLANTILLA_PR.md

7. Mergear PR ✅
   └─ GitHub cierra Issue automáticamente

8. Project actualiza ✅
   └─ Issue → Done, PR → Merged
```

---

## 🎓 Conceptos Principales

| Concepto | Qué Es | Dónde |
|----------|--------|-------|
| **Issue** | Descripción del trabajo | GitHub (recolecta_web) |
| **Rama** | Espacio aislado de trabajo | Local + GitHub |
| **Submódulo** | Frontend/Backend dentro del repo padre | GitHub |
| **Ref** | Puntero del padre al commit del submódulo | recolecta_web |
| **Update Ref** | Actualizar puntero (crucial) | via script |
| **PR** | Pull Request para mergear | GitHub |
| **Project** | Tablero centralizador | GitHub Project |
| **Trazabilidad** | Ver timeline completo | GitHub Project |

---

## ✅ Checklist: Verificar Setup

Antes de empezar, verifica:

- [ ] Entiendes qué es una "referencia" de submódulo
- [ ] Sabes por qué `update-parent` es importante
- [ ] Entiendes el patrón "Closes #X" en PRs
- [ ] Sabes que el Project es el tablero central
- [ ] Has leído al menos una guía

---

## 🚀 Comandos Más Usados

```powershell
# Ver estado
.\docs\workflow\workflow-submodules.ps1 -action status

# Iniciar feature
.\docs\workflow\workflow-submodules.ps1 -action init-branch -branch feature/issue-X -issueNumber X

# Trabajar
.\docs\workflow\workflow-submodules.ps1 -action work -submodule frontend

# Actualizar ref
.\docs\workflow\workflow-submodules.ps1 -action update-parent -submodule frontend

# Sincronizar todo
.\docs\workflow\workflow-submodules.ps1 -action sync-all
```

---

## 📊 Estadísticas

- 📚 **Documentos:** 12 archivos
- 🎬 **Guías:** 7 guías detalladas
- 🛠️ **Scripts:** 1 automatización PowerShell
- 🤖 **Autom.:** Status + Labels + Templates
- ⏱️ **Setup:** 15 minutos
- 📈 **Por feature:** 25-40 minutos

---

## 🧭 Qué es tuyo (documentación) vs. qué es del repo (código)

**Tu documentación (puedes adaptarla a tu gusto, es “contenido del proyecto”):**
- Todo lo que está en `docs/` (guías, índices, changelog, plantillas).
- Alias `wflow.ps1` (comodidad; opcional, pero útil tenerlo versionado).

**Lo que debe quedarse porque el código lo necesita:**
- Submódulos `frontend/`, `backend/`, `gin-backend/` y sus referencias (commits) en el repo padre.
- Configuración existente para builds, dependencias y scripts que el runtime requiera.
- El script base `docs/workflow/workflow-submodules.ps1` (la automatización depende de él).

**Regla práctica:**
- Si es guía, checklist, plantilla o alias: es tuyo y vive en `docs/` (o raíz para el alias).
- Si es código fuente, config de build o script operativo: debe permanecer en el repo para que todo compile/ejecute.

---

## 🔄 Versiones

**Versión Actual:** 1.0.0  
**Fecha:** 20 de enero de 2026  
**Status:** ✅ Estable

Ver [CHANGELOG.md](./CHANGELOG.md) para historial completo.

---

## 💡 Pro Tips

1. **Copia el script a raíz para acceso fácil**
   ```powershell
   cp docs\workflow\workflow-submodules.ps1 .
   ```

2. **Siempre `update-parent` después de pushear submódulo**
   - Sin esto: trabajo invisible

3. **Etiqueta Issues inmediatamente**
   - Usa los templates de issue

4. **Usa "Closes #X" en PRs**
   - GitHub cierra Issue automáticamente

5. **Sincroniza antes de rama nueva**
   - `sync-all` asegura que estés actualizado

---

## 📞 Soporte

- **Pregunta rápida:** Consulta [INDICE_MAESTRO.md](./INDICE_MAESTRO.md)
- **No funciona algo:** Lee [workflow/WORKFLOW_SUBMÓDULOS.md](./workflow/WORKFLOW_SUBMÓDULOS.md) → FAQ
- **Conceptos:** [workflow/TRAZABILIDAD_EXPLICADO.md](./workflow/TRAZABILIDAD_EXPLICADO.md)

---

## 🎉 ¡Listo!

Bienvenido al sistema de workflow de recolecta_web. 

**Próximo paso:** Lee [INDICE_MAESTRO.md](./INDICE_MAESTRO.md)

¡A trabajar! 🚀
