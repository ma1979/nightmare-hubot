FROM centos
MAINTAINER ma1979

ENV TZ=Asia/Tokyo

# 日本語
RUN rm -f /etc/rpm/macros.image-language-conf && \
    sed -i '/^override_install_langs=/d' /etc/yum.conf && \
    yum -y reinstall glibc-common && \
    yum clean all

ENV LANG="ja_JP.UTF-8" \
    LANGUAGE="ja_JP:ja" \
    LC_ALL="ja_JP.UTF-8"

RUN yum -y update && yum -y install epel-release

RUN yum -y install nodejs
RUN yum -y install npm
RUN yum -y install git wget

# nightmare electron
RUN yum -y install xorg-x11-server-Xvfb xorg-x11-fonts*
RUN yum -y groupinstall "Japanese Support"
RUN yum -y install gtk2
RUN yum -y install atk
RUN yum -y install pango
RUN yum -y install gdk-pixbuf2
RUN yum -y install libXrandr
RUN yum -y install GConf2
RUN yum -y install libXcursor
RUN yum -y install libXcomposite
RUN yum -y install libnotify
RUN yum -y install libXtst
RUN yum -y install cups-libs
RUN yum -y install glib2-devel
RUN yum -y install libXScrnSaver
RUN yum -y install alsa-lib
RUN yum -y install dbus
RUN yum clean all

# Xvfb用
RUN dbus-uuidgen > /var/lib/dbus/machine-id
COPY entrypoint.sh /entrypoint
RUN chmod +x /entrypoint

# サンプル
RUN mkdir /home/node
ADD ./example.js /home/node

WORKDIR /home/node
RUN npm install electron nightmare

ENTRYPOINT ["/entrypoint"]