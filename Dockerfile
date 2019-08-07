# Set the Docker image you want to base your image off.
FROM elixir:1.9 as builder

ENV MIX_ENV="prod" \
  PORT="5000"

# Add nodejs
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -

# Install other stable dependencies that don't change often
RUN apt-get update && \
  apt-get install -y --no-install-recommends \
  apt-utils nodejs postgresql-client && \
  rm -rf /var/lib/apt/lists/*

WORKDIR /opt/app

# Install and compile project dependencies
# We do this before all other files to make container build faster
# when configuration and dependencies are not changed
COPY mix.* ./
RUN mix do local.rebar --force, local.hex --force, deps.get --only prod, deps.compile

COPY assets ./assets
RUN npm install --prefix assets && npm run deploy --prefix assets

# Add the files to the image
COPY . .

# Make release
RUN mix do compile, phx.digest, release

FROM debian:stretch-slim

RUN apt-get -qq update
RUN apt-get -qq install -y locales locales-all

# Set LOCALE to UTF8
RUN locale-gen en_US.UTF-8
ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8'

ENV MIX_ENV="prod" \
  PORT="5000"

# Exposes this port from the docker container to the host machine
EXPOSE 5000

# Because these dirs were stripped from the slim package and
# caused issues installing postgres-client
RUN seq 1 8 | xargs -I{} mkdir -p /usr/share/man/man{}

# Install other stable dependencies that don't change often
RUN apt-get update && \
  apt-get install -y --no-install-recommends \
  postgresql-client && \
  rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY --from=builder /opt/app/_build/prod/rel/app_template .

# The command to run when this image starts up
CMD ["./bin/app_template", "start"]
