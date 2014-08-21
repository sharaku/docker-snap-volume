docker-snap-volume
==================

# �͂��߂�
docker�ɂ�����VOLUME�R���e�i��snapshot���Ƃ�@�\��񋟂���R���e�i�ł��B  
snapshot�ɂ�rsync���g�p���Ă���A�����k�ŃR�s�[���쐬����܂��B�������A�O���snapshot���獷�����Ȃ��t�@�C���͑O���snapshot�ɑ΂��ăn�[�h�����N���s���邽�߃f�B�X�N����͂���܂���B  
snapshot�̃f�B���N�g���`����`@GMT-2014.08.01-00.00.00`�ƂȂ�܂��B

snapshot���s�v�ł���ꍇ�́Asharaku/snap-volume���g�p�����A�V���v����VOLUME�R���e�i���g�p���܂��悤�B

�g����
------
# Installation
�ȉ��̂悤��docker image��pull���܂��B

    docker pull sharaku/snap-volume

Docker image�������ō\�z���邱�Ƃ��ł��܂��B

    git clone https://github.com/sharaku/docker-snap-volume.git
    cd docker-snap-volume
    docker build --tag="$USER/snap-volume" .

# Quick Start
snap-volume��image�����s���܂��B

    docker run -d \
      --name example-vol \
      -v /path/to/data:/path/to/container/data:rw \
      -v /path/to/data:/path/to/container/snap-vol:rw \
      -e "VOLUME_DATA=/path/to/container/data" -e "VOLUME_SNAP=/path/to/container/snap-vol" \
      -e "SNAP_MAX=128" -e "SNAP_CRON=0 3 * * *" sharaku/snap-volume

snap-volume���R���e�i�Ɍ��J���܂��B

    docker run -d --volumes-from example-vol  docker-image

## Argument

+   `-v /path/to/data:/path/to/container/data:rw` :  
    �i���I�ɕۑ�����f�[�^�̃f�B���N�g�����w�肵�܂��B
 
+   `-v /path/to/data:/path/to/container/snap-vol:rw` :  
    snapshot�̎��Ƀf�B���N�g�����w�肵�܂��B

+   `VOLUME_DATA"` :  
    �i���I�ɕۑ�����f�[�^�̃f�B���N�g����VOLUME_DATA�֐ݒ肵�Ă��������B�w�肵�Ȃ��ꍇ��**/opt/data**���g�p����܂��B

+   `VOLUME_SNAP` :  
    snapshot�̎��Ƀf�B���N�g����VOLUME_SNAP�֐ݒ肵�Ă��������B�w�肵�Ȃ��ꍇ��**/opt/.snap**���g�p����܂��B

+   `SNAP_MAX` :  
    snapshot�̐��㐔���w�肵�܂��B�����Ŏw�肵���ȏ��snapshot�͍폜����܂��B�w�肵�Ȃ��ꍇ��**128**���g�p����܂��B

+   `SNAP_CRON` :  
    snapshot�̎�̎��Ԃ��w�肵�܂��B�w���crontab�Ɠ���ł��B�w�肵�Ȃ��ꍇ��0 3 * * * (GMT 03:00)���g�p����܂��B

���p��
------
# mysql
mysql�̃f�[�^���z�X�g��/export/data/mysql�֕ۑ����Asnapshot��/export/.snapshot/mysql�֍̎悷���ł��B

    docker run -d \
      --name mysql-vol \
      -v /export/data/mysql:/var/lib/mysql:rw \
      -v /export/.snapshot/mysql:/opt/snap-vol:rw \
      -e "VOLUME_DATA=/var/lib/mysql" -e "VOLUME_SNAP=/opt/snap-vol" sharaku/snap-volume

    docker pull mysql

    docker run -d \
      --volumes-from mysql-vol \
      -e "MYSQL_ROOT_PASSWORD=passwd" -p 3306:3306 mysql

`-v /export/data/mysql:/var/lib/mysql:rw`�̓z�X�g��/export/data/mysql�f�B���N�g����/var/lib/mysql�Ƃ��Ďw�肵�Ă��܂��B
���̌�A`--volumes-from mysql-vol`�ɂ�mysql�R���e�i�֌��J����܂��B

`-v /export/.snapshot/mysql:/opt/snap-vol:rw`��/export/.snapshot/mysql�f�B���N�g����snapshot�i�[��Ƃ��Ďw�肵�Ă��܂��B���̃f�B���N�g���ɑ΂��āAsnapshot���i�[����܂��B
