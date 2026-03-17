# Vulnerable Alpine 3.4 (old, unpatched)
FROM alpine:3.4

# Update repo index and install basic packages
RUN apk update && apk add --no-cache \
    bash \
    curl \
    wget \
    openssl \
    sudo \
    ca-certificates

# Add a simple test file
RUN echo "echo 'Hello Vulnerable OS!'" > /hello.sh
CMD ["bash", "/hello.sh"]
