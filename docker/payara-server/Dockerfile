FROM payara/server-full:6.2024.10-jdk17

ENV DG_NAME="payara-dg" \
CONFIG="payara-config"

USER root
RUN apt-get update && \
    apt-get -y install krb5-config krb5-user && \
    apt install dnsutils -y && \
    apt install ldap-utils -y && \
    apt install curl -y

RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
RUN chmod +x ./kubectl
RUN mv ./kubectl /usr/local/bin/kubectl

RUN mkdir -p /etc/security/keytabs

USER payara

ENV POSTDEPLOY_COMMANDS=/opt/payara/config/post-deploy-commands.asadmin POSTDEPLOY_COMMANDS_FINAL=/opt/payara/config/post-deploy-commands-final.asadmin
RUN ${PAYARA_DIR}/bin/asadmin start-domain ${DOMAIN_NAME} && \
 for MEMORY_JVM_OPTION in $(${PAYARA_DIR}/bin/asadmin --user=${ADMIN_USER} --passwordfile=${PASSWORD_FILE} list-jvm-options --target default-config | grep "Xm[sx]\|Xss"); do \
 ${PAYARA_DIR}/bin/asadmin --user=${ADMIN_USER} --passwordfile=${PASSWORD_FILE} delete-jvm-options --target default-config $MEMORY_JVM_OPTION; \
 done && \
 ${PAYARA_DIR}/bin/asadmin --user=${ADMIN_USER} --passwordfile=${PASSWORD_FILE} create-jvm-options --target default-config '-XX\:+UseContainerSupport:-XX\:MaxRAMPercentage=${ENV=MEM_MAX_RAM_PERCENTAGE}:-Xss${ENV=MEM_XSS}' && \
 ${PAYARA_DIR}/bin/asadmin --user=${ADMIN_USER} --passwordfile=${PASSWORD_FILE} create-jvm-options --target server -Dhazelcast.member.attribute.instanceName=DAS && \
 ${PAYARA_DIR}/bin/asadmin copy-config --passwordfile=${PASSWORD_FILE} default-config $CONFIG && \
 ${PAYARA_DIR}/bin/asadmin create-deployment-group --passwordfile=${PASSWORD_FILE} $DG_NAME && \
 ${PAYARA_DIR}/bin/asadmin --user=${ADMIN_USER} --passwordfile=${PASSWORD_FILE} set-healthcheck-configuration --enabled=true --dynamic=true && \
 ${PAYARA_DIR}/bin/asadmin --user=${ADMIN_USER} --passwordfile=${PASSWORD_FILE} create-jndi-resource \
 --restype javax.naming.ldap.LdapContext \
 --factoryclass com.sun.jndi.ldap.LdapCtxFactory \
 --jndilookupname dc\=example\,dc\=com \
 --property java.naming.provider.url=ldap\\://ldap\.example\.com\\:389:java.naming.ldap.attributes.binary=entryUUID:java.naming.security.authentication=none:java.naming.referral=ignore ldap/LdapResource && \
 ${PAYARA_DIR}/bin/asadmin --user=${ADMIN_USER} --passwordfile=${PASSWORD_FILE} create-resource-ref --target=${DG_NAME} ldap/LdapResource && \
 ${PAYARA_DIR}/bin/asadmin stop-domain ${DOMAIN_NAME} && \
rm -rf \
 ${PAYARA_DIR}/glassfish/domains/${DOMAIN_NAME}/osgi-cache \
 ${PAYARA_DIR}/glassfish/domains/${DOMAIN_NAME}/logs

COPY --chown=payara:payara scripts/ready.sh /opt/payara/k8s/ready.sh
RUN chmod a+x /opt/payara/k8s/ready.sh

COPY --chown=payara:payara spnego-0.1.war /opt/payara/k8s/spnego.war