#!/usr/bin/env bash
# ***********************************************************************
# Description   : Blue Planet
# Author        : serialt
# Email         : tserialt@gmail.com
# Created Time  : 2022-02-17 06:55:27
# Last modified : 2023-11-05 17:37:01
# FilePath      : /vscode/build.sh
# Other         : 
#               : 
# 
# 
# 
# ***********************************************************************


export IMAU_VSCODE_VERSION=4.102.1

export GO_SDK_DIR=/root/sdk
export CODE_ARCH=amd64

[ $(arch) != "x86_64" ] && export CODE_ARCH=arm64

    # go 
    APP_REPO=https://github.com/golang/go.git
    tags="$(git ls-remote --tags $APP_REPO | grep 'go[1-9]\.[0-9]*\.[0-9]*$' | awk -F'tags/' '{print $2}' | sort -t. -k1,1n -k2,2n -k3,3n)"
    arryTags=(${tags})
    latestTag=$(echo ${arryTags[-1]} | awk -F 'go' '{print$2}')
    export IMAU_GO_VERSION=${latestTag}
    
    # dump 
    APP_REPO=https://github.com/Yelp/dumb-init.git
    tags="$(git ls-remote --tags $APP_REPO | grep 'v[1-9]\.[0-9]*\.[0-9]*$' | awk -F'tags/' '{print $2}' | sort -t. -k1,1n -k2,2n -k3,3n)"
    arryTags=(${tags})
    latestTag=$(echo ${arryTags[-1]} | awk -F 'v' '{print$2}')
    export IMAU_DUMP_INIT=${latestTag}






setTrash() {
    trash_path="/tmp/.trash"
    # crontab_job="0 0 * * 0 rm -rf /tmp/.trash/*"
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
    # (
    #     crontab -l
    #     echo "${crontab_job}"
    # ) | crontab
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
export HISTTIMEFORMAT="[%F %T] [\`whoami\`] "

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
        \mv /opt/favicon/* /opt/code-server/src/browser/media/
        rm -rf /opt/favicon/
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
        arjun.swagger-viewer
        aykutsarac.jsoncrack-vscode
        christian-kohler.path-intellisense
        # ckolkman.vscode-postgres
        codezombiech.gitignore
        cweijan.vscode-office
        cweijan.vscode-typora
        donjayamanne.githistory
        donjayamanne.git-extension-pack
        eamodio.gitlens
        felipecaputo.git-project-manager
        formulahendry.code-runner
        # gitlab.gitlab-workflow
        golang.go
        gruntfuggly.todo-tree
        hashicorp.hcl
        hashicorp.terraform
        howardzuo.vscode-git-tags
        ionutvmi.path-autocomplete
        ipedrazas.kubernetes-snippets
        jeff-hykin.better-dockerfile-syntax
        lunuan.kubernetes-templates
        meezilla.json
        mgesbert.python-path
        mhutchie.git-graph
        mrmlnc.vscode-apache
        ms-python.python
        moshfeu.diff-merge
        ms-python.autopep8
        ms-python.vscode-pylance
        ms-python.debugpy
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
        shaharkazaz.git-merger
        sandipchitale.vscode-kubernetes-helm-extras
        shaharkazaz.git-merger
        tim-koehler.helm-intellisense
        vscode-icons-team.vscode-icons
        visualstudioexptteam.vscodeintellicode
        wholroyd.jinja
        vscjava.vscode-java-pack
        vscjava.vscode-lombok
        vscjava.vscode-spring-boot-dashboard
        xmtt.go-mod-grapher
        yzhang.markdown-all-in-one
        zainchen.json
        zxh404.vscode-proto3

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

