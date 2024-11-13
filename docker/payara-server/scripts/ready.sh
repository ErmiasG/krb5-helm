#!/bin/sh

set -e

"${PAYARA_DIR}"/bin/asadmin --user="${ADMIN_USER}" --passwordfile="${PASSWORD_FILE}" list-configs