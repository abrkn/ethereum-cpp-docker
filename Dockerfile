FROM phusion/baseimage:0.9.9

ENV DEBIAN_FRONTEND noninteractive

RUN \
    apt-get update && \
    apt-get install -qy --no-install-recommends software-properties-common wget && \
    add-apt-repository ppa:ethereum/ethereum && \
    add-apt-repository ppa:ethereum/ethereum-dev && \
    wget -O - http://llvm.org/apt/llvm-snapshot.gpg.key|sudo apt-key add - && \
    echo "deb http://llvm.org/apt/trusty/ llvm-toolchain-trusty-3.5 main\ndeb-src http://llvm.org/apt/trusty/ llvm-toolchain-trusty-3.5 main" > \
        /etc/apt/sources.list.d/llvm-trusty.list && \
    apt-get update && \
    apt-get install -qy --no-install-recommends build-essential g++-4.8 git cmake libboost-all-dev libcurl4-openssl-dev wget \
        automake unzip libgmp-dev libtool libleveldb-dev yasm libminiupnpc-dev libreadline-dev scons \
        libjsoncpp-dev libargtable2-dev \
        libncurses5-dev libcurl4-openssl-dev wget \
        libjsoncpp-dev libargtable2-dev libmicrohttpd-dev \
        libcryptopp-dev libjson-rpc-cpp-dev \
        llvm-3.5 libedit-dev && \
    mkdir -p /usr/lib/llvm-3.5/share/llvm && ln -s /usr/share/llvm-3.5/cmake /usr/lib/llvm-3.5/share/llvm/cmake && \
    curl -L https://github.com/ethereum/cpp-ethereum/tarball/076f787a | tar xvz -C ethereum-cpp && \
    cd ethereum-cpp && \
    mkdir -p build && \
    cd build && \
    cmake .. -DHEADLESS=1 -DLLVM_DIR=/usr/share/llvm-3.5/cmake -DEVMJIT=1 && \
    make -j $(cat /proc/cpuinfo | grep processor | wc -l) && \
    make install && \
    ldconfig && \
    cd ../.. && \
    rm -rf ethereum-cpp && \
    apt-get remove -y software-properties-common wget automake unzip \
        build-essential g++-4.8 git cmake && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

CMD "/usr/local/bin/eth"
