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


USER $NB_USER

COPY requirements.txt requirements.txt
RUN pip install --no-cache-dir -r requirements.txt
