# Container image that runs your code
FROM alpine:3.18

# Install necessary dependencies
RUN apk update && \
    apk add --no-cache wget bash ca-certificates-bundle libgcc libssl3 libstdc++ zlib icu-libs && \
    rm -rf /var/cache/apk/*

# Download and install .NET Core SDK
RUN wget -q https://dot.net/v1/dotnet-install.sh -O dotnet-install.sh && \
    chmod +x dotnet-install.sh && \
    ./dotnet-install.sh --channel 9.0 --install-dir /usr/share/dotnet && \
    rm dotnet-install.sh

# Add .NET to the PATH environment variable
ENV PATH="$PATH:/usr/share/dotnet"

# Copies your code file from your action repository to the filesystem path `/` of the container
COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

# Code file to execute when the docker container starts up (`entrypoint.sh`)
ENTRYPOINT ["/entrypoint.sh"]