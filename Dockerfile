# djaydev/ccextractor:latest

# complication stage
FROM ubuntu:18.04 AS builder

# install dependencies
RUN apt update
RUN apt install build-essential pkgconf cmake automake autoconf unzip wget git software-properties-common \
    libtesseract-dev libfreetype6 tesseract-ocr-eng libleptonica-dev libcurl4-gnutls-dev libglfw3-dev libglew-dev libwebp-dev libgif-dev -y

# compile ccextractor
RUN wget -O master.zip https://codeload.github.com/CCExtractor/ccextractor/zip/master
RUN unzip master.zip 'ccextractor-master/linux/*' -d /opt/ && \
		unzip master.zip 'ccextractor-master/src/*' -d /opt/ && \
		cd /opt/ccextractor-master/linux/ && \
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
COPY --from=builder /opt/ccextractor-master/linux/ccextractor /usr/local/bin
