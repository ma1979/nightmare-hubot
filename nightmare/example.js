
const Nightmare = require('nightmare');
const nightmare = Nightmare({
    show: true,
    width: 1024, // 初期のブラウザ幅
    height: 768, // 初期のブラウザ高さ
    enableLargerThanScreen: true // ブラウザを画面より大きく出来るか
});

// Yahooにアクセス、ENDLABで検索
const yahooSearch = () => {
    return new Promise((resolve, reject) => {
        nightmare
            .goto('http://yahoo.co.jp')
            .evaluate(() => {
                var body = document.querySelector('body');

                // 背景を白に
                body.style.backgroundColor = '#fff';

                // ページ全体の幅と高さを返す
                return {
                    width: body.scrollWidth + (window.outerWidth - window.innerWidth),
                    height: body.scrollHeight + (window.outerHeight - window.innerHeight)
                };
            })
            .then((result) => {
                resolve(result);
            });
    });
}

// 現在のページをスクリーンショット保存
const screenShot = (r) => {
    return new Promise((resolve, reject) => {
        nightmare
            .viewport(r.width, r.height)
            .wait(1000)
            .screenshot('./screenshot.png')
            .then(() => {
                resolve(nightmare.end());
            });
    });
}

// 実行開始
yahooSearch()
    .then((r) => {
        screenShot(r);
    });