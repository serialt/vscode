#!/usr/bin/env bash
# ***********************************************************************
# Description   : Blue Planet
# Author        : serialt
# Email         : tserialt@gmail.com
# Created Time  : 2022-02-17 06:55:27
# Last modified : 2023-05-03 18:35:39
# FilePath      : /vscode/build.sh
# Other         : 
#               : 
# 
# 
# 
# ***********************************************************************

export IMAU_GO_VERSION=1.20.3
export IMAU_VSCODE_VERSION=4.12.0
export IMAU_DUMP_INIT=1.2.5
export GO_SDK_DIR=/root/sdk

export CODE_ARCH=amd64

[ $(arch) != "x86_64" ] && export CODE_ARCH=arm64


setTrash() {
    trash_path="/tmp/.trash"
    crontab_job="0 0 * * 0 rm -rf /tmp/.trash/*"
    cat >/usr/local/bin/remove.sh <<EOF
#!/bin/bash
TRASH_DIR=${trash_path}

[[ ! -f \${TRASH_DIR} ]] && mkdir -p \${TRASH_DIR}
for i in \$*; do
    STAMP=\`date "+%Y%m%d%H%M%S"\`
    fileName=\`basename \$i\`
    mv \$i \$TRASH_DIR/\$fileName.\$STAMP
done
EOF
    grep 'remove.sh' /etc/bashrc &>/dev/null
    [[ $? != 0 ]] && echo 'alias rm="bash /usr/local/bin/remove.sh"' >>/etc/bashrc && echo -e '\nalias rm="bash /usr/local/bin/remove.sh"' >> /root/.bashrc 
    (
        crontab -l
        echo "${crontab_job}"
    ) | crontab
    source /etc/bashrc
}

setENV() {
    cat >/etc/profile.d/serialt2.sh <<EOF
### golang configration
export GOROOT=${GO_SDK_DIR}/go
export GOPROXY=https://goproxy.cn,direct
export GOPATH=~/go
export GOBIN=\$GOPATH/bin
export PATH=\$PATH:\$GOROOT/bin:\$GOBIN

### history configration
UserIP=\$(who -u am i | cut -d"("  -f 2 | sed -e "s/[()]//g")
export HISTTIMEFORMAT="[%F %T] [\`whoami\`] [\${UserIP}] "

#export  PS1="[\u@\h \W]\\$ "

#export CLICOLOR=1
#export LSCOLORS=ExGxFxdaCxDaDahbadeche

### lang set
# export LC_ALL=en_US.UTF-8

alias rm="bash /usr/local/bin/remove.sh"

### support chinese
# export LANG="zh_CN.UTF-8"
EOF

    cat >/etc/pip.conf <<EOF
[global]
index-url = https://mirrors.aliyun.com/pypi/simple/

[install]
trusted-host=mirrors.aliyun.com
EOF

}

InstallDEV_ENV() {
    if [[ ! -f /etc/profile.d/serialt.sh ]]; then
        setENV
        [ ! -d ${GO_SDK_DIR} ] && mkdir ${GO_SDK_DIR}
        setTrash
        cd /tmp/
        wget https://go.dev/dl/go${IMAU_GO_VERSION}.linux-${CODE_ARCH}.tar.gz
        tar -xf go*.tar.gz -C ${GO_SDK_DIR}
        rm -rf  go*.tar.gz
        wget https://github.com/coder/code-server/releases/download/v${IMAU_VSCODE_VERSION}/code-server-${IMAU_VSCODE_VERSION}-linux-${CODE_ARCH}.tar.gz
        tar -xf code-server*.tar.gz
        rm -rf code-server*.tar.gz
        mv /tmp/code-server-${IMAU_VSCODE_VERSION}-linux-${CODE_ARCH} /opt/code-server
        wget -O /usr/local/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v${IMAU_DUMP_INIT}/dumb-init_${IMAU_DUMP_INIT}_$(arch)
        chmod +x /usr/local/bin/dumb-init
        config_A=$(cat /opt/code-server/lib/vscode/product.json)
        config_B=$(cat /opt/vscode-marketplace.json )
        echo ${config_A} ${config_B} | jq -s add > /opt/code-server/lib/vscode/product.json
        Install_extension 
    fi
}

Install_extension() {
    extension_list=(
        766b.go-outliner
        alefragnani.Bookmarks
        alefragnani.project-manager
        cheshirekow.cmake-format
        christian-kohler.path-intellisense
        # ckolkman.vscode-postgres
        codezombiech.gitignore
        cweijan.vscode-office
        cweijan.vscode-typora
        dhoeric.ansible-vault
        donjayamanne.githistory
        felipecaputo.git-project-manager
        formulahendry.code-runner
        fredwangwang.vscode-hcl-format
        # gitlab.gitlab-workflow
        golang.go
        gruntfuggly.todo-tree
        hashicorp.hcl
        hashicorp.terraform
        howardzuo.vscode-git-tags
        huizhou.githd
        ionutvmi.path-autocomplete
        ipedrazas.kubernetes-snippets
        jeff-hykin.better-dockerfile-syntax
        lunuan.kubernetes-templates
        matthewpi.caddyfile-support
        mgesbert.python-path
        mhutchie.git-graph
        mrmlnc.vscode-apache
        ms-python.python
        ms-kubernetes-tools.vscode-kubernetes-tools
        ms-toolsai.jupyter
        ms-vscode.cmake-tools
        OBKoro1.korofileheader
        pascalreitermann93.vscode-yaml-sort
        patrickfalknielsen.git-tag-push
        rangav.vscode-thunder-client
        redhat.ansible
        redhat.vscode-yaml
        redjue.git-commit-plugin
        sandipchitale.vscode-kubernetes-helm-extras
        shaharkazaz.git-merger
        tim-koehler.helm-intellisense
        vscode-icons-team.vscode-icons
        waderyan.gitblame
        wholroyd.jinja
        xmtt.go-mod-grapher
        yzhang.markdown-all-in-one
        zainchen.json

    )

    for aobj in ${extension_list[@]}; do
        arr=(${aobj//,/ })
        extName=${arr[0]}
        /opt/code-server/bin/code-server --install-extension ${extName}
    done
    sleep 5
}

InstallDEV_ENV
exit 0

