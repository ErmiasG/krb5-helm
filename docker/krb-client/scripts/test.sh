#!/bin/bash

kinit george@EXAMPLE.AI <<EOF
georgeldap
EOF

curl -k https://server:28181/spnego/api/unprotected/resource | jq

curl -k --negotiate -u : https://server:28181/spnego/api/protected/resource | jq