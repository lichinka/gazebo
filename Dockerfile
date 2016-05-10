FROM ubuntu:14.04

RUN apt-get update          && \
    apt-get install -y openssh-server  \
                       patch           \
                       xauth           \
                       wget            \
            --no-install-recommends

# install Gazebo
WORKDIR /usr/local/src

ADD gazebo7_install.patch .

RUN wget http://osrf-distributions.s3.amazonaws.com/gazebo/gazebo7_install.sh && \
    patch < gazebo7_install.patch                                             && \
    sh ./gazebo7_install.sh

# user and locale configuration
RUN useradd -m docker                                               && \
    cp /usr/share/zoneinfo/Europe/Zurich /etc/localtime             && \
    dpkg-reconfigure locales

WORKDIR /home/docker
ENV     HOME /home/docker
ENV     LC_ALL C.UTF-8

# SSH configuration
ADD  ssh/id_rsa.pub .ssh/authorized_keys
RUN  chmod 700  $HOME/.ssh                       && \
     chmod 600  $HOME/.ssh/authorized_keys       && \
     mkdir      /var/run/sshd                    && \
     chmod 0755 /var/run/sshd                    && \
     cd /home/docker                             && \
     chown -R docker:docker .

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
