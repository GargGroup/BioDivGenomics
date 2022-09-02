FROM docker.io/ubuntu:20.04

ENV FASTK_COMMIT=f18a4e6d2207539f7b84461daebc54530a9559b0
ENV FASTK_DEST_DIR=/usr/local/bin/

# Install dependencies.
RUN apt update
RUN apt install -y \
  gcc \
  git \
  libbz2-dev \
  libcurl4-gnutls-dev \
  liblzma-dev \
  make \
  zlib1g-dev
# Build and install FASTK.
WORKDIR /build/
RUN git clone https://github.com/thegenemyers/FASTK.git
WORKDIR /build/FASTK/
RUN git checkout "${FASTK_COMMIT}"
RUN make
RUN make install DEST_DIR="${FASTK_DEST_DIR}"

WORKDIR /data/
CMD ["FastK"]
