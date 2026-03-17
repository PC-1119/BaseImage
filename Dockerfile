FROM ubuntu:18.04

ENV DEBIAN_FRONTEND=noninteractive

RUN sed -i 's/archive.ubuntu.com/old-releases.ubuntu.com/g' /etc/apt/sources.list && \
    sed -i 's/security.ubuntu.com/old-releases.ubuntu.com/g' /etc/apt/sources.list

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

RUN pip install flask==0.12

CMD ["python2", "-c", "print('Hello Vulnerable World!')"]
