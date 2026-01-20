# 📚 Índice Maestro: Sistema Completo de Workflow

Guía de navegación para todo el sistema de workflow y trazabilidad del proyecto.

---

## 🗂️ Estructura de Documentación

```
recolecta_web/
│
├── 📄 README.md (INICIA AQUÍ si es nuevo proyecto)
│
├── WORKFLOW (Sistema de trabajo automatizado)
│   ├── 🚀 SETUP_COMPLETADO.md ..................... Resumen ejecutivo
│   ├── ⚡ WORKFLOW_QUICK_CHECKLIST.md ............ Referencia rápida (5 min)
│   ├── 📖 WORKFLOW_SUBMÓDULOS.md ................ Guía completa detallada
│   ├── 🎓 TRAZABILIDAD_EXPLICADO.md ............ Conceptos + diagramas
│   ├── 🔗 PROJECT_WORKFLOW_INTEGRATION.md ...... Integración con GitHub Project
│   ├── 📋 PLANTILLA_PR.md ....................... Plantillas Pull Request
│   ├── 🤖 AUTOMATIZACION_PROJECT_FIELDS.md .... Auto-setup custom fields
│   └── 🛠️ workflow-submodules.ps1 .............. Script PowerShell (automatización)
│
├── PROJECT (Configuración del GitHub Project)
│   ├── 📋 ROADMAP_SETUP.md ....................... Creación del roadmap
│   ├── 🏗️ PROJECT_SETUP.md ....................... Estructura del proyecto
│   └── 🎫 PLANTILLAS_ISSUES.md .................. Plantillas para issues
│
└── OTROS
    ├── 📝 roadmap.md ............................ Roadmap de notificaciones
    └── 📞 TRANSFER_ISSUES.md ................... (Desactualizado - usar workflow)
```

---

## 🎯 Dónde Empezar Según Tu Rol

### Si eres **Nuevo en el Proyecto**
1. Lee [SETUP_COMPLETADO.md](./SETUP_COMPLETADO.md) (10 min)
2. Lee [WORKFLOW_QUICK_CHECKLIST.md](./WORKFLOW_QUICK_CHECKLIST.md) (5 min)
3. Ejecuta `.\workflow-submodules.ps1 -action status` para ver estado
4. Crea un Issue de prueba y sigue el flujo

### Si quieres **Entender Conceptos**
1. Lee [TRAZABILIDAD_EXPLICADO.md](./TRAZABILIDAD_EXPLICADO.md) (15 min)
2. Ve los diagramas ASCII
3. Lee la sección "Qué ve el Project en cada momento"

### Si quieres **Trabajar en una Feature**
1. Abre [WORKFLOW_QUICK_CHECKLIST.md](./WORKFLOW_QUICK_CHECKLIST.md)
2. Sigue paso a paso
3. Si algo no funciona, consulta [WORKFLOW_SUBMÓDULOS.md](./WORKFLOW_SUBMÓDULOS.md) FAQ

### Si quieres **Integrar con el Project**
1. Lee [PROJECT_WORKFLOW_INTEGRATION.md](./PROJECT_WORKFLOW_INTEGRATION.md) (20 min)
2. Configura Project settings (si no está hecho)
3. Verifica checklist de configuración

### Si tienes **Problemas**
1. Ejecuta `.\workflow-submodules.ps1 -action status`
2. Consulta [WORKFLOW_SUBMÓDULOS.md](./WORKFLOW_SUBMÓDULOS.md) → FAQ → Troubleshooting
3. O [TRAZABILIDAD_EXPLICADO.md](./TRAZABILIDAD_EXPLICADO.md) → Troubleshooting

---

## 📋 Documentación Rápida por Tema

### Tema: Iniciar Trabajo Nueva Feature

**Archivos:**
- [WORKFLOW_QUICK_CHECKLIST.md](./WORKFLOW_QUICK_CHECKLIST.md) → Sección "Antes de Empezar"
- [WORKFLOW_SUBMÓDULOS.md](./WORKFLOW_SUBMÓDULOS.md) → Fase 1: Preparación

**Comando:**
```powershell
.\workflow-submodules.ps1 -action init-branch -branch feature/issue-X -issueNumber X
```

---

### Tema: Hacer Cambios en Submódulo

**Archivos:**
- [WORKFLOW_QUICK_CHECKLIST.md](./WORKFLOW_QUICK_CHECKLIST.md) → Sección "Mientras Desarrollas"
- [WORKFLOW_SUBMÓDULOS.md](./WORKFLOW_SUBMÓDULOS.md) → Fase 2: Desarrollo

**Comandos:**
```powershell
# Entrar a submódulo
.\workflow-submodules.ps1 -action work -submodule frontend

# Dentro del submódulo (frontend/)
git add .
git commit -m "feat: descripción"
git push origin main
cd ..

# Actualizar ref en padre
.\workflow-submodules.ps1 -action update-parent -submodule frontend
```

---

### Tema: Entender Trazabilidad

**Archivos:**
- [TRAZABILIDAD_EXPLICADO.md](./TRAZABILIDAD_EXPLICADO.md) → Sección "¿Por Qué Es Importante Actualizar Ref"
- [PROJECT_WORKFLOW_INTEGRATION.md](./PROJECT_WORKFLOW_INTEGRATION.md) → Sección "Paso 4: Registrar Cambio"

**Concepto clave:**
```
Sin update-parent: Trabajo invisible para el Project ❌
Con update-parent: Trazabilidad completa ✅
```

---

### Tema: Crear y Mergear PR

**Archivos:**
- [WORKFLOW_QUICK_CHECKLIST.md](./WORKFLOW_QUICK_CHECKLIST.md) → Sección "Terminar Feature"
- [PROJECT_WORKFLOW_INTEGRATION.md](./PROJECT_WORKFLOW_INTEGRATION.md) → Paso 5 y 6

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
- [WORKFLOW_SUBMÓDULOS.md](./WORKFLOW_SUBMÓDULOS.md) → `sync-all` comando

**Comando:**
```powershell
.\workflow-submodules.ps1 -action sync-all
```

**Cuándo usar:** Antes de empezar rama nueva, para asegurar que todos estén en main actualizado.

---

### Tema: Configurar GitHub Project

**Archivos:**
- [PROJECT_WORKFLOW_INTEGRATION.md](./PROJECT_WORKFLOW_INTEGRATION.md) → Sección "Configuración de Project"
- [PROJECT_SETUP.md](./PROJECT_SETUP.md) (si existe)

**Pasos:**
1. Project Settings → Workflows
2. Habilitar "Auto-add items"
3. Verificar custom fields (Fase, Area, Tipo, Urgencia)

---

## 🔍 Búsqueda Rápida por Palabra Clave

| Keyword | Archivo | Sección |
|---------|---------|---------|
| `init-branch` | WORKFLOW_QUICK_CHECKLIST.md | Comandos Rápidos |
| `update-parent` | WORKFLOW_SUBMÓDULOS.md | Fase 3: Actualizar Trazabilidad |
| `workflow-submodules.ps1` | WORKFLOW_SUBMÓDULOS.md | Comandos Disponibles |
| `Closes #X` | PROJECT_WORKFLOW_INTEGRATION.md | Paso 5: Crear PR |
| `PR Templates` | PLANTILLA_PR.md | Todo |
| `Custom fields auto` | AUTOMATIZACION_PROJECT_FIELDS.md | Todo |
| `Custom fields` | PROJECT_WORKFLOW_INTEGRATION.md | Configuración de Project |
| `Fase F1-F7` | TRAZABILIDAD_EXPLICADO.md | Conceptos |
| `Submódulo` | TRAZABILIDAD_EXPLICADO.md | ¿Por Qué Es Importante |
| `Trazabilidad` | TRAZABILIDAD_EXPLICADO.md | Todo |
| `Ejemplo Rápido` | WORKFLOW_QUICK_CHECKLIST.md | Ejemplo Rápido |
| `FAQ` | WORKFLOW_SUBMÓDULOS.md | FAQ |
| `Troubleshooting` | WORKFLOW_SUBMÓDULOS.md | FAQ |

---

## 📊 Comparativa: Con/Sin Workflow

### Sin Workflow (Antes)

```
Cambios desincronizados
Submódulos sin trazabilidad
Issues flotando
Project sin visibilidad
Trabajo invisible
❌ Caos
```

### Con Workflow (Ahora)

```
Submódulos sincronizados ✅
Trazabilidad completa ✅
Issues linkados a PRs ✅
Project ve todo ✅
Trabajo temporal visible ✅
✅ Orden
```

---

## 🎓 Conceptos Clave

| Concepto | Definición | Referencia |
|----------|-----------|-----------|
| **Issue** | Descripción del trabajo a hacer | TRAZABILIDAD_EXPLICADO.md |
| **Rama** | Espacio aislado para trabajar | TRAZABILIDAD_EXPLICADO.md |
| **Submódulo** | Repo dentro de repo (frontend/backend) | WORKFLOW_SUBMÓDULOS.md |
| **Ref** | Puntero del padre al commit del submódulo | TRAZABILIDAD_EXPLICADO.md |
| **Update Ref** | Actualizar puntero en padre (clave) | WORKFLOW_SUBMÓDULOS.md |
| **PR** | Pull Request para mergear rama a main | PROJECT_WORKFLOW_INTEGRATION.md |
| **Project** | Tablero que organiza Issues + PRs | PROJECT_WORKFLOW_INTEGRATION.md |
| **Trazabilidad** | Poder ver cuándo/dónde/por qué | TRAZABILIDAD_EXPLICADO.md |

---

## 🚀 Flujo Estándar (Resumen)

```
1. Crear Issue en GitHub
   └─ Archivo: PROJECT_WORKFLOW_INTEGRATION.md → Paso 1

2. init-branch
   └─ Comando: .\workflow-submodules.ps1 -action init-branch
   └─ Archivo: WORKFLOW_QUICK_CHECKLIST.md

3. Trabajar en submódulo
   └─ work -submodule frontend
   └─ Archivo: WORKFLOW_QUICK_CHECKLIST.md → "Mientras Desarrollas"

4. Update ref
   └─ Comando: .\workflow-submodules.ps1 -action update-parent
   └─ Archivo: WORKFLOW_SUBMÓDULOS.md → "Fase 3"

5. Crear PR "Closes #X"
   └─ GitHub web
   └─ Archivo: PROJECT_WORKFLOW_INTEGRATION.md → Paso 5

6. Mergear PR
   └─ GitHub web
   └─ Archivo: PROJECT_WORKFLOW_INTEGRATION.md → Paso 6

7. Project ve: Issue → Done ✅
   └─ Archivo: PROJECT_WORKFLOW_INTEGRATION.md → "Vista Final"
```

---

## 📞 Soporte Rápido

**Pregunta:** ¿Qué hago después de pushear cambios en frontend?

**Respuesta:** Ejecuta `update-parent`:
```powershell
.\workflow-submodules.ps1 -action update-parent -submodule frontend
```

**Referencia:** [WORKFLOW_QUICK_CHECKLIST.md](./WORKFLOW_QUICK_CHECKLIST.md)

---

**Pregunta:** ¿Por qué el Project no ve mis cambios?

**Respuesta:** Probablemente olvidaste `update-parent`. El submódulo tiene cambios pero el padre no.

**Referencia:** [TRAZABILIDAD_EXPLICADO.md](./TRAZABILIDAD_EXPLICADO.md) → "Sin update-parent (❌ PROBLEMA)"

---

**Pregunta:** ¿GitHub cierra automáticamente el Issue?

**Respuesta:** Sí, si usas "Closes #X" en el PR y mergeas.

**Referencia:** [PROJECT_WORKFLOW_INTEGRATION.md](./PROJECT_WORKFLOW_INTEGRATION.md) → "Paso 5: Crear PR"

---

## 🗺️ Mapa Visual

```
┌─────────────────────────────────────────────────┐
│   EMPEZAR AQUÍ: SETUP_COMPLETADO.md             │
└──────────────┬──────────────────────────────────┘
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

¡Listo para empezar! 🚀

---

## 📂 Archivos por Propósito

### Sé cómo **ejecutar** el workflow
- [WORKFLOW_QUICK_CHECKLIST.md](./WORKFLOW_QUICK_CHECKLIST.md)
- [workflow-submodules.ps1](./workflow-submodules.ps1)

### Aprende a **escribir** buenos PRs
- [PLANTILLA_PR.md](./PLANTILLA_PR.md)

### Automatiza los **custom fields** del Project
- [AUTOMATIZACION_PROJECT_FIELDS.md](./AUTOMATIZACION_PROJECT_FIELDS.md)

### Entienda **por qué** funciona
- [TRAZABILIDAD_EXPLICADO.md](./TRAZABILIDAD_EXPLICADO.md)

### Quiero **toda la información**
- [WORKFLOW_SUBMÓDULOS.md](./WORKFLOW_SUBMÓDULOS.md)

### Necesito **integrar con Project**
- [PROJECT_WORKFLOW_INTEGRATION.md](./PROJECT_WORKFLOW_INTEGRATION.md)

### Busco **resumen ejecutivo**
- [SETUP_COMPLETADO.md](./SETUP_COMPLETADO.md)

---

## 🎉 Estado Actual

✅ Todo configurado y documentado
✅ Script automatizado listo
✅ GitHub Project en lugar
✅ Documentación completa

**Siguiente paso:** Lee [WORKFLOW_QUICK_CHECKLIST.md](./WORKFLOW_QUICK_CHECKLIST.md) y crea tu primer Issue.

**Bienvenido al workflow de recolecta_web.** 🚀
