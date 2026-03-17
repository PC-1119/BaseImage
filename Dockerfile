FROM ubuntu:18.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y \
    python2 \
    python-pip \
    openssl \
    curl \
    wget \
    bash \
    sudo \
    && rm -rf /var/lib/apt/lists/*

CMD ["python2", "-c", "print('Hello Vulnerable World!')"]
