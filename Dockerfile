FROM docker.n8n.io/n8nio/n8n

USER root

# Instalar Chrome y dependencias
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

# Configurar Puppeteer para usar el Chrome instalado
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true \
    PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser

# Instalar n8n-nodes-puppeteer + puppeteer en /opt/n8n-custom-nodes
RUN mkdir -p /opt/n8n-custom-nodes && \
    cd /opt/n8n-custom-nodes && \
    npm install n8n-nodes-puppeteer puppeteer && \
    chown -R node:node /opt/n8n-custom-nodes

# Copiar tu entrypoint personalizado
COPY docker-custom-entrypoint.sh /docker-custom-entrypoint.sh
RUN chmod +x /docker-custom-entrypoint.sh && \
    chown node:node /docker-custom-entrypoint.sh

USER node
WORKDIR /home/node

ENTRYPOINT ["/docker-custom-entrypoint.sh"]
CMD ["start"]
