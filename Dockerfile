# Container image that runs your code
FROM alpine:3.10

# Install prerequisites
RUN apt-get update && \
    apt-get install -y wget apt-transport-https && \
    rm -rf /var/lib/apt/lists/*

# Install the latest stable version of .NET Core SDK
RUN wget -q https://dot.net/v1/dotnet-install.sh -O dotnet-install.sh && \
    chmod +x dotnet-install.sh && \
    ./dotnet-install.sh --install-dir /usr/share/dotnet --version latest && \
    ln -s /usr/share/dotnet/dotnet /usr/bin/dotnet && \
    rm dotnet-install.sh

# Copies your code file from your action repository to the filesystem path `/` of the container
COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

# Code file to execute when the docker container starts up (`entrypoint.sh`)
ENTRYPOINT ["/entrypoint.sh"]