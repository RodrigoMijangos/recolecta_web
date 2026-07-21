const { register, listen } = require('push-receiver');
const fs = require('fs');
const path = require('path');

const SENDER_ID = process.env.FCM_SENDER_ID;
const TOKENS_FILE = '/shared/tokens.json';

if (!SENDER_ID) {
  console.error('[stag-clients] Error: FCM_SENDER_ID environment variable is required.');
  process.exit(1);
}

async function startClient(routeId) {
  console.log(`[stag-clients] Registering client for Route ${routeId} against Google FCM...`);
  try {
    const credentials = await register(SENDER_ID);
    const token = credentials.fcm.token;
    console.log(`[stag-clients] Registered Route ${routeId} successfully! Token: ${token.substring(0, 20)}...`);

    // Iniciar escucha persistente de notificaciones push de Google FCM
    const persistentListener = await listen(credentials, ({ notification, payload }) => {
      const now = new Date();
      // El payload contiene la clave "data" con la información custom
      const data = payload && payload.data ? payload.data : {};
      const title = (notification && notification.title) || (data && data.title) || 'Sin Título';
      const body = (notification && notification.body) || (data && data.body) || 'Sin Cuerpo';
      const userId = data.user_id || 'desconocido';
      const type = data.notificationType || data.type || 'unknown';
      const sentAtStr = data.sent_at || data.timestamp || '';
      
      let latenciaStr = 'N/A';
      if (sentAtStr) {
        const sentAt = new Date(sentAtStr);
        const latenciaMs = now - sentAt;
        latenciaStr = `${latenciaMs}ms`;
      }

      console.log(`[Ruta ${routeId}] 📬 Push recibido de Google FCM -> Tipo: ${type} | Destinatario Ciudadano: ${userId} | Título: "${title}" | Latencia de entrega: ${latenciaStr}`);
    });

    return { routeId, token, persistentListener };
  } catch (err) {
    console.error(`[stag-clients] Error starting client for Route ${routeId}:`, err);
    throw err;
  }
}

async function main() {
  const routesCount = 10;
  const clients = [];
  const tokensMap = {};

  // Levantar los 10 clientes concurrentemente
  const promises = [];
  for (let i = 1; i <= routesCount; i++) {
    promises.push(startClient(i));
  }

  try {
    const results = await Promise.all(promises);
    for (const res of results) {
      clients.push(res);
      tokensMap[res.routeId.toString()] = res.token;
    }

    // Escribir los tokens generados en el volumen compartido
    fs.mkdirSync(path.dirname(TOKENS_FILE), { recursive: true });
    fs.writeFileSync(TOKENS_FILE, JSON.stringify(tokensMap, null, 2));
    console.log(`[stag-clients] All ${routesCount} clients started. Tokens saved to ${TOKENS_FILE}. Listening for FCM notifications...`);
  } catch (err) {
    console.error('[stag-clients] Failed to start all clients:', err);
    process.exit(1);
  }
}

main();
