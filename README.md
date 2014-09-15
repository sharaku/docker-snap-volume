docker-snap-volume
==================

# はじめに
dockerにおけるVOLUMEコンテナとsnapshotをとる機能を提供するコンテナです。  
snapshotにはrsyncを使用しており、無圧縮でコピーが作成されます。ただし、前回のsnapshotから差分がないファイルは前回のsnapshotに対してハードリンクが行われるためディスク消費はありません。  
snapshotのディレクトリ形式は`@GMT-YYYY.MM.DD-hh.mm.ss`となります。  

注意点として、このsnapshot機能は本来の瞬間的なsnapshotを提供しません。これは、Write操作との競合が発生しているファイルの内容を保証しないことを意味します。このため、バックアップを行う時間帯のWrite操作を停止する必要があります。

snapshotが不要である場合は、sharaku/snap-volumeを使用せず、シンプルなVOLUMEコンテナを使用しましよう。

使い方
------
# Installation
以下のようにdocker imageをpullします。

    docker pull sharaku/snap-volume

Docker imageを自分で構築することもできます。

    git clone https://github.com/sharaku/docker-snap-volume.git
    cd docker-snap-volume
    docker build --tag="$USER/snap-volume" .

# Quick Start
snap-volumeのimageを実行します。

    docker run -d \
      --name example-vol \
      -v /path/to/data:/path/to/container/data:rw \
      -v /path/to/snapshot:/opt/.snap:rw \
      -e "SNAP_MAX=128" -e "SNAP_CRON=0 3 * * *" sharaku/snap-volume start data:/path/to/container/data

snap-volumeをコンテナに公開します。

    docker run -d --volumes-from example-vol docker-image

## Argument

+   `-v /path/to/data:/path/to/container/data:rw` :  
    永続的に保存するデータのディレクトリを指定します。
 
+   `-v /path/to/snapshot:/opt/.snap:rw` :  
    snapshot保存先ディレクトリを指定します。コンテナ内のsnapshotディレクトリは/opt/.snap固定です。

+   `SNAP_MAX` :  
    snapshotの世代数を指定します。ここで指定した以上のsnapshotは削除されます。指定しない場合は**128**が使用されます。

+   `SNAP_CRON` :  
    snapshot採取の時間を指定します。指定はcrontabと同一です。指定しない場合は0 3 * * * (GMT 03:00)が使用されます。**各国のLOCALTIMEでないことに注意してください。**

# Command line interface
snap-volumeはCLIによって各種操作を提供します。CLIはdocker runの--linkオプションを使用して動作中のsnap-volumeに対して操作します。

    docker run -t --rm=true \
      -v /path/to/data:/path/to/container/data:rw \
      -v /path/to/snapshot:/opt/.snap:rw \
      --link=example-vol:snap-volume sharaku/snap-volume {start|help|show|snapshot|restore} [options]

helpコマンドのみ単独で使用できます。

    docker run -t --rm=true sharaku/snap-volume help

## start {UNIQID:path} ...
snapshot採取を開始します。

+ UNIQID : DATAを識別するための名前です。コンテナ内でユニークな名前を指定してください
+ path   : snapshotを採取する対象pathを指定してください

## help
cliのコマンド一覧を表示します

## show [-a]
採取されたsnapshot一覧を表示します

+ -a : 詳細情報を表示します

## snapshot
最後にstartコマンドで開始したsnapshot情報を元にて手動でsnapshotを採取します

## restore [snapshot]
最後にstartコマンドで開始したsnapshot情報を元にてデータをsnapshotからリストアします

+ snapshot : showコマンドで表示されたsnaapshot(@GMT-YYYY.MM.DD-hh.mm.ss)を指定します

データの保存先
------
# snapshot
コンテナ内では/opt/.snap下に以下のディレクトリが作成されデータが管理されます。

+ snapshot: `@GMT-YYYY.MM.DD-hh.mm.ss`形式のデータが保存されます。
+ snapshot/@GMT-YYYY.MM.DD-hh.mm.ss: startコマンドでしていたUNIQIDディレクトリの下に対応するデータが格納されます。

snap-volumeコンテナ起動時に/opt/.snapを-vオプションで指定することにより、snapshotの保存先を任意で変更できます。

利用例
------
# mysql
## snap-volume開始
mysqlのデータをホストの/export/data/mysqlへ保存し、snapshotを/export/.snapshot/mysqlへ採取する例です。

    docker run -d \
      --name mysql-vol \
      -v /export/data/mysql:/var/lib/mysql:rw \
      -v /export/.snapshot/mysql:/opt/.snap:rw \
      sharaku/snap-volume start mysql:/var/lib/mysql

    docker pull mysql

    docker run -d \
      --volumes-from mysql-vol \
      -e "MYSQL_ROOT_PASSWORD=passwd" -p 3306:3306 mysql

`-v /export/data/mysql:/var/lib/mysql:rw`はホストの/export/data/mysqlディレクトリを/var/lib/mysqlとして指定しています。
その後、`--volumes-from mysql-vol`にてmysqlコンテナへ公開されます。

`-v /export/.snapshot/mysql:/opt/snap-vol:rw`は/export/.snapshot/mysqlディレクトリをsnapshot格納先として指定しています。このディレクトリに対して、snapshotが格納されます。

## リストア
mysqlのデータを特定の時刻に採取したsnapshotへリストアする例です

    docker run -t \
      -v /export/data/mysql:/var/lib/mysql:rw \
      -v /export/.snapshot/mysql:/opt/.snap:rw \
      sharaku/snap-volume show

リストアするsnapshotを決定

    docker run -t \
      -v /export/data/mysql:/var/lib/mysql:rw \
      -v /export/.snapshot/mysql:/opt/.snap:rw \
      sharaku/snap-volume restore @GMT-YYYY.MM.DD-hh.mm.ss


