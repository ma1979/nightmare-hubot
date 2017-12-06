FROM centos
MAINTAINER ma1979

ENV TZ=Asia/Tokyo

RUN yum -y update && yum -y install epel-release && yum clean all

RUN yum install -y nodejs npm

RUN yum -y install xorg-x11-server-Xvfb "xorg-x11-fonts*"
RUN yum -y groupinstall "Japanese Support"
RUN yum -y install gtk2
RUN yum -y install libXtst
RUN yum -y install libXScrnSaver
RUN yum -y install GConf2
RUN yum -y install alsa-lib

RUN npm install coffee-script
RUN npm install -g yo generator-hubot
RUN npm list -g yo generator-hubot
RUN useradd bot
RUN ls -al /home
#RUN mkdir /home/bot && chown bot.bot /home/bot

USER bot
WORKDIR /home/bot
RUN  yo hubot --owner "ma1979" --name "bot" --description "Hubot image" --adapter lets-chat

# lets-chat
RUN npm install cron
RUN npm install electron nightmare
ADD scripts/login.coffee scripts

RUN echo "#!/bin/bash" > /home/bot/run_hubot.sh
RUN echo "bin/hubot --adapter lets-chat" >> /home/bot/run_hubot.sh
ADD ./example.js /home/bot
RUN chmod 777 /home/bot/run_hubot.sh



#CMD cd /home/bot; sh run_hubot.sh