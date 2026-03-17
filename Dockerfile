# Intentionally vulnerable base image (old + EOL)
FROM ubuntu:18.04

ENV DEBIAN_FRONTEND=noninteractive

# Install outdated and vulnerable packages
RUN apt-get update && \
    apt-get install -y \
    python2 \
    python-pip \
    openssl=1.1.1-1ubuntu2.1~18.04.20 \
    libssl1.1=1.1.1-1ubuntu2.1~18.04.20 \
    curl \
    wget \
    bash \
    sudo \
    && apt-get upgrade -y \
    && rm -rf /var/lib/apt/lists/*

# Add test file
RUN echo "print('Hello Vulnerable World!')" > /hello.py

CMD ["python2", "/hello.py"]
