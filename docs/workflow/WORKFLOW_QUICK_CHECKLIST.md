# ⚡ Quick Checklist: Ciclo de Trabajo

Usa esta checklist cada vez que trabajes en una feature/bugfix.

## Antes de Empezar

- [ ] **Issue existe en recolecta_web** con etiquetas: `Area`, `Fase`, `Tipo`
- [ ] **Rama de trabajo creada:**
  ```powershell
  .\workflow-submodules.ps1 -action init-branch -branch feature/issue-X -issueNumber X
  ```

## Mientras Desarrollas

- [ ] **Para cada cambio en submódulo (frontend/backend):**
  
  1. Entrar:
     ```powershell
     .\workflow-submodules.ps1 -action work -submodule frontend
     ```
  
  2. Hacer cambios y commitear:
     ```powershell
     git add .
     git commit -m "feat: descripción"
     git push origin main
     cd ..
     ```
  
  3. Actualizar ref en padre:
     ```powershell
     .\workflow-submodules.ps1 -action update-parent -submodule frontend
     ```

## Terminar Feature

- [ ] **Ver estado final:**
  ```powershell
  .\workflow-submodules.ps1 -action status
  ```

- [ ] **Crear PR en GitHub:**
  - De: `feature/issue-X`
  - Hacia: `main`
  - Título: "Closes #X: [Area] Descripción"
  - Body: Lista de cambios (puedes dejar en blanco si es obvio)

- [ ] **Mergear PR** → GitHub cierra Issue automáticamente

## Resultado

✅ GitHub Project ve:
- Issue #X: Abierto → Cerrado
- PR #Y: Creado → Merged
- Commits en padre: Cada update-parent es visible
- Trazabilidad temporal completa

---

## Comandos Rápidos

```powershell
# Iniciar
.\workflow-submodules.ps1 -action init-branch -branch feature/issue-X -issueNumber X

# Trabajar en frontend
.\workflow-submodules.ps1 -action work -submodule frontend

# Después de pushear cambios
.\workflow-submodules.ps1 -action update-parent -submodule frontend

# Sincronizar todo
.\workflow-submodules.ps1 -action sync-all

# Ver estado
.\workflow-submodules.ps1 -action status
```

---

## Ejemplo Rápido (5 min)

```powershell
# 1. Iniciar
.\workflow-submodules.ps1 -action init-branch -branch feature/issue-5 -issueNumber 5

# 2. Trabajar en frontend
.\workflow-submodules.ps1 -action work -submodule frontend
# → editas Navbar.tsx, haces cambios
git add .
git commit -m "feat: update navbar style"
git push origin main
cd ..

# 3. Actualizar ref
.\workflow-submodules.ps1 -action update-parent -submodule frontend

# 4. Crear PR en GitHub (web)
# Título: "Closes #5: [Frontend] Update navbar style"
# Mergear

# ✅ Listo
```

