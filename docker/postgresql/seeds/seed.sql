-- Seed de ejemplo para entorno de prueba
BEGIN;

-- Roles básicos
INSERT INTO rol (role_id, nombre, eliminado) VALUES
  (1, 'admin', FALSE),
  (2, 'operador', FALSE),
  (3, 'conductor', FALSE)
ON CONFLICT (role_id) DO NOTHING;

-- Colonias
INSERT INTO colonia (colonia_id, nombre, zona, created_at) VALUES
  (1, 'Centro', 'A', now()),
  (2, 'Norte', 'B', now())
ON CONFLICT (colonia_id) DO NOTHING;

-- Usuario admin demo (password hash ficticio; cámbialo antes de usar)
INSERT INTO usuario (user_id, nombre, alias, telefono, email, password, role_id, residencia_id, eliminado, created_at, updated_at)
VALUES
  (1, 'Admin Demo', 'admin', '0000000000', 'admin@example.com', '$2a$10$hash-demo-sin-valor', 1, NULL, FALSE, now(), now())
ON CONFLICT (user_id) DO NOTHING;

COMMIT;
