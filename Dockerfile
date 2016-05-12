# requires docker > 1.9 to build [supports ARG variable]
# requires docker > 1.8 to build [supports ENV variable]

FROM container4armhf/armhf-alpine:3.3
MAINTAINER docker@libreelec.tv

ENV  MONO_VER="${MONO_VER:-4.4.0.148}"
ENV MONO_URL="${MONO_URL:-http://download.mono-project.com/sources/mono/mono-$MONO_VER.tar.bz2}"

RUN \
  apk add --update \
    autoconf \
    automake \
    curl \
    g++ \
    gcc \
    gettext \
    libgcc \
    libtool \
    linux-headers \
    make \
&& \
  mkdir -p /opt/Mono \
&& \
  curl -L $MONO_URL | tar -C /tmp -xjf - \
&& \
  cd /tmp/mono-* && \
  sed -i '41,44d' libgc/os_dep.c && \
  sed -i '17,19d' mono/mini/exceptions-arm.c && \
  sh ./autogen.sh \
    --prefix=/usr && \
  make && \
  make install \
&& \
  apk del --purge \
    autoconf \
    automake \
    g++ \
    gcc \
    gettext \
    libtool \
    linux-headers \
    make \
&& \
  rm -rf /var/cache/apk/* \
    /usr/include \
    /usr/share/man \
    /tmp/*
