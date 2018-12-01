# Set the Docker image you want to base your image off.
FROM elixir:1.7

ENV MIX_ENV="prod" \
  PORT="5000"

# Exposes this port from the docker container to the host machine
EXPOSE 5000

# Add nodejs
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -

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

WORKDIR assets
RUN npm install && npm run deploy

WORKDIR ..

# Add the files to the image
COPY . .

# Make release
RUN mix do compile, phx.digest, release

# The command to run when this image starts up
CMD ["_build/prod/rel/app_template/bin/app_template", "foreground"]
