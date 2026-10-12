#!/usr/bin/env python3
from pathlib import Path
import subprocess,datetime,os,shlex
root=Path(__file__).resolve().parents[1]
key=Path.home()/'Desktop/おためしよ/muneiserver.key'
host='muneiserver@sv17240.xserver.jp';stamp=datetime.datetime.now().strftime('%Y%m%d-%H%M%S')
remote='/home/muneiserver/kenpo-private/backup-'+stamp
php="$d="+repr(remote)+";mkdir($d,0700);$src=new SQLite3('/home/muneiserver/kenpo-private/community.sqlite');$dst=new SQLite3($d.'/community.sqlite');if(!$src->backup($dst))throw new Exception('backup failed');$dst->close();$src->close();copy('/home/muneiserver/kenpo-private/config.json',$d.'/config.json');chmod($d.'/config.json',0600);chmod($d.'/community.sqlite',0600);"
cmd='php -r '+shlex.quote(php)+' && tar -czf '+shlex.quote(remote+'.tar.gz')+' -C '+shlex.quote(remote)+' community.sqlite config.json && chmod 600 '+shlex.quote(remote+'.tar.gz')
opts=['-i',str(key),'-o','BatchMode=yes','-o','StrictHostKeyChecking=yes','-o','ConnectTimeout=20']
subprocess.run(['ssh',*opts,'-p','10022',host,cmd],check=True)
destination=root.parent/'kenpo-非公開バックアップ';destination.mkdir(mode=0o700,exist_ok=True);os.chmod(destination,0o700)
local=destination/('コメントと管理者設定-'+stamp+'.tar.gz')
subprocess.run(['scp',*opts,'-P','10022',host+':'+remote+'.tar.gz',str(local)],check=True);os.chmod(local,0o600)
print('コメント・管理者の文章と設定を、GitHubに含めずMacへバックアップしました。')
