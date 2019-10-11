# djaydev/ccextractor:latest

# complication stage
FROM ubuntu:18.04 AS builder

# install dependencies
RUN apt update
RUN apt install build-essential pkgconf cmake automake autoconf git software-properties-common \
    libtesseract-dev libfreetype6 tesseract-ocr-eng libleptonica-dev libcurl4-gnutls-dev libglfw3-dev libglew-dev libwebp-dev libgif-dev -y

# compile ccextractor
RUN git clone https://github.com/CCExtractor/ccextractor.git && \
    cd ccextractor/linux && \
    ./autogen.sh && \
    ./configure --enable-ocr && \
    make

# release stage
FROM ubuntu:18.04

# install dependencies
RUN apt update && \
    apt install libfreetype6 libutf8proc2 tesseract-ocr -y && \
    # cleanup
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf \
    	/tmp/* \
    	/var/lib/apt/lists/* \
    	/var/tmp/*

# copy ccextractor from complication stage
COPY --from=builder /ccextractor/linux/ccextractor /usr/local/bin
