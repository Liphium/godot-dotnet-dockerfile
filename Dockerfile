FROM debian:bookworm-slim
LABEL author="info@dunkelgrau.io"

ARG GODOT_VERSION="4.0"
ARG CHANNEL="stable"

RUN apt-get update && apt-get install -y --no-install-recommends \
    libxcursor1 \
    libfontconfig1 \
    ca-certificates \
    git \
    unzip \
    wget \
    zip 


RUN if [ "$CHANNEL" = "stable" ]; then \
    wget -O godot.zip https://github.com/godotengine/godot/releases/download/${GODOT_VERSION}-${CHANNEL}/Godot_v${GODOT_VERSION}-${CHANNEL}_linux.x86_64.zip -q && \
    wget -O godot-templates.tpz https://github.com/godotengine/godot/releases/download/${GODOT_VERSION}-${CHANNEL}/Godot_v${GODOT_VERSION}-${CHANNEL}_export_templates.tpz -q; \
    else \
    wget -O godot.zip https://github.com/godotengine/godot-builds/releases/download/${GODOT_VERSION}-${CHANNEL}/Godot_v${GODOT_VERSION}-${CHANNEL}_linux.x86_64.zip -q && \
    wget -O godot-templates.tpz https://github.com/godotengine/godot-builds/releases/download/${GODOT_VERSION}-${CHANNEL}/Godot_v${GODOT_VERSION}-${CHANNEL}_export_templates.tpz -q; \
    fi && \
    mkdir ~/.cache && \
    mkdir -p ~/.config/godot && \
    unzip godot.zip && \
    mv Godot_v${GODOT_VERSION}-${CHANNEL}_linux.x86_64 /usr/local/bin/godot && \
    unzip godot-templates.tpz && \
    mkdir -p ~/.local/share/godot/export_templates/${GODOT_VERSION}.${CHANNEL} && \
    mv templates/* ~/.local/share/godot/export_templates/${GODOT_VERSION}.${CHANNEL} && \
    rm -fr templates && \
    rm -f godot-templates.tpz && \
    rm -f godot.zip && \
    godot -v -e --headless --quit