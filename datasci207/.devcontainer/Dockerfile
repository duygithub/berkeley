# Start with a Microsoft Python dev container image
FROM mcr.microsoft.com/devcontainers/python:3.10

# Install dependencies for downloading Quarto
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends curl ca-certificates

# Download and install Quarto (Check for the latest version URL if needed)
ARG QUARTO_VERSION="1.4.551"
RUN curl -LO https://github.com/quarto-dev/quarto-cli/releases/download/v${QUARTO_VERSION}/quarto-${QUARTO_VERSION}-linux-amd64.deb \
    && dpkg -i quarto-${QUARTO_VERSION}-linux-amd64.deb \
    && rm quarto-${QUARTO_VERSION}-linux-amd64.deb

# Switch to the default non-root user (vscode) to install user-level tools
USER vscode

# Install TinyTeX for PDF generation via Quarto
RUN quarto install tinytex --update-path
