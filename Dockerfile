FROM node:16-alpine AS dependencies

WORKDIR /app
COPY web-ui/package.json web-ui/yarn.lock ./
RUN yarn install --production --frozen-lockfile

FROM node:16-alpine AS builder

WORKDIR /app
COPY --from=dependencies /app/node_modules ./node_modules
COPY web-ui/ ./
RUN yarn run build && rm -rf .next/cache

FROM jackywithawhitedog/python-node-nginx:alpine AS runner

ENV API_PORT=8081
ENV UI_PORT=8082

RUN apk add --no-cache tini

WORKDIR /app

# Nginx
COPY nginx ./nginx
COPY run.sh ./run.sh

# Flask server
ENV PYTHONUNBUFFERED True

COPY api/requirements.txt ./
RUN pip install --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

COPY api ./api

# Next.js
ENV NODE_ENV production

COPY --from=builder /app/.next ./web-ui/.next
COPY --from=builder /app/node_modules ./web-ui/node_modules
COPY --from=builder /app/package.json ./web-ui/package.json

EXPOSE $PORT

ENTRYPOINT [ "/sbin/tini", "--" ]

CMD [ "sh", "./run.sh" ]
