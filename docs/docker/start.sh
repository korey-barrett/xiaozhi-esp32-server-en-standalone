#!/bin/bash
# Start the Java backend (listening on port 8003 inside the container)
# SSO secrets (passcode + GitHub client secret) are injected from the container
# environment (docker-compose*.yml, fed from main/xiaozhi-server/.env) — never
# baked into the image. The :- defaults keep a misconfigured env safe.
java -jar /app/xiaozhi-esp32-api.jar \
  --server.port=8003 \
  --spring.datasource.druid.url=${SPRING_DATASOURCE_DRUID_URL} \
  --spring.datasource.druid.username=${SPRING_DATASOURCE_DRUID_USERNAME} \
  --spring.datasource.druid.password=${SPRING_DATASOURCE_DRUID_PASSWORD} \
  --spring.data.redis.host=${SPRING_DATA_REDIS_HOST} \
  --spring.data.redis.password=${SPRING_DATA_REDIS_PASSWORD} \
  --spring.data.redis.port=${SPRING_DATA_REDIS_PORT} \
  --xiaozhi.sso.passcode=${SSO_PASSCODE:-YOUR_SSO_PASSCODE} \
  --xiaozhi.sso.providers.github.client-secret=${GITHUB_CLIENT_SECRET:-YOUR_GITHUB_CLIENT_SECRET} &

# Start Nginx (run in the foreground to keep the container alive)
nginx -g 'daemon off;'