# ふうとしおりの ことばの旅

日本国憲法の第6・19〜24条。手書き風4コマ、音声付き動画、条文全文と解説、コメント、管理者の主張を含みます。

## 保存場所

- 作業フォルダ：Macのデスクトップ `おためしよ/kenpo`
- GitHub： https://github.com/muneimunei-arch/kenpo
- 現在の公開先： https://muneiserver.xsrv.jp/kenpo/

`public/kenpo` がページ・画像・動画です。`server/community.php` はXサーバーで動作するコメント・認証APIのソースです。公開中のXサーバーから取得した最新ファイルを初期登録しています。

## ふだんの更新

1. 作業の前に `01_GitHubから更新.command` をダブルクリックする。
2. `public/kenpo` のファイルを編集する。
3. 作業の後に `02_GitHubへ保存.command` をダブルクリックする。

2番目の保存ボタンは、変更を履歴に保存し、GitHubの更新を取り込んでから送信します。競合したときは自動で上書きせず停止します。赤字やエラーが出たときは続けず、表示内容を確認してください。GitHubで編集した変更は、次の取り込みでMacにも届きます。常時監視ではなく、このボタンを作業の前後に使って同期します。GitHubへの認証を求められた場合は、ご自身のアカウントで認証してください。

## コメント・管理者の文章の保存

利用者の投稿と管理者の文章はXサーバーの非公開SQLiteデータベースに保存されています。GitHubへサイトのファイルを送るだけでは、投稿データのバックアップにはなりません。

`03_コメントをバックアップ.command` を実行すると、投稿・管理者の文章・管理者設定の整合性を保ったバックアップを、Macの `おためしよ/kenpo-非公開バックアップ` に保存します。このフォルダはGitリポジトリの外にあり、GitHubへ送信されません。XサーバーとMacの2か所に保存されます。運営中は定期的にこのボタンも使ってください。

接続キー `おためしよ/muneiserver.key`、管理者パスワード、認証設定、SQLiteファイルはリポジトリに含めません。キーはMac内だけで利用します。管理者パスワードは従来のままです。

## 後でVercelで開く

1. VercelでこのGitHubリポジトリをImportする。
2. Framework Presetは `Other`。Root Directoryはリポジトリのルート。Output Directoryは `public`。ビルドコマンドは不要。
3. Deployする。設定は `vercel.json` に含まれます。

トップ `/` は `/kenpo/` を開きます。ページと動画はVercelで配信します。コメントと管理者機能の `/kenpo/community.php` は、Vercelの外部rewriteで既存のXサーバーへ接続します。PHPソースは公開ファイルのフォルダには置きません。VercelとXサーバーで同じコメント・管理者の文章を共有します。Xサーバーの契約とPHP APIは引き続き必要です。Macの起動は不要です。

公式資料：https://vercel.com/docs/routing/rewrites

Vercelへの接続後はmainブランチに送信した更新がVercelのデプロイ対象になります。まだVercelのImportや公開は行っていません。実際のVercel URLでコメント・ログインの動作確認が必要です。

このリポジトリとMacの同期は、XサーバーへのHTMLアップロードとは別です。現在のXサーバーを更新する際は `public/kenpo` の内容と `server/community.php` を所定の `public_html/kenpo` に反映します。既存の非公開データベース・認証設定を上書きしないでください。
