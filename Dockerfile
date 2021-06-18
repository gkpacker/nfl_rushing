FROM bitwalker/alpine-elixir-phoenix:1.11.4

ARG SECRET_KEY_BASE

RUN mkdir /app
WORKDIR /app

# Set exposed ports
EXPOSE 4000
ENV SECRET_KEY_BASE=${SECRET_KEY_BASE}

# Update and install packages
RUN apk update && \
  apk add -u alpine-sdk \
  musl \
  musl-dev \
  musl-utils \
  nodejs-npm \
  build-base \
  erlang

COPY . /app

# Cache elixir deps
ADD mix.exs mix.lock ./
RUN mix do deps.get, deps.compile

# Same with npm deps
ADD assets/package.json assets/
RUN cd assets && \
  npm install && \
  cd .. && \
  mix phx.digest

# Install hex package manager
# By using --force, we don’t need to type “Y” to confirm the installation
RUN mix local.hex --force

RUN chmod +x /app/entrypoint.sh

ENTRYPOINT [ "/app/entrypoint.sh" ]

CMD [ "foreground" ]
