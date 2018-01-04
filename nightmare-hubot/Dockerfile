FROM ma1979/nightmare
MAINTAINER ma1979

RUN npm install -g yo generator-hubot
RUN npm list -g yo generator-hubot
RUN useradd bot
RUN chown bot.bot /home/bot

USER bot
WORKDIR /home/bot
RUN yo hubot --owner "ma1979" --name "bot" --description "Hubot image" --adapter slack
RUN npm install electron nightmare

CMD ["bin/hubot", "-a", "slack"]