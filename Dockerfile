FROM ubuntu

RUN apt-get update
RUN apt-get install -yq unzip
RUN apt-get install -yq git
RUN apt-get install -yq curl
RUN apt-get install -yq cmake build-essential
RUN apt-get install -yq \
    flex \
    bison \
    libkrb5-dev \
    libsasl2-dev \
    libnuma-dev \
    pkg-config \
    libssl-dev \
    libcap-dev \
    gperf \
    autoconf-archive \
    libevent-dev \
    libgoogle-glog-dev \
    wget \
    sudo
WORKDIR /home
RUN git clone https://github.com/facebook/proxygen.git
WORKDIR /home/proxygen/proxygen
RUN ./deps.sh && ./reinstall.sh
WORKDIR /home/proxygen/proxygen/httpserver/samples/echo
RUN g++ -I /home/proxygen -std=c++11 -o my_echo EchoServer.cpp EchoHandler.cpp -lproxygenhttpserver -lfolly -lglog -lgflags -pthread
RUN make install
RUN apt-get remove -y unzip git flex bison gperf autoconf-archive libgoogle-glog-dev wget libssl-dev git-man libbsd0 \
	libedit2 liberror-perl libgoogle-glog0v5 libpopt0 libssl-doc \
    libunwind8 libx11-6 libx11-data libxau6 libxcb1 libxdmcp6 libxext6 libxmuu1 \
    openssh-client rsync xauth zlib1g-dev build-essential
RUN rm -rf /home/proxygen
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*