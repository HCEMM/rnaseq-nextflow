# 1. Define the lightweight base image
 FROM alpine:latest

# 2. Set the version variable
ENV TRIMMOMATIC_VERSION=0.39

# 3. Install system dependencies
# Hint: Trimmomatic is written in Java, so we need the Java Runtime Environment (JRE).
# We also need tools to download and extract the archive.
RUN apk add --no-cache \
    openjdk17-jre \
    wget \
    unzip

# 4. Download and install Trimmomatic
# Hint: We are downloading a zip file. You need to extract it, delete the zip file, 
# and then move the .jar file to /usr/local/bin so the system knows where it is.
RUN wget http://www.usadellab.org/cms/uploads/supplementary/Trimmomatic/Trimmomatic-${TRIMMOMATIC_VERSION}.zip && \
    unzip Trimmomatic-${TRIMMOMATIC_VERSION}.zip && \
    rm Trimmomatic-${TRIMMOMATIC_VERSION}.zip && \
    mv Trimmomatic-${TRIMMOMATIC_VERSION}/trimmomatic-${TRIMMOMATIC_VERSION}.jar /usr/local/bin/trimmomatic.jar

# 5. Set the default working directory
WORKDIR /data

# 6. Set the default command
# Hint: Because it's a Java application, you don't just call its name. 
# You have to tell Java to run the .jar file!
CMD ["java", "-jar", "/usr/local/bin/trimmomatic.jar"]