# 1. Define the base image. We want a lightweight Linux distribution!
# Hint: We are looking for the latest version of Alpine.
______ alpine:latest

# 2. Set an environment variable for the FastQC version so it's easy to update later.
# Call the variable FASTQC_VERSION and set it to 0.12.1
______ FASTQC_VERSION=0.12.1

# 3. Install the required dependencies.
# Hint: In Alpine Linux, the package manager is 'apk', and you want to 'add' packages 
# without caching them to save space.
______ apk add --no-cache \
    openjdk17-jre \
    perl \
    wget \
    unzip \
    fontconfig \
    ttf-dejavu

# 4. Install MultiQC
# Hint: Use the python package manager to install 'multiqc'
______ pip install --break-system-packages multiqc

# 4. Download, extract, and configure FastQC.
# Fill in the missing Linux commands to make this chain work!
RUN wget https://www.bioinformatics.babraham.ac.uk/projects/fastqc/fastqc_v${FASTQC_VERSION}.zip && \
    ______ fastqc_v${FASTQC_VERSION}.zip && \
    ______ fastqc_v${FASTQC_VERSION}.zip && \
    ______ 755 /FastQC/fastqc && \
    ln -s /FastQC/fastqc /usr/local/bin/fastqc

# 5. Set the default working directory where users will mount their data.
# Let's use a folder called /data
______ /data

# 6. Set the default command that runs when the container starts.
# We want it to run the fastqc help menu.
______ ["fastqc", "--help"]