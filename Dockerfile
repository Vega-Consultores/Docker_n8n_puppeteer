FROM n8nio/n8n:latest

ENV N8N_HOST=spirited-hope-production-europe-west4.up.railway.app
ENV N8N_PROTOCOL=https
ENV N8N_LISTEN_ADDRESS=0.0.0.0

CMD ["start"]
