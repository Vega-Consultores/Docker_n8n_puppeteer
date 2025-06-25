FROM docker.n8n.io/n8nio/n8n

USER root

# Install Chrome dependencies and Chrome
RUN apk add --no-cache \
    chromium \
    nss \
    glib \
    freetype \
    harfbuzz \
    ca-certificates \
    ttf-freefont \
    udev \
    ttf-liberation \
    font-noto-emoji \
    mesa-egl \
    mesa-gl \
    libstdc++ \
    libxcomposite \
    libxcursor \
    libxdamage \
    libxext \
    libxfixes \
    libxi \
    libxrandr \
    libxrender \
    libxscrnsaver \
    libxtst \
    libxkbcommon \
    pango \
    cairo \
    graphite2 \
    dbus \
    libgudev \
    bash \
    curl \
    git

# Tell Puppeteer to use installed Chrome instead of downloading it
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true \
    PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser

# Install n8n-nodes-puppeteer in a permanent location
RUN mkdir -p /opt/n8n-custom-nodes && \
    cd /opt/n8n-custom-nodes && \
    npm install n8n-nodes-puppeteer && \
    chown -R node:node /opt/n8n-custom-nodes

# --- NUEVO: Instalar puppeteer en el directorio global de n8n ---
# Esto puede resolver el "Cannot find module" si n8n no busca en NODE_PATH para ciertos contextos.
RUN cd /usr/local/lib/node_modules/n8n && npm install puppeteer puppeteer-core && \
    chown -R node:node /usr/local/lib/node_modules/n8n/node_modules/puppeteer* || true
# --- FIN NUEVO ---

# Copy our custom entrypoint
COPY docker-custom-entrypoint.sh /docker-custom-entrypoint.sh
RUN chmod +x /docker-custom-entrypoint.sh && \
    chown node:node /docker-custom-entrypoint.sh

USER node

ENTRYPOINT ["/docker-custom-entrypoint.sh"]
