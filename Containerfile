FROM --platform=linux/amd64 gitlab-registry.cern.ch/linuxsupport/alma9-base
LABEL maintainer="Dennis Lee <dylee@fnal.gov>"

RUN dnf install -y 'dnf-command(config-manager)' && \
    dnf config-manager --add-repo https://linuxsoft.cern.ch/cern/alma/9/devel/x86_64/os

RUN dnf update -y && \
    dnf install -y epel-release redhat-lsb-core yum-utils && \
    dnf install -y  glibc-devel gdb time git tmux \
        vim gcc perf htop libtool autoconf automake && \
    dnf install -y openssl-devel tar zip xz bzip2 patch wget which sudo strace && \
    dnf install -y make && \
    dnf config-manager --set-enabled crb && \
    dnf install -y autoconf-archive pkgconfig curl lsof && \
    dnf clean all

RUN dnf install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm && \
    dnf install -y https://repo.opensciencegrid.org/osg/3.6/osg-3.6-el9-release-latest.rpm && \
    dnf install -y osg-wn-client osg-ca-certs osg-pki-tools && \
    dnf clean all

RUN dnf install -y https://linux-mirrors.fnal.gov/linux/fermilab/almalinux/9/yum-conf-fermilab.rpm && \
    dnf -y group install --with-optional fermilab && \
    sleep 2 && \
    dnf upgrade -y && \
    dnf install -y fermilab-conf_kerberos cigetcert fermilab-util_kx509 && \
    dnf clean all

WORKDIR /tmp
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
    install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
WORKDIR /tmp
RUN curl -LO "https://get.helm.sh/helm-v3.13.0-linux-amd64.tar.gz" && \
    tar xvzf helm-v3.13.0-linux-amd64.tar.gz && \
    cd ./linux-amd64 && \
    install -o root -g root -m 0755 helm /usr/local/bin/helm
WORKDIR /tmp
RUN curl -LO "https://github.com/derailed/k9s/releases/download/v0.27.4/k9s_Linux_amd64.tar.gz" && \
    tar xvzf k9s_Linux_amd64.tar.gz && \
    install -o root -g root -m 0755 k9s /usr/local/bin/k9s

CMD ["/bin/bash"]
