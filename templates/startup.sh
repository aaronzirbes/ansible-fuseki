#!/bin/bash -x

# Sane Defaults
USER={{fuseki_user_name}}
LOG_DIR=/var/log/{{app_name}}
APP_LOG=${LOG_DIR}/{{app_name}}.log
APP_DIR=/usr/local/{{app_install_dir}}
DATA_DIR=/var/lib/{{app_name}}
PORT={{app_port}}
DEFAULT_DB=default

JVM_ARGS='-Djava.net.preferIPv4Stack=true'

function setDataPermissions() {
    chown -R ${USER}:${USER} ${DATA_DIR}
}

function setLogPermissions() {
    # fix permissions on the log and pid files
    if [ ! -d ${LOG_DIR} ]; then
        mkdir -p ${LOG_DIR}
        chmod 0755 ${LOG_DIR}
        chown ${USER}:${USER} ${LOG_DIR}
    fi
}

setLogPermissions
setDataPermissions

CMD="JVM_ARGS='${JVM_ARGS}' ${APP_DIR}/fuseki-server --loc=${DATA_DIR} --port=${PORT} --update /${DEFAULT_DB}"
echo "`date` - Executing: ${CMD}"
exec /bin/su - ${USER} -c "cd ${APP_DIR}; ${CMD} >> ${APP_LOG} 2>&1"

