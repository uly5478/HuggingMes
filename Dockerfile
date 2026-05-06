# HuggingMes - Hermes Agent Gateway for Hugging Face Spaces
# Browser automation enabled (Chromium + Playwright + CDP)

ARG HERMES_AGENT_VERSION=latest
FROM nousresearch/hermes-agent:${HERMES_AGENT_VERSION}

USER root

# ── System dependencies ──
# The base image already has: python3, nodejs, npm, ripgrep, ffmpeg, git,
# openssh-client, docker-cli, tini, build-essential, gcc, python3-dev, libffi-dev
# We add: curl, jq, and Chromium/Playwright browser dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    jq \
    # Chromium runtime dependencies for Playwright/CDP
    libnss3 \
    libnspr4 \
    libatk1.0-0t64 \
    libatk-bridge2.0-0t64 \
    libcups2t64 \
    libdrm2 \
    libdbus-1-3 \
    libxkbcommon0 \
    libatspi2.0-0t64 \
    libxcomposite1 \
    libxdamage1 \
    libxfixes3 \
    libxrandr2 \
    libgbm1 \
    libpango-1.0-0 \
    libcairo2 \
    libasound2t64 \
    libwayland-client0 \
    fonts-liberation \
    fonts-noto-color-emoji \
    xdg-utils \
    wget \
    && rm -rf /var/lib/apt/lists/*

# ── Python dependencies ──
COPY requirements.txt /tmp/requirements.txt
RUN uv pip install --python /opt/hermes/.venv/bin/python --no-cache-dir \
    -r /tmp/requirements.txt \
    && rm /tmp/requirements.txt

# ── Install Playwright Chromium browser ──
ENV PLAYWRIGHT_BROWSERS_PATH=/opt/hermes/.playwright
RUN /opt/hermes/.venv/bin/python -m playwright install chromium --with-deps \
    && chmod -R a+rX /opt/hermes/.playwright

# ── Install agent-browser CLI + download its own Chrome ──
RUN npm install -g agent-browser \
    && agent-browser install

# ── Copy application files ──
COPY --chown=hermes:hermes start.sh /opt/huggingmes/start.sh
COPY --chown=hermes:hermes health-server.js /opt/huggingmes/health-server.js
COPY --chown=hermes:hermes hermes-sync.py /opt/huggingmes/hermes-sync.py
COPY --chown=hermes:hermes cloudflare-proxy-setup.py /opt/huggingmes/cloudflare-proxy-setup.py
COPY --chown=hermes:hermes cloudflare-keepalive-setup.py /opt/huggingmes/cloudflare-keepalive-setup.py

RUN chmod +x \
    /opt/huggingmes/start.sh \
    /opt/huggingmes/hermes-sync.py \
    /opt/huggingmes/cloudflare-proxy-setup.py \
    /opt/huggingmes/cloudflare-keepalive-setup.py

# ── Environment ──
ENV HERMES_HOME=/opt/data \
    HUGGINGMES_APP_DIR=/opt/huggingmes \
    HERMES_AGENT_VERSION=${HERMES_AGENT_VERSION} \
    PYTHONUNBUFFERED=1 \
    TERM=xterm-256color

EXPOSE 7861

HEALTHCHECK --interval=30s --timeout=5s --start-period=90s \
  CMD curl -fsS http://localhost:7861/health || exit 1

CMD ["/opt/huggingmes/start.sh"]
