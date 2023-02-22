# DOCKER-VERSION    0.2.1
#
# Dockerizing CentOS7: Dockerfile for building CentOS images
#
FROM rockylinux:9

LABEL mantainer="tserialt@gmail.com"


# install base software
RUN yum -y install cronie git python3 python3-devel vim-enhanced iputils traceroute procps-ng bash-completion net-tools bind-utils openssh-clients wget lftp && \ 
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
ADD config.yaml /root/.config/code-server/config.yaml
ADD settings.json /root/.local/share/code-server/Machine/settings.json
ADD build.sh /opt/
RUN bash /opt/build.sh && yum clean all


ENV LANG=en_US.UTF-8
ENV TZ="Asia/Shanghai"

WORKDIR /root

EXPOSE 8080

ENTRYPOINT ["/opt/run.sh","--bind-addr","0.0.0.0:8080"]
