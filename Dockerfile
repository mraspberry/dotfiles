FROM debian:latest

RUN \
    sed -n '/^deb\s/s//deb-src /p' /etc/apt/sources.list > /etc/apt/sources.list.d/deb-src.list \
    && useradd -m -s /bin/bash -U mlr \
    && apt-get update && apt-get -y build-dep python3 \
    && apt-get -y install build-essential gdb lcov pkg-config \
      libbz2-dev libffi-dev libgdbm-dev libgdbm-compat-dev liblzma-dev \
      libncurses5-dev libreadline6-dev libsqlite3-dev libssl-dev \
      lzma lzma-dev tk-dev uuid-dev zlib1g-dev git curl vim gnupg

WORKDIR /code
COPY . /code
RUN chown -R mlr:mlr /code
USER mlr
#RUN /code/test.sh
CMD ["/code/test.sh"]
