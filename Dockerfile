FROM ubuntu:14.04

RUN apt-get update          && \
    apt-get install -y patch \
                       xauth \
                       wget  \
            --no-install-recommends

WORKDIR /usr/local/src

ADD gazebo7_install.patch .

RUN wget http://osrf-distributions.s3.amazonaws.com/gazebo/gazebo7_install.sh && \
    patch < gazebo7_install.patch                                             && \
    sh ./gazebo7_install.sh

CMD ["/usr/bin/gazebo"]
