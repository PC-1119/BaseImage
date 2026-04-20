FROM ubuntu:20.04

# Avoid interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Install system packages (no version pinning)
RUN apt-get update && \
    apt-get install -y \
    python3 \
    python3-pip \
    curl \
    wget \
    git \
    openssl \
    libssl-dev \
    && rm -rf /var/lib/apt/lists/*

# Install old Python packages with known CVEs
RUN pip3 install \
    flask==1.0.2 \
    requests==2.19.0 \
    django==2.2.0

# Add a test file
RUN echo "print('Hello Vulnerable World!')" > /hello.py
