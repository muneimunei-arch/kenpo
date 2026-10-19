<?php
declare(strict_types=1);
header('Content-Type: application/json; charset=utf-8');header('Cache-Control: no-store');header('X-Content-Type-Options: nosniff');$origin=$_SERVER['HTTP_ORIGIN']??'';$allowed=$origin==='https://kenpo-snowy.vercel.app'||preg_match('/^https:\/\/kenpo-snowy(?:-[a-z0-9-]+)*\.vercel\.app$/',$origin);if($allowed){header('Access-Control-Allow-Origin: '.$origin);header('Vary: Origin');}if(($_SERVER['REQUEST_METHOD']??'GET')==='OPTIONS'){if(!$allowed){http_response_code(403);exit;}header('Access-Control-Allow-Methods: GET, POST, OPTIONS');header('Access-Control-Allow-Headers: Content-Type');exit;}
ini_set('display_errors','0');session_set_cookie_params(['secure'=>true,'httponly'=>true,'samesite'=>'Strict','path'=>'/kenpo/']);session_start();
function reply($data,$code=200){http_response_code($code);echo json_encode($data,JSON_UNESCAPED_UNICODE);exit;}
function fail($message,$code=400){reply(['error'=>$message],$code);}
try{
$root=dirname(__DIR__,3).'/kenpo-private';$config=json_decode(file_get_contents($root.'/config.json'),true,512,JSON_THROW_ON_ERROR);
$db=new PDO('sqlite:'.$root.'/community.sqlite');$db->setAttribute(PDO::ATTR_ERRMODE,PDO::ERRMODE_EXCEPTION);$db->exec('PRAGMA busy_timeout=5000');
$db->exec('CREATE TABLE IF NOT EXISTS comments(id INTEGER PRIMARY KEY AUTOINCREMENT, article TEXT NOT NULL,nickname TEXT NOT NULL,body TEXT NOT NULL,created TEXT NOT NULL); CREATE TABLE IF NOT EXISTS claims(article TEXT PRIMARY KEY,body TEXT NOT NULL,updated TEXT NOT NULL); CREATE TABLE IF NOT EXISTS limits(bucket TEXT PRIMARY KEY, stamp INTEGER NOT NULL, count INTEGER NOT NULL)');
$columns=$db->query('PRAGMA table_info(comments)')->fetchAll(PDO::FETCH_COLUMN,1);if(!in_array('deleted',$columns,true))$db->exec('ALTER TABLE comments ADD COLUMN deleted INTEGER NOT NULL DEFAULT 0');
if(empty($_SESSION['csrf']))$_SESSION['csrf']=bin2hex(random_bytes(32));
$action=$_GET['action']??'read';$input=[];
if($_SERVER['REQUEST_METHOD']==='POST'){
 if((int)($_SERVER['CONTENT_LENGTH']??0)>12000)fail('入力が大きすぎます。');
 $input=json_decode(file_get_contents('php://input'),true)??[];
 if(!$allowed&&!hash_equals($_SESSION['csrf'],(string)($input['csrf']??'')))fail('ページを再読み込みしてください。',403);
}
$article=(string)($_GET['article']??$input['article']??'19');if(!in_array($article,['preamble','1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16','17','18','19','20','21','22','23','24','25','26','27','28','29','30','31','32','33','34','35','36','37','38','39','40','41','42','43','44','45','46','47','48','49','50','51','52','53','54','55','56','57','58','59','60','61','62','63','64','65','66','67','68','69','70','71','72','73','74','75','76','77','78','79','80','81','82','83','84','85','86','87','88','89','90','91','92','93','94','95','96','97','98','99','100','101','102','103'],true))fail('記事が見つかりません。');
function throttle($db,$key,$window,$max){$now=time();$db->exec('BEGIN IMMEDIATE');try{$q=$db->prepare('SELECT stamp,count FROM limits WHERE bucket=?');$q->execute([$key]);$row=$q->fetch(PDO::FETCH_ASSOC);$count=$row&&$now-(int)$row['stamp']<$window?(int)$row['count']+1:1;$stamp=$count===1?$now:(int)$row['stamp'];$q=$db->prepare('INSERT OR REPLACE INTO limits VALUES(?,?,?)');$q->execute([$key,$stamp,$count]);$db->exec('COMMIT');if($count>$max)fail('少し時間を置いてからお試しください。',429);}catch(Throwable $e){if($db->inTransaction())$db->rollBack();throw $e;}}
$ip=hash_hmac('sha256',$_SERVER['REMOTE_ADDR']??'', $config['salt']);
if($action==='read'){
 $before=max(0,(int)($_GET['before']??0));$q=$db->prepare('SELECT id,nickname,body,created FROM comments WHERE article=? AND deleted=0'.($before>0?' AND id<?':'').' ORDER BY id DESC LIMIT 51');$q->execute($before>0?[$article,$before]:[$article]);$comments=$q->fetchAll(PDO::FETCH_ASSOC);$more=count($comments)>50;if($more)array_pop($comments);
 reply(['csrf'=>$_SESSION['csrf'],'comments'=>$comments,'more'=>$more]);
}
if($_SERVER['REQUEST_METHOD']!=='POST')fail('この操作は投稿が必要です。',405);
$body=trim((string)($input['body']??''));
if($action==='comment'){
 $name=trim((string)($input['nickname']??''));if(mb_strlen($name)<1||mb_strlen($name)>300||mb_strlen($body)<1||mb_strlen($body)>300)fail('ニックネームとコメントを、それぞれ1〜300文字で入力してください。');
 throttle($db,'comment-'.$ip,60,3);$q=$db->prepare('INSERT INTO comments(article,nickname,body,created) VALUES(?,?,?,?)');$q->execute([$article,$name,$body,gmdate('c')]);reply(['ok'=>true]);
}
fail('操作が見つかりません。',404);
}catch(Throwable $e){error_log('kenpo community: '.$e->getMessage());reply(['error'=>'保存サービスに接続できません。時間を置いてお試しください。'],500);}
