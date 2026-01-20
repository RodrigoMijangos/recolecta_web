# 📚 Índice Maestro: Sistema Completo de Workflow

Guía de navegación para todo el sistema de workflow y trazabilidad del proyecto.

---

## 🗂️ Estructura de Documentación

```
recolecta_web/
│
├── 📄 docs/README.md ............................ EMPEZAR AQUÍ
│
├── docs/ (Documentación completa)
│   ├── INDICE_MAESTRO.md ..................... Este archivo
│   ├── CHANGELOG.md ......................... Historial de versiones
│   │
│   ├── workflow/ (Sistema de trabajo)
│   │   ├── ⚡ WORKFLOW_QUICK_CHECKLIST.md .. Referencia rápida ⭐ EMPEZAR
│   │   ├── 📖 WORKFLOW_SUBMÓDULOS.md ..... Guía completa detallada
│   │   ├── 🎓 TRAZABILIDAD_EXPLICADO.md . Conceptos + diagramas
│   │   ├── 🔗 PROJECT_WORKFLOW_INTEGRATION.md  Integración Project
│   │   ├── 📋 PLANTILLA_PR.md ............ Plantillas Pull Request
│   │   └── 🛠️ workflow-submodules.ps1 ... Script PowerShell
│   │
│   ├── project/ (Configuración Project)
│   │   ├── 🤖 AUTOMATIZACION_PROJECT_FIELDS.md  Auto-setup fields
│   │   ├── 📋 PROJECT_SETUP.md ......... Setup inicial
│   │   ├── 🏗️ ROADMAP_SETUP.md ....... Roadmap setup
│   │   └── 🎫 PLANTILLAS_ISSUES.md .. Templates issues
│   │
│   └── setup/ (Setup y configuración)
│       ├── 🚀 SETUP_COMPLETADO.md ... Resumen ejecutivo
│       └── ✅ SISTEMA_COMPLETADO.md  Estado final
│
├── frontend/ ............................ Submódulo
├── backend/ ............................ Submódulo
└── gin-backend/ ...................... Submódulo
```

---

## 🎯 Dónde Empezar Según Tu Rol

### Si eres **Nuevo en el Proyecto**
1. Lee [README.md](./README.md) (5 min) ⭐ AQUÍ
2. Lee [workflow/WORKFLOW_QUICK_CHECKLIST.md](./workflow/WORKFLOW_QUICK_CHECKLIST.md) (5 min)
3. Ejecuta `.\docs\workflow\workflow-submodules.ps1 -action status` para ver estado
4. Crea un Issue de prueba y sigue el flujo

### Si quieres **Entender Conceptos**
1. Lee [workflow/TRAZABILIDAD_EXPLICADO.md](./workflow/TRAZABILIDAD_EXPLICADO.md) (15 min)
2. Ve los diagramas ASCII
3. Lee la sección "Qué ve el Project en cada momento"

### Si quieres **Trabajar en una Feature**
1. Abre [workflow/WORKFLOW_QUICK_CHECKLIST.md](./workflow/WORKFLOW_QUICK_CHECKLIST.md)
2. Sigue paso a paso
3. Si algo no funciona, consulta [workflow/WORKFLOW_SUBMÓDULOS.md](./workflow/WORKFLOW_SUBMÓDULOS.md) FAQ

### Si quieres **Integrar con el Project**
1. Lee [workflow/PROJECT_WORKFLOW_INTEGRATION.md](./workflow/PROJECT_WORKFLOW_INTEGRATION.md) (20 min)
2. Configura Project settings (si no está hecho)
3. Verifica checklist de configuración

### Si tienes **Problemas**
1. Ejecuta `.\docs\workflow\workflow-submodules.ps1 -action status`
2. Consulta [workflow/WORKFLOW_SUBMÓDULOS.md](./workflow/WORKFLOW_SUBMÓDULOS.md) → FAQ → Troubleshooting
3. O [workflow/TRAZABILIDAD_EXPLICADO.md](./workflow/TRAZABILIDAD_EXPLICADO.md) → Troubleshooting

---

## 📋 Documentación Rápida por Tema

### Tema: Iniciar Trabajo Nueva Feature

**Archivos:**
- [workflow/WORKFLOW_QUICK_CHECKLIST.md](./workflow/WORKFLOW_QUICK_CHECKLIST.md) → Sección "Antes de Empezar"
- [workflow/WORKFLOW_SUBMÓDULOS.md](./workflow/WORKFLOW_SUBMÓDULOS.md) → Fase 1: Preparación

**Comando:**
```powershell
.\docs\workflow\workflow-submodules.ps1 -action init-branch -branch feature/issue-X -issueNumber X
```

---

### Tema: Hacer Cambios en Submódulo

**Archivos:**
- [workflow/WORKFLOW_QUICK_CHECKLIST.md](./workflow/WORKFLOW_QUICK_CHECKLIST.md) → Sección "Mientras Desarrollas"
- [workflow/WORKFLOW_SUBMÓDULOS.md](./workflow/WORKFLOW_SUBMÓDULOS.md) → Fase 2: Desarrollo

**Comandos:**
```powershell
# Entrar a submódulo
.\docs\workflow\workflow-submodules.ps1 -action work -submodule frontend

# Dentro del submódulo (frontend/)
git add .
git commit -m "feat: descripción"
git push origin main
cd ..

# Actualizar ref en padre
.\docs\workflow\workflow-submodules.ps1 -action update-parent -submodule frontend
```

---

### Tema: Entender Trazabilidad

**Archivos:**
- [workflow/TRAZABILIDAD_EXPLICADO.md](./workflow/TRAZABILIDAD_EXPLICADO.md) → Sección "¿Por Qué Es Importante Actualizar Ref"
- [workflow/PROJECT_WORKFLOW_INTEGRATION.md](./workflow/PROJECT_WORKFLOW_INTEGRATION.md) → Sección "Paso 4: Registrar Cambio"

**Concepto clave:**
```
Sin update-parent: Trabajo invisible para el Project ❌
Con update-parent: Trazabilidad completa ✅
```

---

### Tema: Crear y Mergear PR

**Archivos:**
- [workflow/WORKFLOW_QUICK_CHECKLIST.md](./workflow/WORKFLOW_QUICK_CHECKLIST.md) → Sección "Terminar Feature"
- [workflow/PROJECT_WORKFLOW_INTEGRATION.md](./workflow/PROJECT_WORKFLOW_INTEGRATION.md) → Paso 5 y 6

**Patrón:**
```
PR Title: "Closes #X: [Area] Descripción"
↓
GitHub cierra Issue automáticamente ✅
↓
Project ve: Issue → Done, PR → Merged
```

---

### Tema: Sincronizar Submódulos

**Archivos:**
- [workflow/WORKFLOW_SUBMÓDULOS.md](./workflow/WORKFLOW_SUBMÓDULOS.md) → `sync-all` comando

**Comando:**
```powershell
.\docs\workflow\workflow-submodules.ps1 -action sync-all
```

**Cuándo usar:** Antes de empezar rama nueva, para asegurar que todos estén en main actualizado.

---

### Tema: Configurar GitHub Project

**Archivos:**
- [workflow/PROJECT_WORKFLOW_INTEGRATION.md](./workflow/PROJECT_WORKFLOW_INTEGRATION.md) → Sección "Configuración de Project"
- [project/PROJECT_SETUP.md](./project/PROJECT_SETUP.md)

**Pasos:**
1. Project Settings → Workflows
2. Habilitar "Auto-add items"
3. Verificar custom fields (Fase, Area, Tipo, Urgencia)

---

## 🔍 Búsqueda Rápida por Palabra Clave

| Keyword | Archivo | Sección |
|---------|---------|---------|
| `init-branch` | workflow/WORKFLOW_QUICK_CHECKLIST.md | Comandos Rápidos |
| `update-parent` | workflow/WORKFLOW_SUBMÓDULOS.md | Fase 3: Actualizar Trazabilidad |
| `workflow-submodules.ps1` | workflow/WORKFLOW_SUBMÓDULOS.md | Comandos Disponibles |
| `Closes #X` | workflow/PROJECT_WORKFLOW_INTEGRATION.md | Paso 5: Crear PR |
| `PR Templates` | workflow/PLANTILLA_PR.md | Todo |
| `Custom fields auto` | project/AUTOMATIZACION_PROJECT_FIELDS.md | Todo |
| `Custom fields` | workflow/PROJECT_WORKFLOW_INTEGRATION.md | Configuración de Project |
| `Fase F1-F7` | workflow/TRAZABILIDAD_EXPLICADO.md | Conceptos |
| `Submódulo` | workflow/TRAZABILIDAD_EXPLICADO.md | ¿Por Qué Es Importante |
| `Trazabilidad` | workflow/TRAZABILIDAD_EXPLICADO.md | Todo |
| `Ejemplo Rápido` | workflow/WORKFLOW_QUICK_CHECKLIST.md | Ejemplo Rápido |
| `FAQ` | workflow/WORKFLOW_SUBMÓDULOS.md | FAQ |
| `Troubleshooting` | workflow/WORKFLOW_SUBMÓDULOS.md | FAQ |
| `CHANGELOG` | CHANGELOG.md | Historial |

---

## 📂 Archivos por Propósito

### Sé cómo **ejecutar** el workflow
- [workflow/WORKFLOW_QUICK_CHECKLIST.md](./workflow/WORKFLOW_QUICK_CHECKLIST.md)
- [workflow/workflow-submodules.ps1](./workflow/workflow-submodules.ps1)

### Aprende a **escribir** buenos PRs
- [workflow/PLANTILLA_PR.md](./workflow/PLANTILLA_PR.md)

### Automatiza los **custom fields** del Project
- [project/AUTOMATIZACION_PROJECT_FIELDS.md](./project/AUTOMATIZACION_PROJECT_FIELDS.md)

### Entienda **por qué** funciona
- [workflow/TRAZABILIDAD_EXPLICADO.md](./workflow/TRAZABILIDAD_EXPLICADO.md)

### Quiero **toda la información**
- [workflow/WORKFLOW_SUBMÓDULOS.md](./workflow/WORKFLOW_SUBMÓDULOS.md)

### Necesito **integrar con Project**
- [workflow/PROJECT_WORKFLOW_INTEGRATION.md](./workflow/PROJECT_WORKFLOW_INTEGRATION.md)

### Busco **resumen ejecutivo**
- [setup/SETUP_COMPLETADO.md](./setup/SETUP_COMPLETADO.md)

---

## 🚀 Flujo Estándar (Resumen)

```
1. Crear Issue en GitHub
   └─ Archivo: workflow/PROJECT_WORKFLOW_INTEGRATION.md → Paso 1

2. init-branch
   └─ Comando: .\docs\workflow\workflow-submodules.ps1 -action init-branch
   └─ Archivo: workflow/WORKFLOW_QUICK_CHECKLIST.md

3. Trabajar en submódulo
   └─ work -submodule frontend
   └─ Archivo: workflow/WORKFLOW_QUICK_CHECKLIST.md → "Mientras Desarrollas"

4. Update ref
   └─ Comando: .\docs\workflow\workflow-submodules.ps1 -action update-parent
   └─ Archivo: workflow/WORKFLOW_SUBMÓDULOS.md → "Fase 3"

5. Crear PR en GitHub
   └─ GitHub web
   └─ Archivo: workflow/PROJECT_WORKFLOW_INTEGRATION.md → Paso 5

6. Mergear PR
   └─ GitHub web
   └─ Archivo: workflow/PROJECT_WORKFLOW_INTEGRATION.md → Paso 6

7. Project ve: Issue → Done ✅
   └─ Archivo: workflow/PROJECT_WORKFLOW_INTEGRATION.md → "Vista Final"
```

---

## 📞 Soporte Rápido

**Pregunta:** ¿Qué hago después de pushear cambios en frontend?

**Respuesta:** Ejecuta `update-parent`:
```powershell
.\docs\workflow\workflow-submodules.ps1 -action update-parent -submodule frontend
```

**Referencia:** [workflow/WORKFLOW_QUICK_CHECKLIST.md](./workflow/WORKFLOW_QUICK_CHECKLIST.md)

---

**Pregunta:** ¿Por qué el Project no ve mis cambios?

**Respuesta:** Probablemente olvidaste `update-parent`. El submódulo tiene cambios pero el padre no.

**Referencia:** [workflow/TRAZABILIDAD_EXPLICADO.md](./workflow/TRAZABILIDAD_EXPLICADO.md) → "Sin update-parent (❌ PROBLEMA)"

---

**Pregunta:** ¿GitHub cierra automáticamente el Issue?

**Respuesta:** Sí, si usas "Closes #X" en el PR y mergeas.

**Referencia:** [workflow/PROJECT_WORKFLOW_INTEGRATION.md](./workflow/PROJECT_WORKFLOW_INTEGRATION.md) → "Paso 5: Crear PR"

---

## 🗺️ Mapa Visual

```
┌──────────────────────────────────┐
│  EMPEZAR: docs/README.md         │
└──────────────┬──────────────────┘
               │
        ┌──────┴──────┐
        │             │
    RÁPIDO        PROFUNDO
        │             │
        │             │
   QUICK      WORKFLOW_
 CHECKLIST   SUBMÓDULOS
        │             │
        │      ┌──────┴──────┬────────┐
        │      │             │        │
        └─────→│  TRABAJO    │ CONCEPTOS
               │             │        │
        INTEGRATION           │        │
               ├─────────────┘        │
               │                      │
               ↓                      ↓
         [GitHub Web]        TRAZABILIDAD_
                            EXPLICADO.md
```

---

## ✅ Checklist: Estás Listo Cuando...

- [ ] Entiendes el flujo: Issue → Rama → Cambios → Update Ref → PR → Merge
- [ ] Sabes usar: `init-branch`, `work`, `update-parent`
- [ ] Entiendes por qué es importante `update-parent`
- [ ] Sabes que "Closes #X" cierra Issues automáticamente
- [ ] Entiendes que el Project es el tablero central
- [ ] Has leído [README.md](./README.md)

¡Listo para empezar! 🚀

---

**Versión:** 1.0.0  
**Última actualización:** 20 de enero de 2026  
**Status:** ✅ Estable
