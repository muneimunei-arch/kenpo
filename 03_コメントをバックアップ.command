#!/bin/zsh
set -e
cd "$(dirname "$0")"
trap 'printf "処理が止まりました。上のメッセージを確認してください。\n"; read "?Enterで閉じる"' ERR
python3 scripts/backup.py
read "?Enterで閉じる"
