    #!/bin/bash

    echo "AS_ADMIN_MASTERPASSWORD=changeit
    AS_ADMIN_NEWMASTERPASSWORD=$ADMIN_PASSWORD" > /tmp/masterpwdfile

    echo "AS_ADMIN_PASSWORD=admin
    AS_ADMIN_NEWPASSWORD=$ADMIN_PASSWORD" > /tmp/adminpwdfile

    "${PAYARA_DIR}"/bin/asadmin --passwordfile=/tmp/masterpwdfile change-master-password --savemasterpassword
    echo "AS_ADMIN_MASTERPASSWORD=$ADMIN_PASSWORD" >> "${PASSWORD_FILE}"

    "${PAYARA_DIR}"/bin/asadmin --user="${ADMIN_USER}" --passwordfile="${PASSWORD_FILE}" start-domain "${DOMAIN_NAME}"
    # This (--hostawarepartitioning true) need to be set here because it needs a restart and can not be set in post boot commands.
    "${PAYARA_DIR}"/bin/asadmin --user="${ADMIN_USER}" --passwordfile="${PASSWORD_FILE}" set-hazelcast-configuration --hostawarepartitioning true --clustermode kubernetes --kubernetesServiceName {{ include "payara-node.fullname" . }} --kubernetesNamespace {{ .Release.Namespace }}
    "${PAYARA_DIR}"/bin/asadmin --user="${ADMIN_USER}" --passwordfile=/tmp/adminpwdfile --interactive=false change-admin-password

    echo "AS_ADMIN_PASSWORD=$ADMIN_PASSWORD" > "$PASSWORD_FILE"
    
    #     cp /etc/krb5.conf /opt/payara/appserver/glassfish/domains/domain1/config/
    #     cp /etc/security/keytabs/service.keytab /opt/payara/appserver/glassfish/domains/domain1/config/

    "${PAYARA_DIR}"/bin/asadmin --user="${ADMIN_USER}" --passwordfile="${PASSWORD_FILE}" enable-secure-admin
    "${PAYARA_DIR}"/bin/asadmin --user="${ADMIN_USER}" --passwordfile="${PASSWORD_FILE}" stop-domain "$DOMAIN_NAME"

    rm -rf /tmp/masterpwdfile
    rm -rf /tmp/adminpwdfile