#!/usr/bin/env bash

set -e

echo 'AS_ADMIN_PASSWORD='$ADMIN_PASSWORD'' > $PAYARA_PASSWORD_FILE
ASADMIN="${PAYARA_DIR}/bin/asadmin"
ASADMIN_COMMAND="${ASADMIN} -I false -T -a -p ${PAYARA_DAS_PORT} -W ${PAYARA_PASSWORD_FILE}"

_log () {
if { [ "$1" = "DEBUG" ] && [ "$DEBUG" = true ]; } || [[ $1 =~ INFO|WARNING  ]] ; then
    echo "$(date '+%Y-%m-%d %H:%M:%S') $1 -- $2"
fi
}

_is_admin_ready() {
${ASADMIN_COMMAND} list-configs &>/dev/null
}

_wait_for_admin() {
set +e
while true  ;
    do
        #wait until only one admin is ready
        if _is_admin_ready ; then
        _log INFO "DAS is up and ready!"
        break
        fi
        sleep 10
        _log INFO "Waiting for the DAS to be ready..."
    done
    set -e
}

_check_if_application_exists() {
    local application_name=$1
    local application_exists
    application_exists=$(${ASADMIN_COMMAND} list-applications "${PAYARA_DEPLOYMENT_GROUP}" | grep -c "${application_name}")
    if [[ "${application_exists}" -eq 1 ]]; then
        _log INFO "Application ${application_name} already exists"
        return 1
    fi
    return 0
}

_deploy() {
    local deploy_retry=1
    if  _check_if_application_exists "spnego:${VERSION}"; then
        _log INFO "Deploying spnego:${VERSION} to ${PAYARA_DEPLOYMENT_GROUP}"
        # Deploy the application, retry if failed deploy_retry times
        while [ $deploy_retry -gt 0 ]
        do
        deploy_retry=$((deploy_retry-1))
        ${ASADMIN_COMMAND} --echo=true deploy --name spnego:${VERSION} --target "${PAYARA_DEPLOYMENT_GROUP}" --force=true --contextroot=/spnego --enabled=true --keepstate=false /opt/payara/k8s/spnego.war
        if [ $? -eq 0 ]; then
            break
        fi
        _log WARNING "Failed to deploy spnego:${VERSION}. Retrying...."
        done
    fi
}

_check_instances_running() {
    local desired_instances=$1
    local running_instances
    running_instances=$(${ASADMIN_COMMAND} list-instances "${PAYARA_DEPLOYMENT_GROUP}" | grep running | awk '!/not/' | wc -l)
    _log INFO "check if instances are running. running=$running_instances desired=$desired_instances"

    [ "$running_instances" -ge "$desired_instances" ]
}

_wait_for_instances() {
    local num_workers_to_wait_on=$1
    local endTime
    local wait_sec=240
    set +e
    endTime=$(( $(date +%s) + $wait_sec ))
    while true;
    do
        if _check_instances_running "$num_workers_to_wait_on" ; then
            _log INFO "All requested instances are running!"
            sleep "$INITIAL_DELAY_SEC" # give the instances time to start
            break
        fi

        if [ "$(date +%s)" -gt $endTime ]; then
            _log WARNING "Timeout waiting for $num_workers_to_wait_on instances to start. wait for: $wait_sec."
            break
        fi

        sleep 2
        _log INFO "Waiting for $num_workers_to_wait_on instances to start"
    done
    set -e
}

_cleanup_stopped_instances() {
    set +e
    local stopped_instances
    local num_workers

    num_workers=$(kubectl get deploy "$WORKER_DEPLOYMENT_NAME" -n "$NAMESPACE" -o=jsonpath='{.status.replicas}')
    num_workers_exit_code=$?
    if [ $num_workers_exit_code -eq 0 ] ; then
        #Can only do cleanup if we know all instances are running and there are stopped instances.
        if _check_instances_running "$num_workers" ; then
        # shellcheck disable=SC2207
        stopped_instances=( $(${ASADMIN_COMMAND} list-instances "${PAYARA_DEPLOYMENT_GROUP}" | grep 'not running' | awk '{print $1}') )
        exit_code=$?
        if [[ $exit_code -eq 0 && ${#stopped_instances[@]} -gt 0 ]] ; then
            _log INFO "Not running instances ${stopped_instances[*]}"
            for i in "${stopped_instances[@]}"
            do
            _log INFO "Deleting instance $i"
            ${ASADMIN_COMMAND} delete-instance "$i"
            done
        fi
        fi
    fi
    set -e
}

_wait_for_admin

_wait_for_instances 1

_deploy

while true ;
do
    _cleanup_stopped_instances
    sleep 10
done