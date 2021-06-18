#!/bin/bash
echo "Creating database $POSTGRES_DATABASE and running migrations..."
mix do ecto.create, ecto.migrate
echo "Done."

exec "$@"
