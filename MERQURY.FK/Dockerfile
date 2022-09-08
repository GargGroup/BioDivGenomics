FROM docker.io/ubuntu:20.04

ENV MERQURY_FK_COMMIT=8f3ab706e4cf4d7b7d1dfe5739859e3ebd26c494
ENV MERQURY_FK_DEST_DIR=/usr/local/bin/

# Install dependencies.
RUN apt update
RUN apt install -y \
  gcc \
  git \
  make \
  zlib1g-dev
# Build and install.
WORKDIR /build/
RUN git clone https://github.com/thegenemyers/MERQURY.FK.git
WORKDIR /build/MERQURY.FK/
RUN git checkout "${MERQURY_FK_COMMIT}"
RUN make
RUN make install DEST_DIR="${MERQURY_FK_DEST_DIR}"

WORKDIR /data/
CMD ["HAPmaker"]
