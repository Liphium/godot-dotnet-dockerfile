FROM --platform=amd64 mcr.microsoft.com/dotnet/sdk:8.0-noble AS builder

ARG GODOT_VERSION="4.6"
ARG CHANNEL="stable"

RUN apt-get update && apt-get install -y --no-install-recommends \
	libxcursor1 \
	libfontconfig1 \
	ca-certificates \
	git \
	unzip \
	wget \
	zip

RUN wget -O godot.zip https://github.com/godotengine/godot/releases/download/${GODOT_VERSION}-${CHANNEL}/Godot_v${GODOT_VERSION}-${CHANNEL}_mono_linux_x86_64.zip -q

RUN wget -O godot-templates.tpz https://github.com/godotengine/godot/releases/download/${GODOT_VERSION}-${CHANNEL}/Godot_v${GODOT_VERSION}-${CHANNEL}_mono_export_templates.tpz -q;

RUN mkdir -p ~/.config/godot
RUN unzip godot.zip
RUN mv Godot_v${GODOT_VERSION}-${CHANNEL}_mono_linux_x86_64 /opt/godot
RUN ln -s /opt/godot/Godot_v${GODOT_VERSION}-${CHANNEL}_mono_linux.x86_64 /usr/local/bin/godot
RUN unzip godot-templates.tpz
RUN mkdir -p ~/.local/share/godot/export_templates/${GODOT_VERSION}.${CHANNEL}.mono
RUN mv templates/* ~/.local/share/godot/export_templates/${GODOT_VERSION}.${CHANNEL}.mono
RUN rm -fr templates
RUN rm -f godot-templates.tpz
RUN rm -f godot.zip
RUN chmod +x /opt/godot/Godot_v${GODOT_VERSION}-${CHANNEL}_mono_linux.x86_64
RUN godot -v -e --headless --quit
