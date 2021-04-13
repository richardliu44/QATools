#!/bin/bash

FILE=/usr/local/***/var/mc/server_data/prefs/***.xml
AV_PASSWORD=YOUR_PASSWORD
AV_IP=`ifconfig | grep "inet addr" | grep -v "127.0.0.1" | awk -F " " '{print $2}' | awk -F : '{print $2}'`

#Clear the screen
tput clear

#Move cursor to screen location X,Y (top left is 0,0)
tput cup 3 15

#Set a foreground colour using ANSI escape
tput setaf 3
echo "MC QA scripts"
tput sgr0

tput cup 4 15
tput setaf 3
echo "Author: richardliu44@hotmail.com"
tput sgr0


tput cup 5 15
#Set reverse video mode
tput rev
echo "MAIN - MENU"
tput sgr0

tput cup 7 15
echo "1. Enable to add vCenter without certificate(ignore_vc_cert in ***.xml)"

tput cup 8 15
echo "2. Enable replication"

tput cup 9 15
echo "3. Enable migration"

tput cup 10 15
echo "4. Download **** Upgrade AVP"

tput cup 11 15
echo "5. Restart *** service & record stop/start time."

tput cup 12 15
echo "6. Exit"

#Set bold mode
tput bold
tput cup 13 15
read -p "Please enter your choice: [1-6]" choice

case $choice in
    1)
	    echo "It is going to change "ignore_vc_cert" value from false to true then restart *** service..."
		dpnctl stop mcs
		line=`cat -n $FILE | grep ignore_vc_cert | awk -F " " '{print $1}'`
        sed -i "$line s/false/true/g" $FILE
        echo `grep ignore_vc_cert $FILE`
		dpnctl start mcs
		;;
	2)  
	    echo "It is going to change "allow_dest_replica_management" value from false to true then restart *** service..."
		dpnctl stop mcs
        line=`cat -n $FILE | grep allow_dest_replica_management | awk -F " " '{print $1}'`
		sed -i "$line s/false/true/g" $FILE
		echo `grep allow_dest_replica_management $FILE`
		dpnctl start mcs
		;;
	3)  
        echo "It is going to change "src_driven_migrate" value from true to false, add <entry key="migrate_feature_enabled" value="true" /> then download SessionSecurityConfigration AVP..."
		#dpnctl stop mcs
		#1.Change src_driven_migrate value to false.
        echo "Changing src_driven_migrate value from true to false..." 
        src_driven_migrate_line=`cat -n $FILE | grep src_driven_migrate | awk -F " " '{print $1}'`
        sed -i "$src_driven_migrate_line s/true/false/g" $FILE
        echo `grep src_driven_migrate $FILE` 	
		
		#2.add <entry key="migrate_feature_enabled" value="true" /> to the end of <node name="migrate">
        migrate_adhoc_priority_line=`cat -n $FILE | grep migrate_adhoc_priority | awk -F " " '{print $1}'`
        migrate_feature_enabled_line=$(($migrate_adhoc_priority_line+1))
        echo migrate_feature_enabled shoule be added to the line $migrate_feature_enabled_line 
        echo "Adding <entry key="migrate_feature_enabled" value="true" /> to the line $migrate_feature_enabled_line..." 
        sed -i ''$migrate_feature_enabled_line"i"' \             \ <entry key="migrate_feature_enabled" value="true" />' $FILE
        echo `grep migrate_feature_enabled $FILE` 
		
		#3.Change use_ddr_auth_token value to false.
        echo "Changing use_ddr_auth_token value from true to false..." | tee -a $LOG
        use_ddr_auth_token_line=`cat -n $FILE | grep use_ddr_auth_token | awk -F " " '{print $1}'`
        sed -i "$use_ddr_auth_token_line s/true/false/g" $FILE
        echo `grep use_ddr_auth_token $FILE`
        
		#dpnctl start mcs
		
		#download SessionSecurityConfigration AVP
		av_server_version=`avmgr --version | grep version | grep -v OS | awk -F : '{print $2}' | awk -F - '{print $1}' | sed s/[[:space:]]//g`
        av_server_build=`avmgr --version | grep version | grep -v OS | awk -F : '{print $2}' | awk -F - '{print $2}'`
		
        echo "**** Server verison is $av_server_version-$av_server_build"
		#Stop firewall
		/usr/bin/expect <<EOF
        spawn su - root -c "rcSuSEfirewall2 stop"
        expect "Password:"
        send "$AV_PASSWORD\r"
        expect eof
EOF
		
		#Wget SessionSecurityConfigration AVP
		/usr/bin/expect <<EOF
		set timeout 600
		spawn su - root -c "wget http://YOUR_BUILD_SERVER/builds/v$av_server_version.$av_server_build/PACKAGES/SessionSecurityConfiguration-$av_server_version-$av_server_build.avp -P /data01/avamar/repo/packages/"
		expect "Password:"
		send "$AV_PASSWORD\r"
		expect {
		"*404" { send_user "Failed to download SessionSecurityConfiguration-$av_server_version-$av_server_build.avp, please check the log above."}
		"*saved" { send_user "Now, please log in to https://$AV_IP/avi/avigui.html and install SessionSecurityConfiguration-$av_server_version-$av_server_build.avp"}
		}
		expect eof
EOF
		echo " "
		;;
	4)	
	    echo "It is going to downlaod the Upgrade AVP. Before that, you need to input the *** Upgrade AVP version and build number. For example, 7.5.1.101, we define 7.5.1 as VERSION number and 101 as BUILD number."
		read -p "Please input the VERSION number you want to upgrade: (eg.18.1.0; press ENTER for default version:18.1.0):" verison
		verison=${verison:-18.1.0}
		read -p "Please input the BUILD number you want to upgrade: (eg. 88)" build
		#Stop firewall
		/usr/bin/expect <<EOF
        spawn su - root -c "rcSuSEfirewall2 stop"
        expect "Password:"
        send "$AV_PASSWORD\r"
        expect eof
EOF

        #wget Upgrade AVP
		[[ `hostname -f` =~ "BUILD_SERVER_KEYWORD_1" ]] &&
		/usr/bin/expect		<<EOF
		set timeout 600
		spawn su - root -c "wget http://YOUR_BUILD_SERVER_1/builds/v$verison.$build/PACKAGES/****Upgrade-$verison-$build.avp -P /****/****/repo/packages/"
		expect "Password:"
		send "$AV_PASSWORD\r"
		expect {
		"*404" { send_user "Failed to download ****Upgrade-$verison-$build.avp, please check the log above."}
		"*saved" { send_user "Now, please log in to https://$AV_IP/avi/avigui.html and install ****Upgrade-$verison-$build.avp"}
		}
		expect eof
EOF
        echo " "
		
		[[ `hostname -f` =~ "BUILD_SERVER_KEYWORD_2" ]] &&
		/usr/bin/expect		<<EOF
		set timeout 600
		spawn su - root -c "wget http://YOUR_BUILD_SERVER_2/builds/v$verison.$build/PACKAGES/****Upgrade-$verison-$build.avp -P /****/repo/packages/"
		expect "Password:"
		send "$AV_PASSWORD\r"
		expect {
		"*404" { send_user "Failed to download ****Upgrade-$verison-$build.avp, please check the log above."}
		"*saved" { send_user "Now, please log in to https://$AV_IP/avi/avigui.html and install ****Upgrade-$verison-$build.avp"}
		}
		expect eof
EOF
        echo " "
		;;
	5)
        echo "It is going to restart MCS service and record stop/start time respectively."
		mcs_stop_starttime=`date +'%Y-%m-%d %H:%M:%S'`
        echo "Begin to stop MCS on `date`"
        dpnctl stop mcs
        echo "Finish to stop MCS on `date`"
        mcs_stop_endtime=`date +'%Y-%m-%d %H:%M:%S'`
        mcs_stop_starttime_seconds=$(date --date="$mcs_stop_starttime" +%s)
        mcs_stop_endtime_seconds=$(date --date="$mcs_stop_endtime" +%s)
        echo "MCS stop total time is "$((mcs_stop_endtime_seconds-mcs_stop_starttime_seconds))"s"

        mcs_start_starttime=`date +'%Y-%m-%d %H:%M:%S'`
        echo "Begin to start MCS on `date`"
        dpnctl start mcs
        echo "Finish to start MCS on `date`"
        mcs_start_endtime=`date +'%Y-%m-%d %H:%M:%S'`

        mcs_start_start_seconds=$(date --date="$mcs_start_starttime" +%s)
        mcs_start_end_seconds=$(date --date="$mcs_start_endtime" +%s)
        echo "MCS start total time is "$((mcs_start_end_seconds-mcs_start_start_seconds))"s"

        echo "MCS restart totoal time is "$((mcs_stop_endtime_seconds-mcs_stop_starttime_seconds+mcs_start_end_seconds-mcs_start_start_seconds))"s"	
		;;
	6) 
        echo "Exit!"
        ;;
    ?)  
         echo "Wrong choice, exit."
         exit 1;;
esac	

#tput clear
tput sgr0
#tput rc
 
