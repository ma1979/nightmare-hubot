Nightmare = require('nightmare');

id = '*****';
password = '*****';
#loginCookies;

module.exports = (robot) ->

  login = (msg) -> 
      msg.send "nightmare start"
      new Promise( (resolve, reject) ->
        msg.send "promise st"
        new Nightmare()
          .goto 'https://account.nicovideo.jp/login'
          .type '#input__mailtel', id
          .type '#input__password', password
          .click '#login__submit'
          .wait 4000
          .cookies.get()
          .run()
          .end()
          .then (cookies) ->
          loginCookies = cookies;
            msg.send "login"
            resolve()
          .catch (error) ->
            msg.send 'Login failed:' + error
            reject()
        msg.send "promise end"
      )

  example = (msg) -> 
    msg.send "example"
    return new Promise( (resolve, reject) ->
      new Nightmare()
        .goto('http://www.nicovideo.jp/')
        .type('#searchWord', 'テスト')
        .click('#searchSubmit')
        .wait(5000)
              .evaluate () ->
                  return document.querySelector('title').innerHTML
              .end()
              .then (result) ->
                  console.log result
                  resolve()
              .catch (error) ->
                  console.error 'Transition failed:', error
                  reject()
    )

  robot.hear /hoge/i, (msg) ->
    msg.send "exec"
    login msg
      .then () ->
        example msg
      .catch (error) ->
        msg.send error
    msg.send "done"