# requires docker > 1.9 to build [supports ARG variable]
# requires docker > 1.8 to build [supports ENV variable]

FROM container4armhf/armhf-alpine:3.3
MAINTAINER docker@libreelec.tv

ENV MONO_VER="${MONO_VER:-4.4.0.148}"
ENV MONO_URL="${MONO_URL:-http://download.mono-project.com/sources/mono/mono-$MONO_VER.tar.bz2}"

RUN \
  # install required build dependencies
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
  # prepare our destination and downloads
  curl -L $MONO_URL | tar -C /tmp -xjf - \

&& \
  # build and install Mono
  cd /tmp/mono-* && \
  # redefinitions abound.  If mono version changes from 4.4.0, this should probably get re-checked.
  sed -i '41,44d' libgc/os_dep.c && \
  sed -i '17,19d' mono/mini/exceptions-arm.c && \
  sh ./autogen.sh \
    --prefix=/usr && \
  make && \
  make install \

&& \
  # remove debugging symbols from our newly built libs
  strip -d /usr/lib/*.so* \

&& \
  # clean it all up
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


