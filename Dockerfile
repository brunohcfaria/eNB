FROM ubuntu:focal
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    git \
    iproute2 \
    python3-pip \
    libsctp-dev \
    swig \
    python3-pyscard \
    net-tools \
    tcpdump \
    libpcsclite-dev \
    bridge-utils

# RUN apt-get update && apt-get install -y resolvconf

RUN sysctl -w net.ipv4.ip_forward=1
# RUN echo "nameserver 8.8.8.8">/etc/resolvconf/resolv.conf.d/head
# RUN service resolvconf restart
# RUN echo "alias toollog='journalctl -fu tool'">>/root/.bashrc
# RUN source /root/.bashrc

WORKDIR /usr/src/eNB

COPY requirements.txt .

RUN pip3 install -r requirements.txt

COPY docker-entrypoint.sh /usr/local/bin
RUN chmod +x /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT ["docker-entrypoint.sh"]
