# 1. Define the base image. We want a lightweight Linux distribution!
# Hint: We are looking for the latest version of Alpine.
_____ ubuntu:latest 

# 2. Set an environment variable for the DIAMOND version so it's easy to update later.
# Call the variable DIAMOND_VERSION and set it to 2.2.2
_____ DIAMOND_VERSION=2.2.2

# 3. Install the required dependencies.
_____ apt-get update && apt-get install -y wget

# 4. Download, extract, and configure DIAMOND.
# Fill in the missing Linux commands to make this chain work!
_____ wget http://github.com/bbuchfink/diamond/releases/download/v${DIAMOND_VERSION}/diamond-linux64.tar.gz && \
    tar xzf diamond-linux64.tar.gz && \
    ln -s /diamond /usr/local/sbin/diamond

# 5. Set the default working directory where users will mount their data.
# Let's use a folder called /data
_____ /data


# 6. Set the default command that runs when the container starts.
# We want it to run the DIAMOND help menu.
_____ ["diamond", "help"]