FROM jupyter/base-notebook:87210526f381
LABEL maintainer = "blue271828"


USER root

# Install some dependency packages for notebook with ubuntu package manager
RUN apt-get update && apt-get install -y --no-install-recommends \
            ant \
            autoconf \
            automake \
            autotools-dev \
            curl \
            default-jdk \
            file \
            fonts-takao \
            g++ \
            gcc \
            git \
            graphviz \
            libmecab-dev \
            libtool-bin \
            make \
            mecab \
            mecab-ipadic-utf8 \
            mongodb \
            patch \
            ssh \
            sudo \
            swig \
            unzip \
            xz-utils \
            && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install NEologd from source
RUN cd /opt && \
    git clone --depth 1 https://github.com/neologd/mecab-ipadic-neologd.git && \
    cd mecab-ipadic-neologd && \
    ./bin/install-mecab-ipadic-neologd -n -y && \
    rm -rf /opt/mecab-ipadic-neologd

# Install CRF++ from source
RUN cd /opt && \
    git clone --depth 1 https://github.com/taku910/crfpp.git && \
    cd crfpp && \
    ./configure && \
    sed -i '/#include "winmain.h"/d' crf_test.cpp && \
    sed -i '/#include "winmain.h"/d' crf_learn.cpp && \
    make && make check && make install && \
    rm -rf /opt/crfpp

# Install CoboCha from source
RUN cd /opt && \
    git clone --depth 1 https://github.com/taku910/cabocha.git && \
    cd cabocha && \
    ./autogen.sh && \
    ./configure --with-charset=utf8 --enable-utf8-only && \
    ldconfig && \
    make && make check && make install && \
    ldconfig && \
    rm -rf /opt/cabocha

# Install Stanford CoreNLP
RUN cd /opt && \
    curl -O -L http://nlp.stanford.edu/software/stanford-corenlp-full-2018-10-05.zip && \
    unzip stanford-corenlp-full-2018-10-05.zip && \
    rm -f stanford-corenlp-full-2018-10-05.zip && \
    ln -s stanford-corenlp-full-2018-10-05 stanford-corenlp

# Install LevelDB
ARG LEVELDB_VERSION="1.19"
RUN curl -OL https://github.com/google/leveldb/archive/v${LEVELDB_VERSION}.tar.gz && \
    tar xvf v${LEVELDB_VERSION}.tar.gz && \
    rm -f v${LEVELDB_VERSION}.tar.gz && \
    cd leveldb-${LEVELDB_VERSION} && \
    make && \
    scp out-static/lib* out-shared/lib* /usr/local/lib && \
    cd include && \
    scp -r leveldb /usr/local/include && \
    ldconfig


USER $NB_USER

# Install dependency PyPI packages for notebook
COPY requirements.txt requirements.txt
RUN pip install --no-cache-dir -r requirements.txt
