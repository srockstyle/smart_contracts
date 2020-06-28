# Kaleidoの使い方
いくつかまとめます。
- https://kaleido.io/

## 最初に
手順にしたがってつくれよって言われるので作ります。

- network
- environment
- node

ここまではOK。

networkかenvironmentを作ったあとの開始のチュートリアルがあるけど、あれはバグってるのでつかってはいけません。
なんどやっても指定しているコンパイラのバージョンが違うからっていわれてSolidityのファイルがあげられない。

それぞれの名前は適当でOK。

## AppCard
アプリケーションから接続するための情報をもらう。


## URL
スマートコントラクトをデプロイするとAPI GatewaのURLがもらえる。
```
POST http://gateway_api_url/
```

API GatewaのURLはPOSTだけあるのでPOSTをSwagger上で一度だけ実行。
インスタンスのAPIが作られる。
```
GET or POST http://gateway_api_url/instance/aaaaaaaaaaa
```

この後ろにSolidityで作ったpublicの関数名がエンドポイントになる。ここにパラメータつけて実行したりすると、EVM上で実行される。
```
/instance/aaaaaaaaaaa/helloworld
```

GETはReadだけ。POSTは実際にブロックに書き込むトランザクションを発生させる。
上のURLに以下のパラメータを載せて実行。
```
Content-Type application/json
Authorization Basic [最初のAppCardにもらった情報]
x-kaleido-from 0x81A74BDB06295729c4212e694B6fd43700f46444 <- 40文字列ならなんでもいいらしい
```

bodyにはSwaggarで指定されたjsonを入れる。
```
{
	"x":	"aaaaa"
}
```

これでKaleidoにTransactionが発生する。Transactionが実際に発生しているかは以下のURLでみれる。
これ新しい管理画面がヘボなのでクラシックの方がみやすい。
https://classic.kaleido.io/environments/aaaaa/aaaa/explorer/transactions

aaaaのところを読み替えてもらって以下のURLにいって、ブロックが進んでいることを確認する。
こっちも新しい管理画面がヘボなのでクラシックの方がみやすい。
```
https://classic.kaleido.io/environments/aaaaaaaa/aaaaaaa/explorer/blocks
```

帰ってきた値はこんな感じ。IDのところに文字列が入っている。sentがtrueなら送るの成功したよ、の意味。
```
{
    "sent": true,
    "id": "982d82ee-5832-4c68-4510-a9c000000000",
    "msg": "戻り値"
}
```

これを引数に以下のAPIにアクセスするとレシートがもらえる。レシートはnodeのURLにアクセスする。
API Gatewayではないし、インスタンスのIDでもないので注意。
```
GET https://[nodeのURL]/replies/982d82ee-5832-4c68-4510-a9c000000000
```

こんなレシートがかえってくればOK。
```
{
    "_id": "000000000aaaa",
    "blockHash": "000000000aaaa",
    "blockNumber": "49",
    "cumulativeGasUsed": "260",
    "from": "000000000aaaaaaaaaaa",
    "gasUsed": "267",
    "headers": {
        "id": "000000000aaaa",
        "requestId": "000000000aaaa",
        "requestOffset": "000000000aaaa",
        "timeElapsed": 3.750778,
        "timeReceived": "2020-06-28T08:32:42.556839858Z",
        "type": "TransactionSuccess"
    },
    "nonce": "0",
    "receivedAt": 1593333166314,
    "status": "1",
    "to": "00000000000000",
    "transactionHash": "0000000000000",
    "transactionIndex": "0"
}
```
失敗しているとstatusのところが0になる。
あとトランザクションがいろいろあってnodeに繋げないよ、とかはこんなメッセージがでる。
```
{
  "_id": "4696c9f7-2163-4237-7b58-0884fff5fbaf",
  "errorMessage": "Method 'constructor' param 0: Could not be converted to a number",
  "headers": {
    "type": "Error",
    "id": "786492a7-1032-473b-55ee-4dc74d1fa174",
    "requestId": "4696c9f7-2163-4237-7b58-0884fff5fbaf",
    "requestOffset": "u0j6rld2ka-u0uk478rin-requests:0:1",
    "timeElapsed": 0.000349413,
    "timeReceived": "2019-10-05T18:08:28.492341544Z"
  },
  "receivedAt": 1570298908996,
  "requestPayload": "...."
}
```

おわり。

### 追記

変なアタックうけてるのか、こんなのがでる。
```
Block sealing failed err="unauthorized signer"
```

サインしてないと当然ブロックを見ることはできないのでいいんだけど、邪魔。
