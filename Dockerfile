FROM debian:buster

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y \
    python \
    python-pip \
    openssl \
    curl \
    wget \
    sudo \
    && rm -rf /var/lib/apt/lists/*

# Add vulnerable package
RUN pip install flask==0.12

CMD ["python", "-c", "print('Hello Vulnerable World!')"]
