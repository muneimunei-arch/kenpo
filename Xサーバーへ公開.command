#!/bin/zsh
set -euo pipefail
BASE='/Users/muneimac/Documents/Codex/2026-10-03/macos-codex-ui-https-learn-chatgpt'
KEY='/Users/muneimac/Desktop/muneimunei/muneiserver.key'
ARCHIVE="$BASE/outputs/constitution-site/kenpo-release-public-comments.zip"
HOST='muneiserver@sv17240.xserver.jp'
STAMP=$(date +%Y%m%d-%H%M%S)
REMOTE_ARCHIVE="kenpo-release-$STAMP.zip"
SSH_OPTS=(-i "$KEY" -p 10022 -o ConnectTimeout=20 -o IdentitiesOnly=yes)
SCP_OPTS=(-i "$KEY" -P 10022 -o ConnectTimeout=20 -o IdentitiesOnly=yes)
trap 'printf "\n処理が止まりました。上に表示されたメッセージをご確認ください。\n"; true' ERR
[[ -f "$KEY" && -f "$ARCHIVE" ]]
printf '管理者欄を削除し、Xサーバー版とVercel版で共通のコメント機能を公開します。接続キーは送信しません。\n'
printf '初回は接続先の確認、鍵に設定されている場合はパスフレーズの入力が必要です。\n'
ssh "${SSH_OPTS[@]}" "$HOST" 'test -d "$HOME/muneiserver.xsrv.jp/public_html/kenpo" && command -v unzip >/dev/null && command -v curl >/dev/null'
# Refuse to replace an independently changed comment endpoint.
REMOTE_HASH=$(ssh "${SSH_OPTS[@]}" "$HOST" 'sha256sum "$HOME/muneiserver.xsrv.jp/public_html/kenpo/community.php"' | cut -d ' ' -f1)
if [[ "$REMOTE_HASH" != 'c1dcd8cdb8490d7b338f88472a4d1ecc74bf83ef8de087f36221134d7df53d9d' && "$REMOTE_HASH" != 'd2061a2730336bbf4e6fe13aedf04edef72307c0aa51e69012675533a27bf04c' && "$REMOTE_HASH" != '8f6e83a10f8db18e6ce738385b00d6d37895df24baad3ffb05fe20e589fe3909' && "$REMOTE_HASH" != '03932b0ab032611935bbd70cca00338d261c41701cb6fcedb112821eceaad976' && "$REMOTE_HASH" != '96b1d76e6b423cc256a0bbc93b73c0a6c9803f5422d2a24230ce11b11f4f12a0' && "$REMOTE_HASH" != '0852acafdb792a85ff7ddae8a526df6031258aaffd671e46f79dc572181b2bfb' && "$REMOTE_HASH" != 'a825fef9aa6059bc7c7ec5e514f874e06cb36e2f7dba3961acd4c36526837623' && "$REMOTE_HASH" != '7ccd535c4ede8d4f6c55c13be585953efaff853b51ff547763ba636852fb3f78' && "$REMOTE_HASH" != 'e7c9a24ec15ca691a9930344f141ac2d14f24362f5df52b2dcc947573130f445' && "$REMOTE_HASH" != 'a068dd1003f0fb9ed9ecc8e1d8053e3624e5d5cc07f91678060bdf3bbe65ccd4' && "$REMOTE_HASH" != '67537a5e3364ffdc2e7ba96f8a2d25562f833655e5bd4939dcb6ef7dfe57c19f' && "$REMOTE_HASH" != 'aaaabb5cc823a94e38dbc39f447c74a93e46e1ac5fbe57abbb99da814ee79529' && "$REMOTE_HASH" != 'b82eedbf4dc59a952459e738b4116db78841eb63bf84a0b1295c17b337b36371' && "$REMOTE_HASH" != 'ada6d20eeeaf6e1cd8982b6e33bda38e6c73aed4543516d09cef9923702ef5e7' ]]; then
 printf 'コメント機能が別に更新されています。確認のため公開を停止します。\n'
 exit 1
fi
printf '\n公開中のページを、非公開の場所へバックアップします。\n'
ssh "${SSH_OPTS[@]}" "$HOST" "umask 077; mkdir -p \"\$HOME/kenpo-backups\"; cp -a \"\$HOME/muneiserver.xsrv.jp/public_html/kenpo\" \"\$HOME/kenpo-backups/kenpo-$STAMP\""
printf '\nページと動画を転送しています。\n'
scp "${SCP_OPTS[@]}" "$ARCHIVE" "$HOST:$REMOTE_ARCHIVE"
ssh "${SSH_OPTS[@]}" "$HOST" "set -e; unzip -tq \"\$HOME/$REMOTE_ARCHIVE\"; unzip -oq \"\$HOME/$REMOTE_ARCHIVE\" -d \"\$HOME/muneiserver.xsrv.jp/public_html/kenpo\"; chmod 755 \"\$HOME/muneiserver.xsrv.jp/public_html/kenpo\" \"\$HOME/muneiserver.xsrv.jp/public_html/kenpo/assets\"; find \"\$HOME/muneiserver.xsrv.jp/public_html/kenpo\" -maxdepth 2 -type f \\( -name '*.html' -o -name '*.mp4' -o -name '*.png' \\) -exec chmod 644 {} +"
ssh "${SSH_OPTS[@]}" "$HOST" 'php -l "$HOME/muneiserver.xsrv.jp/public_html/kenpo/community.php"'
printf '\n公開URLのページ・動画を確認します。\n'
ssh "${SSH_OPTS[@]}" "$HOST" 'set -e; for page in preamble.html index.html article1.html article2.html article3.html article4.html article5.html article6.html article7.html article8.html article9.html article10.html article11.html article12.html article13.html article14.html article15.html article16.html article17.html article18.html article20.html article21.html article22.html article23.html article24.html article25.html article26.html article27.html article28.html article29.html article30.html article31.html article32.html article33.html article34.html article35.html article36.html article37.html article38.html article39.html article40.html article41.html article42.html article43.html article44.html article45.html article46.html article47.html article48.html article49.html article50.html article51.html article52.html article53.html article54.html article55.html article56.html article57.html article58.html article59.html article60.html article61.html article62.html article63.html article64.html article65.html article66.html article67.html article68.html article69.html article70.html article71.html article72.html article73.html article74.html article75.html article76.html article77.html article78.html article79.html article80.html article81.html article82.html article83.html article84.html article85.html article86.html article87.html article88.html article89.html article90.html article91.html article92.html article93.html article94.html article95.html article96.html article97.html article98.html article99.html article100.html article101.html article102.html article103.html; do curl --fail --silent --show-error "https://muneiserver.xsrv.jp/kenpo/$page" -o /dev/null; done; for movie in preamble.mp4 article1.mp4 article2.mp4 article3.mp4 article4.mp4 article5.mp4 article7.mp4 article8.mp4 article9.mp4 article10.mp4 article11.mp4 article12.mp4 article13.mp4 article14.mp4 article15.mp4 article16.mp4 article17.mp4 article18.mp4 article56.mp4 article57.mp4 article58.mp4 article59.mp4 article60.mp4 article61.mp4 article62.mp4 article63.mp4 article64.mp4 article65.mp4 article66.mp4 article67.mp4 article68.mp4 article69.mp4 article70.mp4 article71.mp4 article72.mp4 article73.mp4 article74.mp4 article75.mp4 article76.mp4 article77.mp4 article78.mp4 article79.mp4 article80.mp4 article81.mp4 article82.mp4 article83.mp4 article84.mp4 article85.mp4 article86.mp4 article87.mp4 article88.mp4 article89.mp4 article90.mp4 article91.mp4 article92.mp4 article93.mp4 article94.mp4 article95.mp4 article96.mp4 article97.mp4 article98.mp4 article99.mp4 article100.mp4 article101.mp4 article102.mp4 article103.mp4; do curl --fail --silent --show-error --range 0-1023 "https://muneiserver.xsrv.jp/kenpo/assets/$movie" -o /dev/null; done'
printf '\n公開が完了しました。\nhttps://muneiserver.xsrv.jp/kenpo/preamble.html\nバックアップ: kenpo-backups/kenpo-%s\n' "$STAMP"

