#!/bin/bash
#!/usr/bin/env bash
# ***********************************************************************
# Description   : IMAU of Serialt
# Version       : 1.0
# Author        : serialt
# Email         : serialt@qq.com
# Github        : https://github.com/serialt
# Created Time  : 2022-02-17 06:55:27
# Last modified : 2022-02-17 16:35:35
# FilePath      : /yaml/vscode-server/run.sh
# Other         : 
#               : 
# 
# 
#                 人和代码，有一个能跑就行
# 
# 
# ***********************************************************************




dumb-init /opt/code-server/bin/code-server "$@"