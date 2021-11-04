#!/bin/bash
set -e

envsubst < "$PWD/nginx/nginx.conf.template" > "$PWD/nginx/nginx.conf"

(cd "$PWD/api" && gunicorn --bind :$API_PORT --workers 1 --threads 8 --timeout 0 wsgi:app) &

(cd "$PWD/web-ui" && yarn start:production) &

timeout 60 bash -c "until (> /dev/tcp/localhost/$API_PORT) && (> /dev/tcp/localhost/$UI_PORT); do sleep 1; done"

nginx -c "$PWD/nginx/nginx.conf" &

wait -n
