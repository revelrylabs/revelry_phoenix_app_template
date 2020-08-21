FROM elixir:1.10.4

# Configure apt
ENV DEBIAN_FRONTEND=noninteractive

# NodeJS
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -

RUN apt-get update && \
  apt-get -y install --no-install-recommends \
  apt-utils build-essential inotify-tools locales nodejs

# Install git, process tools, lsb-release (common in install instructions for CLIs)
RUN apt-get -y install git procps lsb-release

RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=en_US.UTF-8

ENV LANG="en_US.UTF-8"

# Clean up
RUN apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

ENV DEBIAN_FRONTEND=dialog

ENV SHELL /bin/bash
