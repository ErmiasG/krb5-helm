FROM payara/server-node:6.2024.10-jdk17

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

#Create instance can return the instance name with some warnings.
#Here we try to get the last line as the instance name.
RUN sed -i '/^    if \[ ! -z "${DOCKER_CONTAINER_ID}" \]; then/i \    PAYARA_INSTANCE_NAME=$(echo "${PAYARA_INSTANCE_NAME}" | tail -1)' /opt/payara/scripts/entrypoint.sh
#COPY --chown=payara:payara entrypoint.sh /opt/payara/scripts/entrypoint.sh

COPY --chown=payara:payara scripts/deploy.sh /opt/payara/scripts/deploy.sh
RUN chmod +x /opt/payara/scripts/deploy.sh
COPY --chown=payara:payara scripts/wait-for-admin.sh /opt/payara/scripts/wait-for-admin.sh
RUN chmod +x /opt/payara/scripts/wait-for-admin.sh

RUN true \
    && chmod +x ${SCRIPT_DIR}/entrypoint.sh \
    && true