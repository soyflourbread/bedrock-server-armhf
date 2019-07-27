FROM debian:latest AS builder
MAINTAINER Black Hat <bhat@encom.eu.org>

WORKDIR /root/

RUN apt-get update && apt-get install -y python3 python3-ply git cmake gcc g++

RUN git clone --recursive https://github.com/minecraft-linux/mcpelauncher-manifest.git mcpelauncher
RUN cd mcpelauncher/mcpelauncher-linux-bin && \
    git checkout armhf && \
    cd ..
RUN cd mcpelauncher/minecraft-symbols/tools && \
    python3 process_headers.py --armhf && \
    cd ../../
RUN cd mcpelauncher && \
    mkdir build && cd build && \
    cmake -DBUILD_CLIENT=OFF -DCMAKE_INSTALL_PREFIX=/app .. && \
    cmake --build . --target all
RUN cd mcpelauncher/build && \
    make install

FROM debian:latest

WORKDIR /app/

COPY --from=builder /app /app

ENV OPENSSL_armcap=0

CMD ["/app/bin/mcpelauncher-server","-dg","/data/mcpe","-dd","/data/"]
