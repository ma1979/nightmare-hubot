Nightmare = require('nightmare');

latest_image = 'screenshot.png'

graphSerch = (n, url) ->
  return new Promise (resolve, reject) ->
    n
        .goto(url)
        .evaluate(() -> 
            body = document.querySelector('body')
            body.style.backgroundColor = '#fff'

            return {
                 width: body.scrollWidth + (window.outerWidth - window.innerWidth),
                 height: body.scrollHeight + (window.outerHeight - window.innerHeight)
            }
        )
        .then((result) ->
            resolve(result)
        )
        .catch((err) ->
            reject(err)
        )

screenShot = (r, n) ->
    return new Promise (resolve, reject) ->
        n
            .viewport(r.width, r.height)
            .wait(1000)
            .screenshot("./#{latest_image}")
            .then(() ->
                resolve(n.end())
            )
            .catch((err) ->
                reject(err)
            )

module.exports = (robot) ->
    robot.respond /capture +me +(.+)/i, (msg) ->
        url = msg.match[1]
        msg.send "#{url} をキャプチャします。少々お待ちください..."
        n = Nightmare({
            show: false,
            width: 1024,
            height: 768,
            enableLargerThanScreen: true
        })
        graphSerch(n, url)
            .then (r) ->
                screenShot(r, n)
                    .then (r) ->
                        require('child_process').exec "curl -F 'file=@#{latest_image};type=image/png' -F channels=#{msg.envelope.room} -F token=#{process.env.HUBOT_SLACK_TOKEN} https://slack.com/api/files.upload", (err, stdout, stderr) ->
                            if err?
                                msg.send err if err?
                                msg.send stdout if stdout?
                                msg.send stderr if stderr?
                            msg.send "詳細は <#{url}|こちら> をどうぞ！"
                    .catch (err) ->
                        msg.send "Error! #{JSON.stringify(err)}"
            .catch (err) ->
                msg.send "Error! #{JSON.stringify(err)}"

    robot.respond /help/i, (msg) ->
        msg.send "capture me <url> - <url> をキャプチャして slack に投稿します"