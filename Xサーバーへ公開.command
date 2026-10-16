#!/bin/zsh
set -euo pipefail
BASE='/Users/muneimac/Documents/Codex/2026-10-03/macos-codex-ui-https-learn-chatgpt'
KEY='/Users/muneimac/Desktop/muneimunei/muneiserver.key'
ARCHIVE="$BASE/outputs/constitution-site/kenpo-upload-with40.zip"
HOST='muneiserver@sv17240.xserver.jp'
STAMP=$(date +%Y%m%d-%H%M%S)
REMOTE_ARCHIVE="kenpo-release-$STAMP.zip"
SSH_OPTS=(-i "$KEY" -p 10022 -o ConnectTimeout=20 -o IdentitiesOnly=yes)
SCP_OPTS=(-i "$KEY" -P 10022 -o ConnectTimeout=20 -o IdentitiesOnly=yes)
trap 'printf "\n処理が止まりました。上に表示されたメッセージをご確認ください。\n"; read "?Enterで閉じる"' ERR
[[ -f "$KEY" && -f "$ARCHIVE" ]]
printf '第40条までのページと動画を公開します。接続キーは送信しません。\n'
printf '初回は接続先の確認、鍵に設定されている場合はパスフレーズの入力が必要です。\n'
ssh "${SSH_OPTS[@]}" "$HOST" 'test -d "$HOME/muneiserver.xsrv.jp/public_html/kenpo" && command -v unzip >/dev/null && command -v curl >/dev/null'
printf '\n公開中のページを、非公開の場所へバックアップします。\n'
ssh "${SSH_OPTS[@]}" "$HOST" "umask 077; mkdir -p \"\$HOME/kenpo-backups\"; cp -a \"\$HOME/muneiserver.xsrv.jp/public_html/kenpo\" \"\$HOME/kenpo-backups/kenpo-$STAMP\""
printf '\nページと動画を転送しています。\n'
scp "${SCP_OPTS[@]}" "$ARCHIVE" "$HOST:$REMOTE_ARCHIVE"
ssh "${SSH_OPTS[@]}" "$HOST" "set -e; unzip -tq \"\$HOME/$REMOTE_ARCHIVE\"; unzip -oq \"\$HOME/$REMOTE_ARCHIVE\" -d \"\$HOME/muneiserver.xsrv.jp/public_html/kenpo\"; chmod 755 \"\$HOME/muneiserver.xsrv.jp/public_html/kenpo\" \"\$HOME/muneiserver.xsrv.jp/public_html/kenpo/assets\"; find \"\$HOME/muneiserver.xsrv.jp/public_html/kenpo\" -maxdepth 2 -type f \\( -name '*.html' -o -name '*.mp4' -o -name '*.png' \\) -exec chmod 644 {} +"
printf '\n公開URLのページ・動画を確認します。\n'
ssh "${SSH_OPTS[@]}" "$HOST" 'set -e; for page in index.html article6.html article20.html article21.html article22.html article23.html article24.html article25.html article26.html article27.html article28.html article29.html article30.html article31.html article32.html article33.html article34.html article35.html article36.html article37.html article38.html article39.html article40.html; do curl --fail --silent --show-error "https://muneiserver.xsrv.jp/kenpo/$page" -o /dev/null; done; for movie in article39.mp4 article40.mp4; do curl --fail --silent --show-error --range 0-1023 "https://muneiserver.xsrv.jp/kenpo/assets/$movie" -o /dev/null; done'
printf '\n公開が完了しました。\nhttps://muneiserver.xsrv.jp/kenpo/article40.html\nバックアップ: kenpo-backups/kenpo-%s\n' "$STAMP"
read '?Enterで閉じる'
