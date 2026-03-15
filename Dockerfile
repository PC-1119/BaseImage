FROM ubuntu:18.04

RUN apt-get update && \
    apt-get install -y \
    python3 \
    python3-pip \
    curl \
    wget \
    openssl \
    libssl-dev \
    git

# install old vulnerable python packages
RUN pip3 install flask==1.0.2 requests==2.19.0

CMD ["python3"]
