# TODO: Consider apt-fast
# TODO: Static baseimage version. Which?
FROM phusion/baseimage

# Install external deps (cache in one step)
RUN apt-get update
RUN apt-get install --no-install-recommends -qy software-properties-common wget apt-fast
RUN wget -O - http://llvm.org/apt/llvm-snapshot.gpg.key | apt-key add -
RUN echo "deb http://llvm.org/apt/trusty/ llvm-toolchain-trusty-3.5 main\ndeb-src http://llvm.org/apt/trusty/ llvm-toolchain-trusty-3.5 main" > \
        /etc/apt/sources.list.d/llvm-trusty.list
RUN add-apt-repository ppa:ethereum/ethereum
RUN add-apt-repository ppa:ethereum/ethereum-dev
RUN add-apt-repository ppa:saiarcot895/myppa
RUN apt-get update
RUN apt-get install --no-install-recommends -qy apt-fast
RUN apt-fast install --no-install-recommends -qy build-essential g++-4.8 git cmake libboost-all-dev libcurl4-openssl-dev
        automake unzip libgmp-dev libtool libleveldb-dev yasm libminiupnpc-dev libreadline-dev scons
        libjsoncpp-dev libargtable2-dev
        libncurses5-dev libcurl4-openssl-dev
        libjsoncpp-dev libargtable2-dev libmicrohttpd-dev
        libcryptopp-dev libjson-rpc-cpp-dev
        llvm-3.5 libedit-dev
RUN mkdir -p /usr/lib/llvm-3.5/share/llvm && ln -s /usr/share/llvm-3.5/cmake /usr/lib/llvm-3.5/share/llvm/cmake
RUN git clone -b develop --depth=1 https://github.com/ethereum/cpp-ethereum
RUN mkdir -p cpp-ethereum/build
WORKDIR cpp-ethereum/build
RUN cmake .. -DHEADLESS=1 -DLLVM_DIR=/usr/share/llvm-3.5/cmake -DEVMJIT=1
RUN make -j $(cat /proc/cpuinfo | grep processor | wc -l)
RUN make install
RUN ldconfig
RUN rm -rf cpp-ether
RUN apt-get remove -y software-properties-common wget
RUN apt-get remove -y build-essential g++-4.8 git cmake
RUN apt-get remove -y  libboost-all-dev libcurl4-openssl-dev automake unzip
RUN apt-get remove -y libgmp-dev  libcryptopp-dev libjson-rpc-cpp-dev
RUN apt-get remove -y  llvm-3.5 libedit-dev
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

CMD "/usr/local/bin/eth"

