# Dockerfile  ── rebuild with cache clear / new commit
# ---------------------------------------------------
FROM docker.n8n.io/n8nio/n8n

################################################################################
# 1) Base OS packages (Chromium + Puppeteer deps)
################################################################################
USER root

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
    mesa-egl mesa-gl \
    libstdc++ libxcomposite libxcursor libxdamage libxext libxfixes \
    libxi libxrandr libxrender libxscrnsaver libxtst libxkbcommon \
    pango cairo graphite2 dbus libgudev \
    bash curl git

################################################################################
# 2) Tell Puppeteer to use system Chromium
################################################################################
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true \
    PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser

################################################################################
# 3) Community nodes + their runtime deps
#    (kept inside  /opt/n8n-custom-nodes   so n8n auto-loads them)
################################################################################
RUN mkdir -p /opt/n8n-custom-nodes \
 && cd       /opt/n8n-custom-nodes \
 && npm install --production \
      n8n-nodes-puppeteer \
      n8n-nodes-docxtemplater \
      puppeteer \
      docxtemplater \
      docxtemplater-image-module-free \
      html-docx-js

################################################################################
# 4) Also install the helper libs *globally* so Code nodes can `require()` them
################################################################################
RUN npm install -g --omit=dev \
      puppeteer \
      docxtemplater \
      docxtemplater-image-module-free \
      html-docx-js

################################################################################
# 5) Make Node look in both locations
################################################################################
ENV NODE_PATH=/usr/local/lib/node_modules:/opt/n8n-custom-nodes/node_modules

################################################################################
# 6) Custom entrypoint (unchanged)
################################################################################
COPY docker-custom-entrypoint.sh /docker-custom-entrypoint.sh
RUN chmod +x /docker-custom-entrypoint.sh \
 && chown node:node /docker-custom-entrypoint.sh

USER node
WORKDIR /home/node

ENTRYPOINT ["/docker-custom-entrypoint.sh"]
CMD ["start"]
