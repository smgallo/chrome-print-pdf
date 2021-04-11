FROM debian:stable-slim

LABEL name="chrome-headless-html-to-pdf"
LABEL author="Steve Gallo <z3gallo@gmail.com>"
LABEL description="Use headless chrome to generate a PDF from an HTML file"

# Chromium version to use. See https://www.chromium.org/getting-involved/download-chromium
# ARG REVISION=678702
ARG REVISION=843831

RUN apt-get update && \
    apt-get install -y wget unzip apt-transport-https ca-certificates curl gnupg chromium libgbm-dev libxss1 --no-install-recommends --allow-unauthenticated && \
    wget -q -O chrome.zip https://commondatastorage.googleapis.com/chromium-browser-snapshots/Linux_x64/${REVISION}/chrome-linux.zip && \
    unzip chrome.zip && \
    rm chrome.zip && \
    ln -sf ${PWD}/chrome-linux/chrome /usr/bin/chromium && \
    ln -sf /usr/bin/chromium /usr/bin/chromium-browser && \
    groupadd -r chrome && useradd -r -g chrome -G audio,video chrome && \
    mkdir -p /home/chrome/reports && \
    chown -R chrome:chrome /home/chrome &&\
    apt-get autoremove wget unzip -y

COPY entrypoint.sh /usr/bin/entrypoint

# Drop to cli
ENTRYPOINT ["entrypoint"]
