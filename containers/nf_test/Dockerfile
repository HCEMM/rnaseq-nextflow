# Use the latest Ubuntu LTS as the base image
FROM ubuntu:24.04

# Prevent interactive prompts during apt installations (e.g., timezone selection)
ENV DEBIAN_FRONTEND=noninteractive

# 1. Update system and install core prerequisites
# Both Nextflow and nf-test require Java (17 is recommended). 
# curl/wget are needed for downloading the binaries.
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    software-properties-common \
    openjdk-17-jre-headless \
    curl \
    wget \
    git \
    bash \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# 2. Install Apptainer via the official Ubuntu PPA
RUN add-apt-repository -y ppa:apptainer/ppa && \
    apt-get update && \
    apt-get install -y --no-install-recommends apptainer && \
    rm -rf /var/lib/apt/lists/*

# 3. Install Nextflow
# We download the install script, execute it, and move the binary to our PATH
RUN curl -s https://get.nextflow.io | bash && \
    mv nextflow /usr/local/bin/ && \
    chmod +x /usr/local/bin/nextflow

# 4. Install nf-test
# Same process as Nextflow, using the official Askimed install script
RUN curl -fsSL https://get.nf-test.com | bash && \
    mv nf-test /usr/local/bin/ && \
    chmod +x /usr/local/bin/nf-test

# 5. Pre-download dependencies and verify installations
# Running these commands during the build phase ensures Nextflow and nf-test 
# download their internal JAR files now, rather than at runtime.
RUN nextflow -v && \
    nf-test version && \
    apptainer --version

# Set a default working directory
WORKDIR /workspace

# Default command
CMD ["/bin/bash"]