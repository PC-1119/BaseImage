#
# Minimal Python 3.11 slim base image
#

FROM debian:trixie-slim

# Prefer local Python over system
ENV PATH=/usr/local/bin:$PATH
ENV LANG=C.UTF-8
ENV PYTHONDONTWRITEBYTECODE=1

# Build-time dependencies (for compiling Python)
ARG BUILD_DEPS=" \
    gcc \
    make \
    wget \
    gnupg \
    dpkg-dev \
    libbz2-dev \
    libffi-dev \
    libgdbm-dev \
    liblzma-dev \
    libncursesw5-dev \
    libreadline-dev \
    libsqlite3-dev \
    libssl-dev \
    tk-dev \
    uuid-dev \
    xz-utils \
    zlib1g-dev \
"

# Runtime essentials
RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        tzdata \
        netbase \
    ; \
    rm -rf /var/lib/apt/lists/*

# Python version info
ENV PYTHON_VERSION=3.11.15
ENV PYTHON_SHA256=272179ddd9a2e41a0fc8e42e33dfbdca0b3711aa5abf372d3f2d51543d09b625
ENV GPG_KEY=A035C8C19219BA821ECEA86B64E628F8D684696D

# Build and install Python
RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends $BUILD_DEPS; \
    savedAptMark="$(apt-mark showmanual)"; \
    \
    wget -O python.tar.xz "https://www.python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tar.xz"; \
    echo "$PYTHON_SHA256 *python.tar.xz" | sha256sum -c -; \
    mkdir -p /usr/src/python; \
    tar -xf python.tar.xz -C /usr/src/python --strip-components=1; \
    rm python.tar.xz; \
    \
    cd /usr/src/python; \
    gnuArch="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)"; \
    ./configure --build="$gnuArch" \
        --enable-loadable-sqlite-extensions \
        --enable-optimizations \
        --enable-shared \
        --with-ensurepip; \
    make -j"$(nproc)"; \
    make install; \
    \
    # Cleanup build files and dependencies
    cd /; \
    rm -rf /usr/src/python; \
    apt-get purge -y --auto-remove $BUILD_DEPS; \
    apt-get clean; \
    rm -rf /var/lib/apt/lists/*; \
    \
    # Upgrade pip/setuptools/wheel
    python3 -m ensurepip; \
    python3 -m pip install --no-cache-dir --upgrade pip setuptools wheel

# Create symlinks for expected names
RUN set -eux; \
    for src in python3 pip3 python3-config; do \
        dst="$(echo "$src" | tr -d 3)"; \
        if [ -e "/usr/local/bin/$src" ] && [ ! -e "/usr/local/bin/$dst" ]; then \
            ln -svT "$src" "/usr/local/bin/$dst"; \
        fi; \
    done

# Default working directory
WORKDIR /app

# Default command
CMD ["python3"]
