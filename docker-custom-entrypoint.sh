#!/bin/sh

# Exportar el NODE_PATH para que los módulos personalizados se resuelvan
export NODE_PATH=/opt/n8n-custom-nodes/node_modules:$NODE_PATH

print_banner() {
    echo "----------------------------------------"
    echo "n8n Puppeteer Node - Environment Details"
    echo "----------------------------------------"
    echo "Node.js version: $(node -v)"
    echo "n8n version: $(n8n --version)"

    CHROME_VERSION=$("$PUPPETEER_EXECUTABLE_PATH" --version 2>/dev/null || echo "Chromium not found")
    echo "Chromium version: $CHROME_VERSION"

    PUPPETEER_PATH="/opt/n8n-custom-nodes/node_modules/n8n-nodes-puppeteer"
    if [ -f "$PUPPETEER_PATH/package.json" ]; then
        PUPPETEER_VERSION=$(node -p "require('$PUPPETEER_PATH/package.json').version")
        echo "n8n-nodes-puppeteer version: $PUPPETEER_VERSION"
        CORE_PUPPETEER_VERSION=$(cd "$PUPPETEER_PATH" && node -e "try { const version = require('puppeteer/package.json').version; console.log(version); } catch(e) { console.log('not found'); }")
        echo "Puppeteer core version: $CORE_PUPPETEER_VERSION"
    else
        echo "n8n-nodes-puppeteer: not installed"
    fi

    echo "Puppeteer executable path: $PUPPETEER_EXECUTABLE_PATH"
    echo "----------------------------------------"
}

# Añadir custom nodes a N8N_CUSTOM_EXTENSIONS
if [ -n "$N8N_CUSTOM_EXTENSIONS" ]; then
    export N8N_CUSTOM_EXTENSIONS="/opt/n8n-custom-nodes:${N8N_CUSTOM_EXTENSIONS}"
else
    export N8N_CUSTOM_EXTENSIONS="/opt/n8n-custom-nodes"
fi

# Add BOTH custom-nodes **and** global modules to NODE_PATH
export NODE_PATH=/usr/local/lib/node_modules:/opt/n8n-custom-nodes/node_modules:$NODE_PATH

print_banner

# Ejecutar el entrypoint original de n8n
exec /docker-entrypoint.sh "$@"

