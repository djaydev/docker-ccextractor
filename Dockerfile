# djaydev/ccextractor:latest

# complication stage
FROM ubuntu AS builder

# install dependencies
RUN apt update
RUN apt install build-essential pkgconf libtesseract-dev libfreetype6 unzip libc6 libleptonica-dev libcurl4-gnutls-dev libglfw3-dev libglew-dev libwebp-dev libgif-dev software-properties-common wget -y

# compile ccextractor
RUN wget -O master.zip https://codeload.github.com/CCExtractor/ccextractor/zip/master && \
    unzip master.zip 'ccextractor-master/linux/*' -d /opt/ && \
    unzip master.zip 'ccextractor-master/src/*' -d /opt/ && \
    cd /opt/ccextractor-master/linux/ && \
    ./build

# release stage
FROM ubuntu

# install dependencies
RUN apt update && \
    apt install libfreetype6 libc6 libutf8proc2 libtesseract4 libpng16-16 liblept5 -y && \
    # cleanup
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf \
    	/tmp/* \
    	/var/lib/apt/lists/* \
    	/var/tmp/*

# copy ccextractor from complication stage
COPY --from=builder /opt/ccextractor-master/linux/ccextractor /usr/local/bin
