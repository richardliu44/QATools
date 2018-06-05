#!/bin/bash
av_server_ip=AVAMAR_SERVER_IP
av_client_version=AVAMAR_CLIENT_VERSION(eg.7.5.1)
av_client_build=AVAMAR_CLIENT_BUILD(eg.101)

#Check OS is RedHat/CentOS or SuSE,then download the related client installation package.
if [ -f "/etc/redhat-release" ];then
os=redhat
    echo "OS is $os or centos."
else
os=suse
    echo "OS is $os."
fi

#Remove existing client package.
rm -fr /home/AvamarClient-linux-*.rpm

case $os in
    redhat)
        wget http://YOUR_BUILD_SERVER/builds/v$av_client_version.$av_client_build/RHEL5/AvamarClient-linux-rhel5-x86-$av_client_version-$av_client_build.rpm -P /home
        ;;
    suse)
        wget http://YOUR_BUILD_SERVER/builds/v$av_client_version.$av_client_build/SLES11SP3_64/AvamarClient-linux-sles11sp3-x86_64-$av_client_version-$av_client_build.rpm -P /home
        ;;
    ?)
    echo "unkown OS"
    exit 1;;
esac

#Remove existing client package and install new client
rpm -qa | grep AvamarClient | xargs rpm -e --nodeps;wait
rm -fr /usr/local/avamar
rpm -ivh /home/AvamarClient-linux-*-$av_client_version-$av_client_build.rpm
if [ $? -eq 0 ];then
    echo "Successfully install $av_client_version-$av_client_build.rpm"
else
    echo "Failed to install $av_client_version-$av_client_build.rpm"
fi

#Register and activate the client to Avamar server
/usr/bin/expect <<EOF
set timeout 180
spawn /usr/local/avamar/bin/avregister
expect "Enter the Administrator server address"
send "$av_server_ip\r"
expect "Enter the Avamar server domain"
send "clients\r"
expect {
                "*failed" { send_user "Failed to register Avamar Client, please check the log above."}
                "*Complete" { send_user "Successfully register Client `hostname -f` to Avamar Server $av_server_ip"}
                }
expect eof
EOF
echo " "
