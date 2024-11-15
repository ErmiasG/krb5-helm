#!/bin/bash
set -e

LOGIN_CONFIG="${PAYARA_DIR}"/glassfish/domains/domain1/config/login.conf

check_config() {
  if grep -q "$1" ${LOGIN_CONFIG}; then
    echo "${LOGIN_CONFIG} already contains $1 config"
    return 1
  else
    echo "Adding $1 config to ${LOGIN_CONFIG}"
    return 0
  fi
}

if check_config "spnego-client"; then
    cat >> "${LOGIN_CONFIG}" <<EOF

spnego-client {
    com.sun.security.auth.module.Krb5LoginModule required;
};
EOF
fi

if check_config "spnego-server"; then
    cat >> "${LOGIN_CONFIG}" <<EOF

spnego-server {
    com.sun.security.auth.module.Krb5LoginModule required
    debug=true
    useKeyTab=true
    storeKey=true
    isInitiator=false
    doNotPrompt=true
    principal={{ include "payara.principal" . | quote }}
    keyTab={{ .Values.keyTabPath | quote  }};
};
EOF
fi