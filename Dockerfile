FROM debian:latest
MAINTAINER Black Hat <bhat@encom.eu.org>

RUN apt-get update && apt-get install python3 python3-ply && apt-get clean

RUN git clone --recursive https://github.com/minecraft-linux/mcpelauncher-manifest.git mcpelauncher && cd mcpelauncher && \
    cd mcpelauncher-linux-bin && \
    git checkout armhf && \
    cd .. && \
    cd minecraft-symbols/tools && \
    python3 process_headers.py --armhf && \
    cd ../../ && \
    mkdir build && cd build && \
    cmake -DBUILD_CLIENT=OFF .. && \
    make -j3

