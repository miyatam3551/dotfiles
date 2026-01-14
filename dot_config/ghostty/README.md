# ghosttyの端末情報設定方法
brew install ghostty でインストールした後、以下のコマンドを実行して端末情報を設定します。

```shell
tic xterm-ghostty.terminfo
```
# なぜか
macmini でbrew install ghostty した後に ghostty を起動すると、端末情報が正しく設定されておらず、表示が乱れることがあります。この問題を解決するために、上記のコマンドを実行して端末情報を正しく設定します。
