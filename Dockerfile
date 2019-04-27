FROM jupyter/base-notebook:latest
LABEL maintainer = "blue271828"


USER root

RUN apt-get update && apt-get install -y --no-install-recommends \
            curl \
            && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*


USER $NB_USER
