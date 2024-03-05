#!/bin/bash

cd /etc/yum.repos.d/
echo 1
sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-*
echo 2
sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*
echo 3
cd /root
echo 3_1
yum install -y redhat-lsb-core wget rpmdevtools rpm-build createrepo yum-utils gcc
echo 4
wget https://nginx.org/packages/centos/8/SRPMS/nginx-1.20.2-1.el8.ngx.src.rpm
echo 5
rpm -i nginx-1.*
echo 6
wget https://github.com/openssl/openssl/archive/refs/heads/OpenSSL_1_1_1-stable.zip
echo 7
unzip OpenSSL_1_1_1-stable.zip
echo 8
sed -i 's|--with-debug|--with-debug --with-openssl=/root/openssl-OpenSSL_1_1_1-stable|g' /root/rpmbuild/SPECS/nginx.spec
echo 9
yum-builddep -y /root/rpmbuild/SPECS/nginx.spec
echo 10
rpmbuild -bb /root/rpmbuild/SPECS/nginx.spec
echo 11
yum localinstall -y /root/rpmbuild/RPMS/x86_64/nginx-1.20.2-1.el8.ngx.x86_64.rpm
echo 12
systemctl start nginx
echo 12
mkdir /usr/share/nginx/html/repo
echo 13
cp /root/rpmbuild/RPMS/x86_64/nginx-1.20.2-1.el8.ngx.x86_64.rpm /usr/share/nginx/html/repo
echo 14
wget https://downloads.percona.com/downloads/percona-distribution-mysql-ps/percona-distribution-mysql-ps-8.0.28/binary/redhat/8/x86_64/percona-orchestrator-3.2.6-2.el8.x86_64.rpm -O /usr/share/nginx/html/repo/percona-orchestrator-3.2.6-2.el8.x86_64.rpm
echo 15
createrepo /usr/share/nginx/html/repo/
echo 16
sed -i 's|        index  index.html index.htm;|        index  index.html index.htm; autoindex on;|g' /etc/nginx/conf.d/default.conf
echo 17
nginx -t
echo 18
nginx -s reload
echo 19
curl -a http://localhost/repo/

cat << EOF >/etc/yum.repos.d/otus.repo
[otus]
name=otus-linux
baseurl=http://localhost/repo
gpgcheck=0
enabled=1
EOF

cat /etc/yum.repos.d/otus.repo
yum repolist enabled | grep otus
yum list | grep otus
yum install percona-orchestrator.x86_64 -y
