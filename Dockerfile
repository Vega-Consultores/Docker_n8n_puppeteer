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

# Install community nodes + their runtime deps **in /opt/n8n-custom-nodes**
RUN mkdir -p /opt/n8n-custom-nodes \
 && cd /opt/n8n-custom-nodes \
&& npm install --production \
     n8n-nodes-puppeteer \
     n8n-nodes-docxtemplater \
     puppeteer \
     docxtemplater \
     docxtemplater-image-module-free \
     html-docx-js   # <-- force rebuild


# Install puppeteer globally so all require('puppeteer') works in any node context
RUN npm install -g --omit=dev puppeteer

# Copiar tu entrypoint personalizado
COPY docker-custom-entrypoint.sh /docker-custom-entrypoint.sh
RUN chmod +x /docker-custom-entrypoint.sh && \
    chown node:node /docker-custom-entrypoint.sh

USER node
WORKDIR /home/node

ENTRYPOINT ["/docker-custom-entrypoint.sh"]
CMD ["start"]
