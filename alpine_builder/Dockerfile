FROM alpine:3

RUN apk add --no-cache \
    bash \
    wget \
    musl-dev \
    g++ \
    make \
    cmake \
    pkgconfig \
    ninja-is-really-ninja \
    perl \
    linux-headers \
    \
    autoconf \
    automake \
    bind-tools \
    bison \
    coreutils \
    file \
    findutils \
    gperf \
    patch

ARG ZLIB=zlib-1.3.1
RUN wget https://zlib.net/$ZLIB.tar.gz \
    && tar xvf $ZLIB.tar.gz && rm $ZLIB.tar.gz && cd $ZLIB\
    && ./configure --static && make -j $(nproc) && make install \
    && cd .. && rm -rf $ZLIB

ARG OPENSSL=openssl-3.4.1
RUN wget https://github.com/openssl/openssl/releases/download/$OPENSSL/$OPENSSL.tar.gz \
    && tar xvf $OPENSSL.tar.gz && rm $OPENSSL.tar.gz && cd $OPENSSL \
    && ./config --openssldir=/usr/lib/ssl no-shared zlib && make -j $(nproc) && make install_sw \
    && cd .. && rm -rf $OPENSSL

ARG CURL=curl-8.11.1
ARG CURL_VER=8_11_1
RUN wget https://github.com/curl/curl/releases/download/curl-$CURL_VER/$CURL.tar.xz \
    && tar xvf $CURL.tar.xz && rm $CURL.tar.xz && cd $CURL \
    && cmake -GNinja -Bbuild \
            -D CMAKE_BUILD_TYPE=Release \
            -D BUILD_SHARED_LIBS=OFF \
            -D BUILD_CURL_EXE=OFF \
            -D BUILD_TESTING=OFF \
            -D SSL_ENABLED=ON \
            -D CURL_CA_PATH=auto \
            -D CURL_USE_OPENSSL=ON \
            . \
    && cmake --build build --parallel \
    && cmake --build build --target install \
    && cd ../.. && rm -rf $CURL
