FROM docker.n8n.io/n8nio/n8n-puppeteer

USER root

# Instala solo n8n-nodes-puppeteer si aún lo necesitas,
# ya que la imagen 'n8n-puppeteer' ya debería traer Puppeteer y Chromium.
RUN mkdir -p /opt/n8n-custom-nodes && \
    cd /opt/n8n-custom-nodes && \
    npm install n8n-nodes-puppeteer && \
    chown -R node:node /opt/n8n-custom-nodes

# Ya no necesitas las variables PUPPETEER_SKIP_CHROMIUM_DOWNLOAD
# ni PUPPETEER_EXECUTABLE_PATH en el Dockerfile si usas esta imagen.
# Ni la mayoría de los apk add.

# Asegúrate de que el entrypoint siga configurando NODE_PATH para n8n-nodes-puppeteer
COPY docker-custom-entrypoint.sh /docker-custom-entrypoint.sh
RUN chmod +x /docker-custom-entrypoint.sh && \
    chown node:node /docker-custom-entrypoint.sh

USER node

ENTRYPOINT ["/docker-custom-entrypoint.sh"]
