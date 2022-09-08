FROM docker.io/ubuntu:20.04

ENV GENE_SCOPE_FK_COMMIT=380815c420f50171f9234a0fd1ff426b39829b91
ENV GENE_SCOPE_FK_DEST_DIR=/usr/local/bin/

# Install dependencies.
ENV DEBIAN_FRONTEND=noninteractive
RUN apt update
RUN apt install -y \
  git \
  python3 \
  r-base \
  r-base-dev
RUN R --version

# Download the source.
WORKDIR /build/
RUN git clone https://github.com/thegenemyers/GENESCOPE.FK.git
WORKDIR /build/GENESCOPE.FK/
RUN git checkout "${GENE_SCOPE_FK_COMMIT}"

# Install.
COPY .Rprofile ~/
COPY install_all.R .
RUN Rscript install_all.R
RUN Rscript -e "installed.packages()" | grep GeneScopeFK
RUN cp -p GeneScopeFK.R "${GENE_SCOPE_FK_DEST_DIR}"

WORKDIR /data/
CMD ["GeneScopeFK.R"]
