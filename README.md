docker-snap-volume
==================

# はじめに
dockerにおけるVOLUMEコンテナとsnapshotをとる機能を提供するコンテナです。  
snapshotにはrsyncを使用しており、無圧縮でコピーが作成されます。ただし、前回のsnapshotから差分がないファイルは前回のsnapshotに対してハードリンクが行われるためディスク消費はありません。  
snapshotのディレクトリ形式は`@GMT-2014.08.01-00.00.00`となります。

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
      -v /path/to/data:/path/to/container/snap-vol:rw \
      -e "VOLUME_DATA=/path/to/container/data" -e "VOLUME_SNAP=/path/to/container/snap-vol" \
      -e "SNAP_MAX=128" -e "SNAP_CRON=0 3 * * *" sharaku/snap-volume

snap-volumeをコンテナに公開します。

    docker run -d --volumes-from example-vol  docker-image

## Argument

+   `-v /path/to/data:/path/to/container/data:rw` :  
    永続的に保存するデータのディレクトリを指定します。
 
+   `-v /path/to/data:/path/to/container/snap-vol:rw` :  
    snapshot採取先にディレクトリを指定します。

+   `VOLUME_DATA"` :  
    永続的に保存するデータのディレクトリをVOLUME_DATAへ設定してください。指定しない場合は**/opt/data**が使用されます。

+   `VOLUME_SNAP` :  
    snapshot採取先にディレクトリをVOLUME_SNAPへ設定してください。指定しない場合は**/opt/.snap**が使用されます。

+   `SNAP_MAX` :  
    snapshotの世代数を指定します。ここで指定した以上のsnapshotは削除されます。指定しない場合は**128**が使用されます。

+   `SNAP_CRON` :  
    snapshot採取の時間を指定します。指定はcrontabと同一です。指定しない場合は0 3 * * * (GMT 03:00)が使用されます。

利用例
------
# mysql
mysqlのデータをホストの/export/data/mysqlへ保存し、snapshotを/export/.snapshot/mysqlへ採取する例です。

    docker run -d \
      --name mysql-vol \
      -v /export/data/mysql:/var/lib/mysql:rw \
      -v /export/.snapshot/mysql:/opt/snap-vol:rw \
      -e "VOLUME_DATA=/var/lib/mysql" -e "VOLUME_SNAP=/opt/snap-vol" sharaku/snap-volume

    docker pull mysql

    docker run -d \
      --volumes-from mysql-vol \
      -e "MYSQL_ROOT_PASSWORD=passwd" -p 3306:3306 mysql

`-v /export/data/mysql:/var/lib/mysql:rw`はホストの/export/data/mysqlディレクトリを/var/lib/mysqlとして指定しています。
その後、`--volumes-from mysql-vol`にてmysqlコンテナへ公開されます。

`-v /export/.snapshot/mysql:/opt/snap-vol:rw`は/export/.snapshot/mysqlディレクトリをsnapshot格納先として指定しています。このディレクトリに対して、snapshotが格納されます。
