# 1. Define the base image. Let's switch to a lightweight Debian image!
_____ ubuntu:22.04

# 2. Set the version variable for Salmon
_____ SALMON_VERSION=1.11.4

# 3. Install system dependencies
# Hint: Debian uses 'apt-get' instead of 'apk'. 
# You always need to run an 'update' before you 'install'!
_____ apt-get update && \
    apt-get install -y wget tar locales && \
    locale-gen en_US.UTF-8 && \
    update-locale LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8 && \
    rm -rf /var/lib/apt/lists/*


_____ LANG=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8	
# 4. Download and extract the pre-compiled Salmon binary
# Hint: We are dealing with a .tar.gz (tarball) archive, not a .zip! 
# We need to extract it, then delete the original archive to save space.
_____ wget https://github.com/COMBINE-lab/salmon/releases/download/v${SALMON_VERSION}/salmon-linux-x86_64.tar.gz && \
    tar -xzf salmon-linux-x86_64.tar.gz && \
    rm salmon-linux-x86_64.tar.gz

# 5. Add Salmon to the system PATH
# Instead of moving the files, we can just tell Linux where to look for them!
_____ PATH="/salmon-linux-x86_64/bin:${PATH}"

# 6. Set the default working directory
_____ /data

# 7. Set the default command
_____ ["salmon", "--help"]