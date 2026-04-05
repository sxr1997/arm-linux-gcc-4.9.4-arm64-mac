FROM arm64v8/ubuntu:16.04

# Install essential build tools and crosstool-NG dependencies
RUN apt-get update && apt-get install -y \
    gcc g++ gperf bison flex texinfo help2man make libncurses5-dev \
    python-dev autoconf automake libtool-bin patch wget bzip2 xz-utils git \
    lib32z1 lib32ncurses5 lib32stdc++6 gawk

# Fetch crosstool-NG v1.24.0 (The stable "golden" version for GCC 4.9)
WORKDIR /root
RUN git clone -b crosstool-ng-1.24.0 https://github.com/crosstool-ng/crosstool-ng.git

# Build and install crosstool-NG locally
WORKDIR /root/crosstool-ng
RUN ./bootstrap && ./configure --enable-local && make -j$(nproc)

# Setup workspace for source tarballs
RUN mkdir -p /root/src

CMD ["/bin/bash"]