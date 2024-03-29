FROM rockylinux:9

LABEL mantainer="tserialt@gmail.com"


# install base software
RUN yum -y install make git vim iputils traceroute procps-ng bash-completion iproute bind-utils wget jq && \ 
    yum -y upgrade && \
    yum clean all 


# change yum repo to ustc
RUN   sed -e 's|^mirrorlist=|#mirrorlist=|g' \
    -e 's|^#baseurl=http://dl.rockylinux.org/$contentdir|baseurl=https://mirrors.ustc.edu.cn/rocky|g' \
    -i.bak \
    /etc/yum.repos.d/rocky*.repo && \
    yum -y install epel-release && \
    sed -e 's|^metalink=|#metalink=|g' \
    -e 's|^#baseurl=https\?://download.fedoraproject.org/pub/epel/|baseurl=https://mirrors.ustc.edu.cn/epel/|g' \
    -e 's|^#baseurl=https\?://download.example/pub/epel/|baseurl=https://mirrors.ustc.edu.cn/epel/|g' \
    -i.bak \
    /etc/yum.repos.d/epel*.repo  && \
    yum clean all && \
    echo -en "alias ls='ls --color'\nalias ll='ls -l'\nalias lh='ls -lh' " >> ~/.bashrc  && \
    ln -snf /opt/code-server/bin/code-server /usr/local/bin/code


# # yum upgrade
# RUN yum clean all && \
#     echo -en "alias ls='ls --color'\nalias ll='ls -l'\nalias lh='ls -lh' " >> ~/.bashrc 

ADD run.sh /opt/
ADD settings.json /root/.local/share/code-server/Machine/settings.json
ADD build.sh /opt/
ADD favicon /opt/favicon
ADD vscode-marketplace.json /opt/
ADD gitconfig /root/.gitconfig
RUN bash /opt/build.sh && yum clean all


ENV LANG=en_US.UTF-8
ENV TZ="Asia/Shanghai"

WORKDIR /root

EXPOSE 80

ENTRYPOINT ["/opt/run.sh"]
