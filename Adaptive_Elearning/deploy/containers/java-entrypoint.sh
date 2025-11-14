#!/bin/bash
set -euo pipefail

APP_HOME=${APP_HOME:-/opt/app}
WEBAPP_ROOT=/usr/local/tomcat/webapps/ROOT
ENV_TEMPLATE="${APP_HOME}/env.properties.tmpl"
ENV_TARGET="${WEBAPP_ROOT}/WEB-INF/classes/env.properties"

mkdir -p "$(dirname "${ENV_TARGET}")"

if [ -f "${ENV_TEMPLATE}" ]; then
  envsubst '$DB_URL $DB_USER $DB_PASSWORD $GOOGLE_CLIENT_ID $GOOGLE_CLIENT_SECRET $GOOGLE_REDIRECT_URI' \
    < "${ENV_TEMPLATE}" > "${ENV_TARGET}"
else
  echo "⚠️  Missing env.properties template at ${ENV_TEMPLATE}. Skipping generation." >&2
fi

exec "$@"

