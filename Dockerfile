FROM jupyter/base-notebook:latest
LABEL maintainer = "blue271828"


USER root

RUN apt-get update && apt-get install -y --no-install-recommends \
            curl \
            fonts-takao \
            gcc \
            mecab \
            mecab-ipadic-utf8 \
            libtool-bin \
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

# Install Stanford CoreNLP from source
ENV CORENLP_HOME=/opt/CoreNLP
RUN cd /opt && \
    git clone --depth 1 https://github.com/stanfordnlp/CoreNLP.git && \
    cd CoreNLP && \
    ant jar && \
    curl -LO http://nlp.stanford.edu/software/stanford-corenlp-models-current.jar


USER $NB_USER

COPY requirements.txt requirements.txt
RUN pip install --no-cache-dir -r requirements.txt
