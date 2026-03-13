ARG UBI9_VERSION=ubi9-micro:9.1.0-13
ARG NODE_VERSION=16.19.0
FROM docker.io/redhat/ubi9-minimal:9.1.0-1760.1675784957 as build
ARG NODE_VERSION
ENV NODE_ARCH "x64"
ENV SETUP_UTILS "shadow-utils gzip tar zlib expat python3.11 python3.11-libs python3.11-pip openssl openssl-libs libffi"
RUN microdnf install --nodocs $SETUP_UTILS --assumeyes

# Micro image
FROM docker.io/redhat/${UBI9_VERSION}
# Install user and group dependencies
COPY --from=build ["/usr/lib64/libaudit.so.1", "/usr/lib64/libsemanage.so.2", "/usr/lib64/libbz2.so.1", "/usr/lib64/libz.so.1", "/usr/lib64/libcap-ng.so.0", "/usr/lib64/"]
COPY --from=build ["/usr/lib64/libstdc++.so.6", "/usr/lib64/libssl.so.3", "/usr/lib64/libexpat.so.1", "/usr/lib64/libcrypto.so.3", "/usr/lib64/libffi.so.8", "/usr/lib64/"]
COPY --from=build ["/etc/pki/.", "/etc/pki/"]
COPY --from=build ["/usr/sbin/groupadd", "/usr/sbin/useradd", "/usr/sbin/"]

COPY --from=build /usr/lib64/libpython3.11.so.1.0 /usr/lib64/
COPY --from=build /usr/lib/python3.11/. /usr/lib/python3.11/
COPY --from=build /usr/lib64/python3.11/. /usr/lib64/python3.11/
COPY --from=build /usr/bin/python3.11 /usr/bin/python3.11
COPY --from=build /usr/bin/pip3.11 /usr/bin/pip3.11

# Create symlinks for python3 and pip3
RUN ln -sf /usr/bin/python3.11 /usr/bin/python3 && ln -sf /usr/bin/pip3.11 /usr/bin/pip3

RUN groupadd -g 999 app \
    && useradd -rm -d /app -s /bin/bash -g root -G 999 -u 999 app \
    && rm /usr/sbin/groupadd \
    && rm /usr/sbin/useradd \
    && rm /usr/lib64/libaudit.so.1 \
    && rm /usr/lib64/libsemanage.so.2 \
    && rm /usr/lib64/libcap-ng.so.0

# Smoke Test
RUN echo "Python Version: "
RUN /usr/bin/python3 --version
