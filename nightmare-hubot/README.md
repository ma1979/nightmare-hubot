- HUBOT_SLACK_TOKEN
  - slack に integrate した hubot の token


- 同梱の script 込みで docker run する場合は -v でマウントする
  - scripts/capture.coffee
    - 任意の url のスクリーンショットを返す
- docker run 例

```
$ docker run -v <ホストOSのclone先>/nightmare-hubot/nightmare-hubot/scripts:/home/bot/scripts -e "HUBOT_SLACK_TOKEN=<token>" --name "nightmare-hubot" ma1979/nightmare-hubot
```

