#!/bin/bash
set -e

kinit george@${REALM} <<EOF
georgeldap
EOF

curl -k https://${SERVER}:28181/spnego/api/unprotected/resource | jq

curl -k --negotiate -u : https://${SERVER}:28181/spnego/api/protected/resource | jq