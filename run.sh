#!/usr/bin/env bash
# ***********************************************************************
# Description   : Blue Planet
# Author        : serialt
# Email         : tserialt@gmail.com
# Created Time  : 2022-02-17 06:55:27
# Last modified : 2023-04-29 21:41:22
# FilePath      : /vscode/run.sh
# Other         : 
#               : 
# 
# 
# 
# ***********************************************************************


# ENV
# CS_HASHED_PASSWORD="xxxx"
# CS_DISABLE_UPDATE_CHECK=false
# CS_DISABLE_FILE_DOWNLOADS=false
# CS_SERVER_PORT="0.0.0.0:80"
# CS_CONFIG="~/.config/code-server/config.yaml"
# CS_USER_DATA_DIR="~/.local/share/code-server"
# CS_EXTENSIONS_DIR=""
# CS_APP_NAME=""
# CS_WELCOME_TEXT=""

ARGS="--auth password "

# Set password hashed with argon2
[ ! -z ${CS_HASHED_PASSWORD} ] && ARGS="${ARGS} --password ${CS_HASHED_PASSWORD}

#  Disable update check. Without this flag, code-server checks every 6 hours
if [ ! -z ${CS_DISABLE_UPDATE_CHECK} ] && [ ${CS_DISABLE_UPDATE_CHECK} == true ] ;then 
    ARGS="${ARGS} --disable-update-check "
fi


# Address to bind to in host:port
if [ ! -z ${CS_SERVER_PORT} ] ;then
    ARGS="${ARGS} --bind-addr ${CS_SERVER_PORT} "
else
    ARGS="${ARGS} --bind-addr 0.0.0.0:80 "
fi 

# Set config
[ ! -z ${CS_CONFIG} ] && ARGS="${ARGS} --config ${CS_CONFIG} "

# Set user data 
[ ! -z ${CS_USER_DATA_DIR} ] && ARGS="${ARGS} --user-data-dir ${CS_USER_DATA_DIR} "

# Set extensions-dir
[ ! -z ${CS_EXTENSIONS_DIR} ] && ARGS="${ARGS} --extensions-dir ${CS_EXTENSIONS_DIR} " 

# Set app-name 
[ ! -z ${CS_APP_NAME} ] && ARGS="${ARGS} --app-name ${CS_APP_NAME} " 

# Set welcome-text
[ ! -z ${CS_WELCOME_TEXT} ] && ARGS="${ARGS} --welcome-text ${CS_WELCOME_TEXT} " 

dumb-init /opt/code-server/bin/code-server "$@" "${ARGS}"