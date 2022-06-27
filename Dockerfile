# DOCKER-VERSION    0.2.1
#
# Dockerizing CentOS7: Dockerfile for building CentOS images
#
FROM rockylinux:8.6

LABEL mantainer="tserialt@gmail.com"


# change marketplace to visualstudio
ENV SERVICE_URL="https://marketplace.visualstudio.com/_apis/public/gallery"
ENV ITEM_URL="https://marketplace.visualstudio.com/items"

# change yum repo to huawei
RUN  sed -e 's|^mirrorlist=|#mirrorlist=|g' \
    -e 's|^#baseurl=http://dl.rockylinux.org/$contentdir|baseurl=https://mirrors.aliyun.com/rockylinux|g' \
    -i.bak \
    /etc/yum.repos.d/Rocky-*.repo && \
    yum -y install epel-release && sed -e "s|^metalink|#metalink|g" \
    -e "s|^#baseurl=https://download.example/pub|baseurl=https://mirrors.aliyun.com/|g" \
    -i.bak \
    -i /etc/yum.repos.d/epel*.repo


# install base software
RUN  yum -y install cronie git pwgen python3 python3-devel vim-enhanced bash-completion net-tools bind-utils openssh-clients  wget lftp  && \
    yum -y upgrade  


ADD run.sh /opt/
ADD config.yaml /root/.config/code-server/config.yaml
ADD settings.json /root/.local/share/code-server/Machine/settings.json 
ADD build.sh /opt/
RUN bash /opt/build.sh


ENV LANG=en_US.UTF-8
ENV TZ="Asia/Shanghai"



WORKDIR /root

EXPOSE 8080

ENTRYPOINT ["/opt/run.sh","--bind-addr","0.0.0.0:8080"]
