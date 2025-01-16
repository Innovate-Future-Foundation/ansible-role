# Use Ubuntu 24.04 as the base image
FROM ubuntu:24.04

# Set the environment variable to avoid interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Update the package list, install necessary packages, and configure SSH
RUN apt-get update && \
    apt-get install -y --no-install-recommends tzdata openssh-server python3 python3-pip && \
    apt-get clean 

RUN mkdir -p /root/.ssh /var/run/sshd && \
    chmod 700 /root/.ssh && \
    sed -i 's/^#PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config

# Expose necessary ports
EXPOSE 22 8080

# Start the SSH service by default
CMD ["sh", "-c", "cat /root/id_rsa.pub >> /root/.ssh/authorized_keys && chmod 600 /root/.ssh/authorized_keys && service ssh start && sleep infinity"]