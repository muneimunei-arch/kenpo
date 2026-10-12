#!/usr/bin/env python3
from pathlib import Path
import subprocess,sys,datetime
root=Path(__file__).resolve().parents[1]
def git(*args):return subprocess.run(['git',*args],cwd=root,check=True)
# Commit only the site's source directories and documented operation tools.
allowed=['public','server','scripts','README.md','vercel.json','.gitignore','01_GitHubから更新.command','02_GitHubへ保存.command','03_コメントをバックアップ.command']
private_key_marker=b'-----BEGIN PRIVATE'+b' KEY'
for folder in ['public','server','scripts']:
 for p in (root/folder).rglob('*'):
  if p.is_file() and p.suffix in ('.key','.pem','.sqlite','.db'):raise SystemExit('秘密ファイルを検出したため停止しました。')
  if p.is_file() and p.stat().st_size<2_000_000 and private_key_marker in p.read_bytes():raise SystemExit('秘密鍵を検出したため停止しました。')
git('add','--',*allowed)
if subprocess.run(['git','diff','--cached','--quiet'],cwd=root).returncode:
 git('commit','-m','Update constitution site '+datetime.datetime.now().isoformat(timespec='seconds'))
git('pull','--rebase','origin','main')
git('push','origin','main')
print('MacとGitHubの同期が完了しました。')
