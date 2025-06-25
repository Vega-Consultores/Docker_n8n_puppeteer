FROM n8nio/n8n:1.99.1

RUN which n8n

ENV N8N_ENFORCE_SETTINGS_FILE_PERMISSIONS=true
ENV WEBHOOK_TUNNEL_URL=https://spirited-hope-production-europe-west4.up.railway.app
ENV N8N_HOST=spirited-hope-production-europe-west4.up.railway.app
ENV N8N_PROTOCOL=https
ENV N8N_PORT=${PORT}
ENV N8N_ENFORCE_SETTINGS_FILE_PERMISSIONS=true
ENV N8N_RUNNERS_ENABLED=true

CMD ["start"]
