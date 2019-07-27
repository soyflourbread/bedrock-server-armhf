FROM debian:latest AS builder
MAINTAINER Black Hat <bhat@encom.eu.org>

WORKDIR /root/

RUN apt-get update && apt-get install -y python3 python3-ply git

RUN git clone --recursive https://github.com/minecraft-linux/mcpelauncher-manifest.git mcpelauncher && cd mcpelauncher && \
    cd mcpelauncher-linux-bin && \
    git checkout armhf && \
    cd .. && \
    cd minecraft-symbols/tools && \
    python3 process_headers.py --armhf && \
    cd ../../ && \
    mkdir build && cd build && \
    cmake -DBUILD_CLIENT=OFF -DCMAKE_INSTALL_PREFIX=/app .. && \
    cmake --build . --target all && \
    make install

FROM debian:latest

WORKDIR /app/

COPY --from=builder /app /

ENTRYPOINT [/app/bin/mcpelauncher-server, -dg, /data/mcpe, -dd, /data/]
