FROM n8nio/n8n:1.99.1

USER root
RUN apk add --no-cache \
  chromium \
  nss \
  freetype \
  harfbuzz \
  ttf-freefont \
  && mkdir -p /usr/lib/chromium/ \
  && ln -sf /usr/bin/chromium-browser /usr/bin/chromium

ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser

EXPOSE 5678

CMD ["n8n", "start", "--port", "$PORT"]
