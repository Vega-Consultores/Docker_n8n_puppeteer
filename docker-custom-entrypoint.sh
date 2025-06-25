#!/bin/sh

# --- INICIO: Nueva línea CRÍTICA para NODE_PATH ---
# Exportar la ruta de los módulos personalizados para que Node.js los encuentre.
# Esto asegura que 'require('puppeteer')' funcione en los nodos de ejecución de código.
export NODE_PATH=/opt/n8n-custom-nodes/node_modules:$NODE_PATH
# --- FIN: Nueva línea CRÍTICA para NODE_PATH ---

print_banner() {
    echo "----------------------------------------"
    echo "n8n Puppeteer Node - Environment Details"
    echo "----------------------------------------"
    echo "Node.js version: $(node -v)"
    echo "n8n version: $(n8n --version)"

    # Get Chromium version specifically from the path we're using for Puppeteer
    CHROME_VERSION=$("$PUPPETEER_EXECUTABLE_PATH" --version 2>/dev/null || echo "Chromium not found")
    echo "Chromium version: $CHROME_VERSION"

    # Get Puppeteer version if installed
    PUPPETEER_PATH="/opt/n8n-custom-nodes/node_modules/n8n-nodes-puppeteer"
    if [ -f "$PUPPETEER_PATH/package.json" ]; then
        PUPPETEER_VERSION=$(node -p "require('$PUPPETEER_PATH/package.json').version")
        echo "n8n-nodes-puppeteer version: $PUPPETEER_VERSION"

        # Try to resolve puppeteer package from the n8n-nodes-puppeteer directory
        CORE_PUPPETEER_VERSION=$(cd "$PUPPETEER_PATH" && node -e "try { const version = require('puppeteer/package.json').version; console.log(version); } catch(e) { console.log('not found'); }")
        echo "Puppeteer core version: $CORE_PUPPETEER_VERSION"
    else
        echo "n8n-nodes-puppeteer: not installed"
    fi

    echo "Puppeteer executable path: $PUPPETEER_EXECUTABLE_PATH"
    echo "----------------------------------------"
}

# Add custom nodes to the N8N_CUSTOM_EXTENSIONS path (esto es para n8n, no para 'require')
if [ -n "$N8N_CUSTOM_EXTENSIONS" ]; then
    export N8N_CUSTOM_EXTENSIONS="/opt/n8n-custom-nodes:${N8N_CUSTOM_EXTENSIONS}"
else
    export N8N_CUSTOM_EXTENSIONS="/opt/n8n-custom-nodes"
fi

print_banner

# Execute the original n8n entrypoint script
# Este script de entrada original se encargará de lanzar n8n.
exec /docker-entrypoint.sh "$@"
