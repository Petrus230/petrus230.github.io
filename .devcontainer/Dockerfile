ARG VARIANT=dev-3.4-bookworm
FROM mcr.microsoft.com/devcontainers/ruby:${VARIANT}

USER root

# ENV Variables required by Jekyll
ENV LANG=en_US.UTF-8   \
    LANGUAGE=en_US:en  \
    TZ=Etc/UTC         \
    LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8   \
    LANGUAGE=en_US

RUN apt-get update && export DEBIAN_FRONTEND=noninteractive &&     \
    apt-get -y install --no-install-recommends                     \
    build-essential                                                \
    inotify-tools                                                  \
    procps                                                         \
    zlib1g-dev                                                     \
    libffi-dev

RUN gem update --system
# https://github.com/ntkme/sass-embedded-host-ruby/issues/130
RUN chown -R vscode:vscode /usr/local/bundle &&  \
    rm -rf /usr/local/rvm/gems/default 

COPY scripts/post-create.sh /usr/local/post-create.sh
# Set the default user

# [Optional] Uncomment this line to install global node packages.
# RUN su vscode -c "source /usr/local/share/nvm/nvm.sh && npm install -g <your-package-here>" 2>&1