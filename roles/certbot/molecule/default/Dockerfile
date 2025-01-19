FROM ubuntu:22.04

# Prevent apt from prompting for input
ENV DEBIAN_FRONTEND=noninteractive

# Create required directories
RUN mkdir -p /usr/share/man/man1 \
    && mkdir -p /var/run/sshd

# Update and install required packages
RUN apt-get update \
    && apt-get install -y \
    python3 \
    python3-pip \
    python3-lxml \
    sudo \
    systemd \
    systemd-sysv \
    iproute2 \
    && rm -rf /var/lib/apt/lists/*

# Configure sudo
RUN echo "ALL ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    echo "Defaults !requiretty" >> /etc/sudoers && \
    mkdir -p /etc/sudoers.d && \
    echo "ALL ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/nopasswd && \
    chmod 440 /etc/sudoers.d/nopasswd

# Add hostname entries
RUN echo "127.0.0.1 jenkins-master" >> /etc/hosts && \
    echo "127.0.0.1 jenkins-worker" >> /etc/hosts

# Configure systemd
RUN cd /lib/systemd/system/sysinit.target.wants/ \
    && rm $(ls | grep -v systemd-tmpfiles-setup)

RUN systemctl mask -- \
    tmp.mount \
    etc-hostname.mount \
    etc-hosts.mount \
    etc-resolv.conf.mount \
    swap.target

VOLUME [ "/sys/fs/cgroup" ]
CMD ["/lib/systemd/systemd"]
