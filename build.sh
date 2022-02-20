#!/usr/bin/env bash
# ***********************************************************************
# Description   : IMAU of Serialt
# Version       : 1.0
# Author        : serialt
# Email         : serialt@qq.com
# Github        : https://github.com/serialt
# Created Time  : 2022-02-17 06:55:27
# Last modified : 2022-02-17 14:41:58
# FilePath      : /yaml/vscode-server/run.sh
# Other         : 
#               : 
# 
# 
#                 人和代码，有一个能跑就行
# 
# 
# ***********************************************************************


export IMAU_GO_VERSION=1.18beta2
export IMAU_VSCODE_VERSION=4.0.1
export IMAU_DUMP_INIT=1.2.5


setTrash(){
    trash_path="/tmp/.trash"
    crontab_job="0 0 * * 0 rm -rf /tmp/.trash/*"
    cat > /usr/local/bin/remove.sh <<EOF
#!/bin/bash
TRASH_DIR=${trash_path}

[[ ! -f \${TRASH_DIR} ]] && mkdir -p \${TRASH_DIR}
for i in \$*; do
    STAMP=\`date "+%Y%m%d%H%M%S"\`
    fileName=\`basename \$i\`
    mv \$i \$TRASH_DIR/\$STAMP.\$fileName
done
EOF
    grep 'remove.sh' /etc/bashrc &> /dev/null
    [[ $? != 0 ]] && echo 'alias rm="bash /usr/local/bin/remove.sh"' >> /etc/bashrc
    (crontab -l;echo "${crontab_job}") | crontab
    source /etc/bashrc
}


setENV(){
cat > /etc/profile.d/serialt2.sh <<EOF
### golang configration
export GOROOT=/usr/local/go
export GOPROXY=https://goproxy.cn,direct
export GOPATH=~/go
export GOBIN=\$GOPATH
export PATH=\$PATH:\$GOROOT/bin:\$GOBIN/bin

### history configration
UserIP=\$(who -u am i | cut -d"("  -f 2 | sed -e "s/[()]//g")
export HISTTIMEFORMAT="[%F %T] [\`whoami\`] [\${UserIP}] "


### istio configration
export ISTIO_HOME=/usr/local/istio
export PATH=\$PATH:\$ISTIO_HOME/bin



#export  PS1="[\u@\h \W]\\$ "

#export CLICOLOR=1
#export LSCOLORS=ExGxFxdaCxDaDahbadeche

### lang set
# export LC_ALL=en_US.UTF-8

alias rm="bash /usr/local/bin/remove.sh"

### support chinese
# export LANG="zh_CN.UTF-8"
EOF

cat > /etc/pip.conf <<EOF
[global]
index-url = https://mirrors.aliyun.com/pypi/simple/

[install]
trusted-host=mirrors.aliyun.com
EOF

}


InstallDEV_ENV(){
    if [[ ! -f /etc/profile.d/serialt.sh ]];then
        setENV
        
        setTrash
        cd /tmp/ 
        wget https://go.dev/dl/go${IMAU_GO_VERSION}.linux-amd64.tar.gz 
        tar -xf go*.tar.gz -C /usr/local 
        wget https://github.com/coder/code-server/releases/download/v${IMAU_VSCODE_VERSION}/code-server-${IMAU_VSCODE_VERSION}-linux-amd64.tar.gz 
        tar -xf  code-server*.tar.gz 
        mv /tmp/code-server-${IMAU_VSCODE_VERSION}-linux-amd64 /opt/code-server 
        wget -O /usr/local/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v${IMAU_DUMP_INIT}/dumb-init_${IMAU_DUMP_INIT}_x86_64 
        chmod +x /usr/local/bin/dumb-init
        Install_extension
    fi
}


Install_extension(){
extension_list=(
766b.go-outliner
alefragnani.Bookmarks
alefragnani.project-manager
alexcvzz.vscode-sqlite
bbenoist.shell
caarlos0.language-prometheus
cheshirekow.cmake-format
christian-kohler.path-intellisense
ckolkman.vscode-postgres
codezombiech.gitignore
cweijan.vscode-office
cweijan.vscode-typora
dhoeric.ansible-vault
dongli.python-preview
donjayamanne.git-extension-pack
donjayamanne.githistory
donjayamanne.python-environment-manager
donjayamanne.python-extension-pack
eamodio.gitlens
felipecaputo.git-project-manager
formulahendry.code-runner
formulahendry.terminal
foxundermoon.shell-format
golang.go
Gruntfuggly.todo-tree
himanoa.Python-autopep8
howardzuo.vscode-git-tags
huizhou.githd
humao.rest-client
IJustDev.gitea-vscode
ionutvmi.path-autocomplete
ipedrazas.kubernetes-snippets
KevinRose.vsc-python-indent
lunuan.kubernetes-templates
magicstack.MagicPython
matthewpi.caddyfile-support
mgesbert.python-path
mhutchie.git-graph
mishkinf.goto-next-previous-member
mrmlnc.vscode-apache
ms-azuretools.vscode-docker
MS-CEINTL.vscode-language-pack-zh-hans
ms-kubernetes-tools.vscode-kubernetes-tools
ms-python.python
ms-python.vscode-pylance
ms-toolsai.jupyter
ms-toolsai.jupyter-keymap
ms-toolsai.jupyter-renderers
ms-vscode-remote.remote-ssh
ms-vscode-remote.remote-ssh-edit
ms-vscode-remote.vscode-remote-extensionpack
ms-vscode.cmake-tools
mtxr.sqltools
njpwerner.autodocstring
nkjoep.mac-classic-theme
OBKoro1.korofileheader
Okteto.remote-kubernetes
r3inbowari.gomodexplorer
redhat.vscode-yaml
Remisa.shellman
sandipchitale.vscode-kubernetes-helm-extras
shaharkazaz.git-merger
shanoor.vscode-nginx
TabNine.tabnine-vscode
technosophos.vscode-helm
tht13.python
Tim-Koehler.helm-intellisense
tomaciazek.ansible
truman.autocomplate-shell
tushortz.python-extended-snippets
twxs.cmake
Tyriar.terminal-tabs
VisualStudioExptTeam.vscodeintellicode
vscode-icons-team.vscode-icons
waderyan.gitblame
wholroyd.jinja
william-voyek.vscode-nginx
xmtt.go-mod-grapher
yzhang.markdown-all-in-one
ZainChen.json
zamerick.vscode-caddyfile-syntax
zbr.vscode-ansible
ziyasal.vscode-open-in-github
)

    for aobj in ${extension_list[@]}
    do
    arr=(${aobj//,/ })
    extName=${arr[0]}
    /opt/code-server/bin/code-server  --install-extension ${extName}
    done
}







InstallDEV_ENV