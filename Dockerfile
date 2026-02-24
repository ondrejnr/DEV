# Use Ubuntu as the base for a familiar dev environment
FROM ubuntu:22.04

# Prevent interactive prompts during install
ENV DEBIAN_FRONTEND=noninteractive

# Install essential tools: Ansible, Kubectl, Curl, Git
RUN apt-get update && apt-get install -y \
    curl \
    git \
    vim \
    ansible \
    gpg \
    && curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.29/deb/Release.key | gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg \
    && echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.29/deb/ /' | tee /etc/apt/sources.list.d/kubernetes.list \
    && apt-get update && apt-get install -y kubectl \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Set the working directory
WORKDIR /home/dev-backup

# Copy EVERYTHING from your current directory into the image
COPY . .

# Set a default command to keep the container reachable if run
CMD ["/bin/bash"]
