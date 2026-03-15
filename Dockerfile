# Vulnerable custom base image for CI demo
FROM ubuntu:20.04

# Avoid interactive prompts during build
ENV DEBIAN_FRONTEND=noninteractive

# Install outdated system packages (will have vulnerabilities)
RUN apt-get update && \
    apt-get install -y \
    python3=3.8.2-0ubuntu2 \
    python3-pip=20.0.2-5ubuntu1.6 \
    curl \
    wget \
    git \
    openssl=1.1.1f-1ubuntu2.17 \
    libssl-dev=1.1.1f-1ubuntu2.17 \
    && rm -rf /var/lib/apt/lists/*

# Install old Python packages with known CVEs
RUN pip3 install \
    flask==1.0.2 \
    requests==2.19.0 \
    django==2.2.0

# Add a test file to make it non-empty
RUN echo "print('Hello Vulnerable World!')" > /hello.py

# Default command
CMD ["python3", "/hello.py"]
