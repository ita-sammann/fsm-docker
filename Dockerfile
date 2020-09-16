# Glibc is required for Factorio Server binaries to run
FROM frolvlad/alpine-glibc:alpine-3.12

ENV FACTORIO_VERSION=latest \
    MANAGER_VERSION=0.8.2 \
    ADMIN_USER=admin \
    ADMIN_PASS=factorio \
    RCON_PASS="" \
    COOKIE_ENCRYPTION_KEY=""

VOLUME /opt/fsm-data /opt/factorio/saves /opt/factorio/mods /opt/factorio/config

RUN apk add --no-cache curl tar xz unzip jq

WORKDIR /opt

# Install FSM
RUN curl --location "https://github.com/mroote/factorio-server-manager/releases/download/${MANAGER_VERSION}/factorio-server-manager-linux-${MANAGER_VERSION}.zip" \
         --output /tmp/factorio-server-manager-linux_${MANAGER_VERSION}.zip \
    && unzip /tmp/factorio-server-manager-linux_${MANAGER_VERSION}.zip \
    && rm /tmp/factorio-server-manager-linux_${MANAGER_VERSION}.zip \
    && mv factorio-server-manager fsm

# Install Factorio
RUN curl --location "https://www.factorio.com/get-download/${FACTORIO_VERSION}/headless/linux64" \
         --output /tmp/factorio_${FACTORIO_VERSION}.tar.xz \
    && tar -xf /tmp/factorio_${FACTORIO_VERSION}.tar.xz \
    && rm /tmp/factorio_${FACTORIO_VERSION}.tar.xz

COPY entrypoint.sh /opt

ENTRYPOINT ["/opt/entrypoint.sh"]