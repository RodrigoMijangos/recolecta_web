-- =============================================================================
-- SEED NIVEL PYME - Sistema de Recolección de Basura
-- =============================================================================
-- Datos coherentes para una empresa mediana con:
-- - 4 roles organizacionales
-- - 12 usuarios (admin, coordinadores, operadores, conductores)
-- - 8 colonias en 3 zonas
-- - 6 camiones (3 propios, 3 rentados)
-- - 5 rutas operativas con puntos de recolección
-- - 2 rellenos sanitarios
-- - Tipos de mantenimiento preventivo y correctivo
-- =============================================================================

BEGIN;

-- -----------------------------------------------------------------------------
-- 1. ROLES DEL SISTEMA
-- -----------------------------------------------------------------------------
INSERT INTO rol (role_id, nombre, eliminado) VALUES
  (1, 'Administrador', FALSE),
  (2, 'Coordinador', FALSE),
  (3, 'Operador', FALSE),
  (4, 'Conductor', FALSE),
  (5, 'Ciudadano', FALSE)
ON CONFLICT (role_id) DO NOTHING;

-- -----------------------------------------------------------------------------
-- 2. COLONIAS (8 colonias en 3 zonas: Norte, Centro, Sur)
-- -----------------------------------------------------------------------------
INSERT INTO colonia (colonia_id, nombre, zona, created_at) VALUES
  (1, 'Centro Histórico', 'Centro', '2024-01-15 08:00:00'),
  (2, 'Colonia Industrial', 'Norte', '2024-01-15 08:00:00'),
  (3, 'Las Palmas', 'Norte', '2024-01-15 08:00:00'),
  (4, 'Vista Hermosa', 'Sur', '2024-01-15 08:00:00'),
  (5, 'Jardines del Valle', 'Sur', '2024-01-15 08:00:00'),
  (6, 'El Mirador', 'Centro', '2024-01-15 08:00:00'),
  (7, 'Residencial San Miguel', 'Norte', '2024-01-15 08:00:00'),
  (8, 'Fraccionamiento Los Pinos', 'Sur', '2024-01-15 08:00:00')
ON CONFLICT (colonia_id) DO NOTHING;

-- -----------------------------------------------------------------------------
-- 3. USUARIOS (12 usuarios: 1 admin, 2 coordinadores, 3 operadores, 6 conductores)
-- -----------------------------------------------------------------------------
-- Password: todas las cuentas usan 'Password123!' (hash bcrypt ficticio)
INSERT INTO usuario (user_id, nombre, alias, telefono, email, password, role_id, residencia_id, eliminado, created_at, updated_at)
VALUES
  -- Administrador
  (1, 'Roberto García Méndez', 'rgarcia', '4421234567', 'roberto.garcia@recolecta.mx', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 1, NULL, FALSE, '2024-01-10 09:00:00', '2024-01-10 09:00:00'),
  
  -- Coordinadores (gestionan rutas y mantenimiento)
  (2, 'María Elena Torres', 'mtorres', '4421234568', 'maria.torres@recolecta.mx', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 2, NULL, FALSE, '2024-01-12 10:00:00', '2024-01-12 10:00:00'),
  (3, 'Carlos Ramírez López', 'cramirez', '4421234569', 'carlos.ramirez@recolecta.mx', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 2, NULL, FALSE, '2024-01-12 10:30:00', '2024-01-12 10:30:00'),
  
  -- Operadores (monitoreo y validación)
  (4, 'Ana Patricia Morales', 'amorales', '4421234570', 'ana.morales@recolecta.mx', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 3, NULL, FALSE, '2024-01-15 08:30:00', '2024-01-15 08:30:00'),
  (5, 'Jorge Luis Sánchez', 'jsanchez', '4421234571', 'jorge.sanchez@recolecta.mx', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 3, NULL, FALSE, '2024-01-15 08:45:00', '2024-01-15 08:45:00'),
  (6, 'Patricia Hernández Cruz', 'phernandez', '4421234572', 'patricia.hernandez@recolecta.mx', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 3, NULL, FALSE, '2024-01-15 09:00:00', '2024-01-15 09:00:00'),
  
  -- Conductores (6 operando camiones)
  (7, 'Juan Manuel Flores', 'jflores', '4421234573', 'juan.flores@recolecta.mx', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 4, NULL, FALSE, '2024-02-01 07:00:00', '2024-02-01 07:00:00'),
  (8, 'Pedro Ávila Gómez', 'pavila', '4421234574', 'pedro.avila@recolecta.mx', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 4, NULL, FALSE, '2024-02-01 07:15:00', '2024-02-01 07:15:00'),
  (9, 'Luis Alberto Vargas', 'lvargas', '4421234575', 'luis.vargas@recolecta.mx', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 4, NULL, FALSE, '2024-02-01 07:30:00', '2024-02-01 07:30:00'),
  (10, 'Miguel Ángel Medina', 'mmedina', '4421234576', 'miguel.medina@recolecta.mx', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 4, NULL, FALSE, '2024-02-05 07:00:00', '2024-02-05 07:00:00'),
  (11, 'José Antonio Ruiz', 'jruiz', '4421234577', 'jose.ruiz@recolecta.mx', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 4, NULL, FALSE, '2024-02-05 07:15:00', '2024-02-05 07:15:00'),
  (12, 'Francisco Javier Castro', 'fcastro', '4421234578', 'francisco.castro@recolecta.mx', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 4, NULL, FALSE, '2024-02-05 07:30:00', '2024-02-05 07:30:00'),

  -- Usuarios comunes (Ciudadanos) x200 - IDs 100..299

  -- Ciudadanos (200 usuarios)
  (100, 'Usuario 100', 'user100', '5520000100', 'user100@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (101, 'Usuario 101', 'user101', '5520000101', 'user101@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (102, 'Usuario 102', 'user102', '5520000102', 'user102@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (103, 'Usuario 103', 'user103', '5520000103', 'user103@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (104, 'Usuario 104', 'user104', '5520000104', 'user104@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (105, 'Usuario 105', 'user105', '5520000105', 'user105@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (106, 'Usuario 106', 'user106', '5520000106', 'user106@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (107, 'Usuario 107', 'user107', '5520000107', 'user107@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (108, 'Usuario 108', 'user108', '5520000108', 'user108@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (109, 'Usuario 109', 'user109', '5520000109', 'user109@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (110, 'Usuario 110', 'user110', '5520000110', 'user110@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (111, 'Usuario 111', 'user111', '5520000111', 'user111@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (112, 'Usuario 112', 'user112', '5520000112', 'user112@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (113, 'Usuario 113', 'user113', '5520000113', 'user113@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (114, 'Usuario 114', 'user114', '5520000114', 'user114@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (115, 'Usuario 115', 'user115', '5520000115', 'user115@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (116, 'Usuario 116', 'user116', '5520000116', 'user116@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (117, 'Usuario 117', 'user117', '5520000117', 'user117@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (118, 'Usuario 118', 'user118', '5520000118', 'user118@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (119, 'Usuario 119', 'user119', '5520000119', 'user119@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (120, 'Usuario 120', 'user120', '5520000120', 'user120@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (121, 'Usuario 121', 'user121', '5520000121', 'user121@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (122, 'Usuario 122', 'user122', '5520000122', 'user122@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (123, 'Usuario 123', 'user123', '5520000123', 'user123@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (124, 'Usuario 124', 'user124', '5520000124', 'user124@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (125, 'Usuario 125', 'user125', '5520000125', 'user125@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (126, 'Usuario 126', 'user126', '5520000126', 'user126@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (127, 'Usuario 127', 'user127', '5520000127', 'user127@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (128, 'Usuario 128', 'user128', '5520000128', 'user128@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (129, 'Usuario 129', 'user129', '5520000129', 'user129@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (130, 'Usuario 130', 'user130', '5520000130', 'user130@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (131, 'Usuario 131', 'user131', '5520000131', 'user131@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (132, 'Usuario 132', 'user132', '5520000132', 'user132@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (133, 'Usuario 133', 'user133', '5520000133', 'user133@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (134, 'Usuario 134', 'user134', '5520000134', 'user134@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (135, 'Usuario 135', 'user135', '5520000135', 'user135@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (136, 'Usuario 136', 'user136', '5520000136', 'user136@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (137, 'Usuario 137', 'user137', '5520000137', 'user137@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (138, 'Usuario 138', 'user138', '5520000138', 'user138@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (139, 'Usuario 139', 'user139', '5520000139', 'user139@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (140, 'Usuario 140', 'user140', '5520000140', 'user140@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (141, 'Usuario 141', 'user141', '5520000141', 'user141@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (142, 'Usuario 142', 'user142', '5520000142', 'user142@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (143, 'Usuario 143', 'user143', '5520000143', 'user143@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (144, 'Usuario 144', 'user144', '5520000144', 'user144@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (145, 'Usuario 145', 'user145', '5520000145', 'user145@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (146, 'Usuario 146', 'user146', '5520000146', 'user146@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (147, 'Usuario 147', 'user147', '5520000147', 'user147@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (148, 'Usuario 148', 'user148', '5520000148', 'user148@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (149, 'Usuario 149', 'user149', '5520000149', 'user149@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (150, 'Usuario 150', 'user150', '5520000150', 'user150@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (151, 'Usuario 151', 'user151', '5520000151', 'user151@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (152, 'Usuario 152', 'user152', '5520000152', 'user152@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (153, 'Usuario 153', 'user153', '5520000153', 'user153@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (154, 'Usuario 154', 'user154', '5520000154', 'user154@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (155, 'Usuario 155', 'user155', '5520000155', 'user155@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (156, 'Usuario 156', 'user156', '5520000156', 'user156@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (157, 'Usuario 157', 'user157', '5520000157', 'user157@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (158, 'Usuario 158', 'user158', '5520000158', 'user158@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (159, 'Usuario 159', 'user159', '5520000159', 'user159@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (160, 'Usuario 160', 'user160', '5520000160', 'user160@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (161, 'Usuario 161', 'user161', '5520000161', 'user161@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (162, 'Usuario 162', 'user162', '5520000162', 'user162@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (163, 'Usuario 163', 'user163', '5520000163', 'user163@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (164, 'Usuario 164', 'user164', '5520000164', 'user164@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (165, 'Usuario 165', 'user165', '5520000165', 'user165@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (166, 'Usuario 166', 'user166', '5520000166', 'user166@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (167, 'Usuario 167', 'user167', '5520000167', 'user167@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (168, 'Usuario 168', 'user168', '5520000168', 'user168@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (169, 'Usuario 169', 'user169', '5520000169', 'user169@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (170, 'Usuario 170', 'user170', '5520000170', 'user170@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (171, 'Usuario 171', 'user171', '5520000171', 'user171@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (172, 'Usuario 172', 'user172', '5520000172', 'user172@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (173, 'Usuario 173', 'user173', '5520000173', 'user173@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (174, 'Usuario 174', 'user174', '5520000174', 'user174@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (175, 'Usuario 175', 'user175', '5520000175', 'user175@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (176, 'Usuario 176', 'user176', '5520000176', 'user176@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (177, 'Usuario 177', 'user177', '5520000177', 'user177@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (178, 'Usuario 178', 'user178', '5520000178', 'user178@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (179, 'Usuario 179', 'user179', '5520000179', 'user179@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (180, 'Usuario 180', 'user180', '5520000180', 'user180@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (181, 'Usuario 181', 'user181', '5520000181', 'user181@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (182, 'Usuario 182', 'user182', '5520000182', 'user182@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (183, 'Usuario 183', 'user183', '5520000183', 'user183@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (184, 'Usuario 184', 'user184', '5520000184', 'user184@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (185, 'Usuario 185', 'user185', '5520000185', 'user185@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (186, 'Usuario 186', 'user186', '5520000186', 'user186@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (187, 'Usuario 187', 'user187', '5520000187', 'user187@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (188, 'Usuario 188', 'user188', '5520000188', 'user188@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (189, 'Usuario 189', 'user189', '5520000189', 'user189@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (190, 'Usuario 190', 'user190', '5520000190', 'user190@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (191, 'Usuario 191', 'user191', '5520000191', 'user191@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (192, 'Usuario 192', 'user192', '5520000192', 'user192@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (193, 'Usuario 193', 'user193', '5520000193', 'user193@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (194, 'Usuario 194', 'user194', '5520000194', 'user194@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (195, 'Usuario 195', 'user195', '5520000195', 'user195@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (196, 'Usuario 196', 'user196', '5520000196', 'user196@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (197, 'Usuario 197', 'user197', '5520000197', 'user197@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (198, 'Usuario 198', 'user198', '5520000198', 'user198@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (199, 'Usuario 199', 'user199', '5520000199', 'user199@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (200, 'Usuario 200', 'user200', '5520000200', 'user200@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (201, 'Usuario 201', 'user201', '5520000201', 'user201@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (202, 'Usuario 202', 'user202', '5520000202', 'user202@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (203, 'Usuario 203', 'user203', '5520000203', 'user203@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (204, 'Usuario 204', 'user204', '5520000204', 'user204@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (205, 'Usuario 205', 'user205', '5520000205', 'user205@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (206, 'Usuario 206', 'user206', '5520000206', 'user206@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (207, 'Usuario 207', 'user207', '5520000207', 'user207@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (208, 'Usuario 208', 'user208', '5520000208', 'user208@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (209, 'Usuario 209', 'user209', '5520000209', 'user209@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (210, 'Usuario 210', 'user210', '5520000210', 'user210@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (211, 'Usuario 211', 'user211', '5520000211', 'user211@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (212, 'Usuario 212', 'user212', '5520000212', 'user212@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (213, 'Usuario 213', 'user213', '5520000213', 'user213@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (214, 'Usuario 214', 'user214', '5520000214', 'user214@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (215, 'Usuario 215', 'user215', '5520000215', 'user215@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (216, 'Usuario 216', 'user216', '5520000216', 'user216@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (217, 'Usuario 217', 'user217', '5520000217', 'user217@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (218, 'Usuario 218', 'user218', '5520000218', 'user218@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (219, 'Usuario 219', 'user219', '5520000219', 'user219@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (220, 'Usuario 220', 'user220', '5520000220', 'user220@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (221, 'Usuario 221', 'user221', '5520000221', 'user221@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (222, 'Usuario 222', 'user222', '5520000222', 'user222@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (223, 'Usuario 223', 'user223', '5520000223', 'user223@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (224, 'Usuario 224', 'user224', '5520000224', 'user224@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (225, 'Usuario 225', 'user225', '5520000225', 'user225@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (226, 'Usuario 226', 'user226', '5520000226', 'user226@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (227, 'Usuario 227', 'user227', '5520000227', 'user227@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (228, 'Usuario 228', 'user228', '5520000228', 'user228@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (229, 'Usuario 229', 'user229', '5520000229', 'user229@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (230, 'Usuario 230', 'user230', '5520000230', 'user230@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (231, 'Usuario 231', 'user231', '5520000231', 'user231@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (232, 'Usuario 232', 'user232', '5520000232', 'user232@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (233, 'Usuario 233', 'user233', '5520000233', 'user233@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (234, 'Usuario 234', 'user234', '5520000234', 'user234@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (235, 'Usuario 235', 'user235', '5520000235', 'user235@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (236, 'Usuario 236', 'user236', '5520000236', 'user236@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (237, 'Usuario 237', 'user237', '5520000237', 'user237@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (238, 'Usuario 238', 'user238', '5520000238', 'user238@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (239, 'Usuario 239', 'user239', '5520000239', 'user239@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (240, 'Usuario 240', 'user240', '5520000240', 'user240@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (241, 'Usuario 241', 'user241', '5520000241', 'user241@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (242, 'Usuario 242', 'user242', '5520000242', 'user242@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (243, 'Usuario 243', 'user243', '5520000243', 'user243@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (244, 'Usuario 244', 'user244', '5520000244', 'user244@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (245, 'Usuario 245', 'user245', '5520000245', 'user245@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (246, 'Usuario 246', 'user246', '5520000246', 'user246@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (247, 'Usuario 247', 'user247', '5520000247', 'user247@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (248, 'Usuario 248', 'user248', '5520000248', 'user248@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (249, 'Usuario 249', 'user249', '5520000249', 'user249@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (250, 'Usuario 250', 'user250', '5520000250', 'user250@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (251, 'Usuario 251', 'user251', '5520000251', 'user251@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (252, 'Usuario 252', 'user252', '5520000252', 'user252@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (253, 'Usuario 253', 'user253', '5520000253', 'user253@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (254, 'Usuario 254', 'user254', '5520000254', 'user254@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (255, 'Usuario 255', 'user255', '5520000255', 'user255@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (256, 'Usuario 256', 'user256', '5520000256', 'user256@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (257, 'Usuario 257', 'user257', '5520000257', 'user257@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (258, 'Usuario 258', 'user258', '5520000258', 'user258@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (259, 'Usuario 259', 'user259', '5520000259', 'user259@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (260, 'Usuario 260', 'user260', '5520000260', 'user260@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (261, 'Usuario 261', 'user261', '5520000261', 'user261@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (262, 'Usuario 262', 'user262', '5520000262', 'user262@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (263, 'Usuario 263', 'user263', '5520000263', 'user263@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (264, 'Usuario 264', 'user264', '5520000264', 'user264@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (265, 'Usuario 265', 'user265', '5520000265', 'user265@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (266, 'Usuario 266', 'user266', '5520000266', 'user266@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (267, 'Usuario 267', 'user267', '5520000267', 'user267@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (268, 'Usuario 268', 'user268', '5520000268', 'user268@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (269, 'Usuario 269', 'user269', '5520000269', 'user269@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (270, 'Usuario 270', 'user270', '5520000270', 'user270@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (271, 'Usuario 271', 'user271', '5520000271', 'user271@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (272, 'Usuario 272', 'user272', '5520000272', 'user272@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (273, 'Usuario 273', 'user273', '5520000273', 'user273@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (274, 'Usuario 274', 'user274', '5520000274', 'user274@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (275, 'Usuario 275', 'user275', '5520000275', 'user275@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (276, 'Usuario 276', 'user276', '5520000276', 'user276@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (277, 'Usuario 277', 'user277', '5520000277', 'user277@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (278, 'Usuario 278', 'user278', '5520000278', 'user278@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (279, 'Usuario 279', 'user279', '5520000279', 'user279@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (280, 'Usuario 280', 'user280', '5520000280', 'user280@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (281, 'Usuario 281', 'user281', '5520000281', 'user281@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (282, 'Usuario 282', 'user282', '5520000282', 'user282@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (283, 'Usuario 283', 'user283', '5520000283', 'user283@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (284, 'Usuario 284', 'user284', '5520000284', 'user284@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (285, 'Usuario 285', 'user285', '5520000285', 'user285@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (286, 'Usuario 286', 'user286', '5520000286', 'user286@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (287, 'Usuario 287', 'user287', '5520000287', 'user287@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (288, 'Usuario 288', 'user288', '5520000288', 'user288@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (289, 'Usuario 289', 'user289', '5520000289', 'user289@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (290, 'Usuario 290', 'user290', '5520000290', 'user290@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (291, 'Usuario 291', 'user291', '5520000291', 'user291@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (292, 'Usuario 292', 'user292', '5520000292', 'user292@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (293, 'Usuario 293', 'user293', '5520000293', 'user293@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (294, 'Usuario 294', 'user294', '5520000294', 'user294@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (295, 'Usuario 295', 'user295', '5520000295', 'user295@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (296, 'Usuario 296', 'user296', '5520000296', 'user296@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (297, 'Usuario 297', 'user297', '5520000297', 'user297@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (298, 'Usuario 298', 'user298', '5520000298', 'user298@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00'),
  (299, 'Usuario 299', 'user299', '5520000299', 'user299@example.com', '$2a$10$EixZaYVK1fsbw1ZfbX3OXe', 5, NULL, FALSE, '2024-03-01 08:00:00', '2024-03-01 08:00:00')
ON CONFLICT (user_id) DO NOTHING;

-- -----------------------------------------------------------------------------
-- 3.b DOMICILIOS PARA CIUDADANOS (una dirección por usuario 100..299)
-- Direcciones formateadas para que servicios de geocodificación las resuelvan fácilmente
-- -----------------------------------------------------------------------------
INSERT INTO domicilio (domicilio_id, usuario_id, alias, direccion, colonia_id, eliminado, created_at, updated_at)
SELECT
  (100 + g) AS domicilio_id,
  (100 + g) AS usuario_id,
  'Domicilio Principal' AS alias,
  (
    (ARRAY['Calle Olmo','Calle Lirio','Calle Roble','Avenida Reforma','Calle Cedro','Calle Laurel','Calle Magnolia','Calle Nogal','Calle Pino','Calle Sauce'])[ (g % 10) + 1 ]
    || ' ' || ((100 + g) % 200 + 10)::text
    || ', Colonia ' || (ARRAY['Centro Histórico','Colonia Industrial','Las Palmas','Vista Hermosa','Jardines del Valle','El Mirador','Residencial San Miguel','Fraccionamiento Los Pinos'])[ (g % 8) + 1 ]
    || ', Ciudad Recolecta, Estado Recolecta, CP ' || (ARRAY['38000','38100','38110','38200','38210','38010','38120','38220'])[ (g % 8) + 1 ]
  ) AS direccion,
  ((g % 8) + 1) AS colonia_id,
  FALSE AS eliminado,
  now() AS created_at,
  now() AS updated_at
FROM generate_series(0,199) g
ON CONFLICT (domicilio_id) DO NOTHING;

-- Actualizar usuario.residencia_id para apuntar al domicilio recién insertado
UPDATE usuario u
SET residencia_id = d.domicilio_id
FROM domicilio d
WHERE u.user_id = d.usuario_id AND u.residencia_id IS NULL;

-- -----------------------------------------------------------------------------
-- 4. TIPOS DE CAMIÓN
-- -----------------------------------------------------------------------------
INSERT INTO tipo_camion (tipo_camion_id, nombre, descripcion, created_at) VALUES
  (1, 'Compactador 12m³', 'Camión compactador estándar capacidad 12 metros cúbicos', '2024-01-10 10:00:00'),
  (2, 'Compactador 15m³', 'Camión compactador gran capacidad 15 metros cúbicos', '2024-01-10 10:00:00'),
  (3, 'Camión de Volteo', 'Camión de volteo para escombros y residuos voluminosos', '2024-01-10 10:00:00')
ON CONFLICT (tipo_camion_id) DO NOTHING;

-- -----------------------------------------------------------------------------
-- 5. CAMIONES (6 unidades: 3 propios, 3 rentados)
-- -----------------------------------------------------------------------------
INSERT INTO camion (camion_id, placa, modelo, tipo_camion_id, es_rentado, eliminado, disponibilidad_id, nombre_disponibilidad, color_disponibilidad, created_at, updated_at)
VALUES
  -- Propios
  (1, 'ABC-123-MX', 'Freightliner M2 106 2022', 1, FALSE, FALSE, 1, 'Disponible', '#28a745', '2024-01-20 08:00:00', '2024-01-20 08:00:00'),
  (2, 'DEF-456-MX', 'International DuraStar 2021', 2, FALSE, FALSE, 1, 'Disponible', '#28a745', '2024-01-20 08:15:00', '2024-01-20 08:15:00'),
  (3, 'GHI-789-MX', 'Kenworth T370 2023', 1, FALSE, FALSE, 1, 'Disponible', '#28a745', '2024-01-20 08:30:00', '2024-01-20 08:30:00'),
  
  -- Rentados
  (4, 'JKL-012-MX', 'Volvo VHD 2020', 2, TRUE, FALSE, 1, 'Disponible', '#28a745', '2024-02-01 09:00:00', '2024-02-01 09:00:00'),
  (5, 'MNO-345-MX', 'Peterbilt 337 2021', 1, TRUE, FALSE, 1, 'Disponible', '#28a745', '2024-02-01 09:15:00', '2024-02-01 09:15:00'),
  (6, 'PQR-678-MX', 'Mack LR 2019', 3, TRUE, FALSE, 1, 'Disponible', '#28a745', '2024-02-01 09:30:00', '2024-02-01 09:30:00')
ON CONFLICT (camion_id) DO NOTHING;

-- -----------------------------------------------------------------------------
-- 6. HISTORIAL DE ASIGNACIÓN (conductores asignados a camiones)
-- -----------------------------------------------------------------------------
INSERT INTO historial_asignacion_camion (id_historial, id_chofer, id_camion, fecha_asignacion, fecha_baja, eliminado, created_at, updated_at)
VALUES
  (1, 7, 1, '2024-02-10 06:00:00', NULL, FALSE, '2024-02-10 06:00:00', '2024-02-10 06:00:00'),
  (2, 8, 2, '2024-02-10 06:00:00', NULL, FALSE, '2024-02-10 06:00:00', '2024-02-10 06:00:00'),
  (3, 9, 3, '2024-02-10 06:00:00', NULL, FALSE, '2024-02-10 06:00:00', '2024-02-10 06:00:00'),
  (4, 10, 4, '2024-02-15 06:00:00', NULL, FALSE, '2024-02-15 06:00:00', '2024-02-15 06:00:00'),
  (5, 11, 5, '2024-02-15 06:00:00', NULL, FALSE, '2024-02-15 06:00:00', '2024-02-15 06:00:00'),
  (6, 12, 6, '2024-02-15 06:00:00', NULL, FALSE, '2024-02-15 06:00:00', '2024-02-15 06:00:00')
ON CONFLICT (id_historial) DO NOTHING;

-- -----------------------------------------------------------------------------
-- 7. RUTAS (5 rutas operativas)
-- -----------------------------------------------------------------------------
INSERT INTO ruta (ruta_id, nombre, descripcion, json_ruta, eliminado, created_at) VALUES
  (1, 'Ruta Norte A', 'Cobertura Colonia Industrial y Las Palmas', '{"zona": "Norte", "turno": "matutino"}', FALSE, '2024-02-01 08:00:00'),
  (2, 'Ruta Norte B', 'Cobertura Residencial San Miguel', '{"zona": "Norte", "turno": "vespertino"}', FALSE, '2024-02-01 08:15:00'),
  (3, 'Ruta Centro', 'Cobertura Centro Histórico y El Mirador', '{"zona": "Centro", "turno": "matutino"}', FALSE, '2024-02-01 08:30:00'),
  (4, 'Ruta Sur A', 'Cobertura Vista Hermosa y Jardines del Valle', '{"zona": "Sur", "turno": "matutino"}', FALSE, '2024-02-01 08:45:00'),
  (5, 'Ruta Sur B', 'Cobertura Fraccionamiento Los Pinos', '{"zona": "Sur", "turno": "vespertino"}', FALSE, '2024-02-01 09:00:00')
ON CONFLICT (ruta_id) DO NOTHING;

-- -----------------------------------------------------------------------------
-- 8. PUNTOS DE RECOLECCIÓN (25 puntos distribuidos en 5 rutas)
-- -----------------------------------------------------------------------------
INSERT INTO punto_recoleccion (punto_id, ruta_id, cp, eliminado) VALUES
  -- Ruta Norte A (5 puntos)
  (1, 1, 'PR-NA-001', FALSE),
  (2, 1, 'PR-NA-002', FALSE),
  (3, 1, 'PR-NA-003', FALSE),
  (4, 1, 'PR-NA-004', FALSE),
  (5, 1, 'PR-NA-005', FALSE),
  
  -- Ruta Norte B (5 puntos)
  (6, 2, 'PR-NB-001', FALSE),
  (7, 2, 'PR-NB-002', FALSE),
  (8, 2, 'PR-NB-003', FALSE),
  (9, 2, 'PR-NB-004', FALSE),
  (10, 2, 'PR-NB-005', FALSE),
  
  -- Ruta Centro (5 puntos)
  (11, 3, 'PR-CE-001', FALSE),
  (12, 3, 'PR-CE-002', FALSE),
  (13, 3, 'PR-CE-003', FALSE),
  (14, 3, 'PR-CE-004', FALSE),
  (15, 3, 'PR-CE-005', FALSE),
  
  -- Ruta Sur A (5 puntos)
  (16, 4, 'PR-SA-001', FALSE),
  (17, 4, 'PR-SA-002', FALSE),
  (18, 4, 'PR-SA-003', FALSE),
  (19, 4, 'PR-SA-004', FALSE),
  (20, 4, 'PR-SA-005', FALSE),
  
  -- Ruta Sur B (5 puntos)
  (21, 5, 'PR-SB-001', FALSE),
  (22, 5, 'PR-SB-002', FALSE),
  (23, 5, 'PR-SB-003', FALSE),
  (24, 5, 'PR-SB-004', FALSE),
  (25, 5, 'PR-SB-005', FALSE)
ON CONFLICT (punto_id) DO NOTHING;

-- -----------------------------------------------------------------------------
-- 9. ASIGNACIÓN RUTA-CAMIÓN (asignaciones activas para hoy)
-- -----------------------------------------------------------------------------
INSERT INTO ruta_camion (ruta_camion_id, ruta_id, camion_id, fecha, created_at, eliminado) VALUES
  (1, 1, 1, CURRENT_DATE, now(), FALSE),
  (2, 2, 5, CURRENT_DATE, now(), FALSE),
  (3, 3, 2, CURRENT_DATE, now(), FALSE),
  (4, 4, 3, CURRENT_DATE, now(), FALSE),
  (5, 5, 4, CURRENT_DATE, now(), FALSE)
ON CONFLICT (ruta_camion_id) DO NOTHING;

-- -----------------------------------------------------------------------------
-- 10. RELLENOS SANITARIOS (2 sitios: 1 propio, 1 rentado)
-- -----------------------------------------------------------------------------
INSERT INTO relleno_sanitario (relleno_id, nombre, direccion, es_rentado, eliminado, capacidad_toneladas) VALUES
  (1, 'Relleno Municipal Norte', 'Km 15 Carretera a San Luis, Zona Industrial', FALSE, FALSE, 5000.00),
  (2, 'Relleno Privado El Mirador', 'Ejido El Mirador S/N, Parcela 42', TRUE, FALSE, 3000.00)
ON CONFLICT (relleno_id) DO NOTHING;

-- -----------------------------------------------------------------------------
-- 11. TIPOS DE MANTENIMIENTO (8 tipos comunes)
-- -----------------------------------------------------------------------------
INSERT INTO tipo_mantenimiento (tipo_mantenimiento_id, nombre, categoria, eliminado) VALUES
  (1, 'Cambio de Aceite', 'preventivo', FALSE),
  (2, 'Revisión de Frenos', 'preventivo', FALSE),
  (3, 'Alineación y Balanceo', 'preventivo', FALSE),
  (4, 'Cambio de Filtros', 'preventivo', FALSE),
  (5, 'Reparación Motor', 'correctivo', FALSE),
  (6, 'Reparación Transmisión', 'correctivo', FALSE),
  (7, 'Reparación Sistema Hidráulico', 'correctivo', FALSE),
  (8, 'Reemplazo Neumáticos', 'correctivo', FALSE)
ON CONFLICT (tipo_mantenimiento_id) DO NOTHING;

-- -----------------------------------------------------------------------------
-- 12. ALERTAS DE MANTENIMIENTO (3 alertas activas)
-- -----------------------------------------------------------------------------
INSERT INTO alerta_mantenimiento (alerta_id, camion_id, tipo_mantenimiento_id, descripcion, observaciones, created_at, atendido) VALUES
  (1, 2, 1, 'Cambio de aceite programado - 15,000 km', 'Unidad alcanzó kilometraje para servicio', '2026-01-20 10:00:00', FALSE),
  (2, 5, 2, 'Revisión de frenos - ruido detectado', 'Conductor reportó ruido al frenar', '2026-01-22 14:30:00', FALSE),
  (3, 6, 4, 'Cambio de filtros preventivo', 'Mantenimiento trimestral', '2026-01-25 09:00:00', FALSE)
ON CONFLICT (alerta_id) DO NOTHING;

-- -----------------------------------------------------------------------------
-- 13. REGISTROS DE VACIADO (últimos 10 vaciados en rellenos)
-- -----------------------------------------------------------------------------
INSERT INTO registro_vaciado (vaciado_id, relleno_id, ruta_camion_id, hora) VALUES
  (1, 1, 1, '2026-01-27 11:30:00'),
  (2, 1, 3, '2026-01-27 12:15:00'),
  (3, 2, 2, '2026-01-27 16:45:00'),
  (4, 2, 5, '2026-01-27 17:20:00'),
  (5, 1, 4, '2026-01-27 12:45:00'),
  (6, 1, 1, '2026-01-26 11:30:00'),
  (7, 2, 2, '2026-01-26 16:30:00'),
  (8, 1, 3, '2026-01-26 12:00:00'),
  (9, 2, 4, '2026-01-26 17:00:00'),
  (10, 1, 5, '2026-01-26 13:00:00')
ON CONFLICT (vaciado_id) DO NOTHING;

-- -----------------------------------------------------------------------------
-- 14. AVISOS GENERALES (1 aviso activo)
-- -----------------------------------------------------------------------------
INSERT INTO aviso_general (aviso_id, titulo, mensaje, activo, created_at) VALUES
  (1, 'Mantenimiento Programado', 'Se realizará mantenimiento al sistema el próximo domingo de 00:00 a 06:00 hrs. Durante este periodo el sistema no estará disponible.', TRUE, '2026-01-25 08:00:00')
ON CONFLICT (aviso_id) DO NOTHING;

COMMIT;

-- =============================================================================
-- FIN DEL SEED
-- =============================================================================
-- Resumen de datos insertados:
-- Resumen de datos insertados:
-- - 5 roles
-- - 8 colonias (3 zonas)
-- - 212 usuarios (12 staff + 200 ciudadanos)
-- - 3 tipos de camión
-- - 6 camiones (3 propios, 3 rentados)
-- - 6 asignaciones conductor-camión activas
-- - 5 rutas operativas
-- - 25 puntos de recolección
-- - 5 asignaciones ruta-camión activas para hoy
-- - 2 rellenos sanitarios
-- - 8 tipos de mantenimiento
-- - 3 alertas de mantenimiento activas
-- - 10 registros de vaciado
-- - 1 aviso general activo
-- =============================================================================
