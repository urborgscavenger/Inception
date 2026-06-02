#!/bin/bash
set -e

CERT_DIR=/etc/ssl/inception
if [ ! -f "${CERT_DIR}/inception.crt" ]; then
    mkdir -p ${CERT_DIR}
    openssl req -x509 -nodes -days 365 -newkey rsa:4096 \
        -keyout ${CERT_DIR}/inception.key \
        -out ${CERT_DIR}/inception.crt \
        -subj "/C=DE/ST=Berlin/L=Berlin/O=42/OU=Student/CN=${DOMAIN_NAME}"
fi

exec "$@"
