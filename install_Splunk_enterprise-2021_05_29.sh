#!/bin/bash
echo
echo '##############################################'
echo '#                                            #'
echo '# Welcome to the Splunk 8.1.4 auto-installer #'
echo '# for RHEL/CentOS 7 x64.                     #'
echo '# Last updated 05/29/2021.                   #'
echo '#                                            #'
echo '##############################################'
echo

## Grab hostname variable ##
splunkHost=`hostname`

##  Create Linux User ##
echo "Enter the username for the splunk OS user account (default: splunk)"
read splunkUsername
echo "Enter the group for the splunk OS user account (default: splunk)"
read splunkGroup
splunkUsername="${splunkUsername:=splunk}"
splunkGroup="${splunkGroup:=splunk}"
useradd -m $splunkUsername
usermod -d /opt/splunk $splunkUsername
echo "Splunk linux user created: $splunkUsername:$splunkGroup"
## END Create Linux User ##

#DISABLING AS IT IS NOT NEEDED CURRENTLY
## Create Splunk account admin password ##
#echo
#echo "Enter a password for the Splunk administrator account. Must be 8 characters in length (default: changethis123)"
#read adminPass
#adminPass="${adminPass:=changethis123}"
#echo
## END Create Splunk account admin password ##

#DISABLING FOR CORE CONSULTANT LAB 1
## Disable THP/Ulimits/Linux Tuning ##
#echo "Disabling Transparent Huge Pages (THP)"
#echo "never" > /sys/kernel/mm/transparent_hugepage/enabled
#echo "never" > /sys/kernel/mm/transparent_hugepage/defrag
#touch /etc/systemd/system/disable-thp.service
#grep -qxF "[Unit]" /etc/systemd/system/disable-thp.service || echo "[Unit]" >> /etc/systemd/system/disable-thp.service
#grep -qxF "Description=Disable Transparent Huge Pages" /etc/systemd/system/disable-thp.service || echo "Description=Disable Transparent Huge Pages" >> /etc/systemd/system/disable-thp.service
#echo "" >> /etc/systemd/system/disable-thp.service
#grep -qxF "[Service]" /etc/systemd/system/disable-thp.service || echo "[Service]" >> /etc/systemd/system/disable-thp.service
#grep -qxF "Type=simple" /etc/systemd/system/disable-thp.service || echo "Type=simple" >> /etc/systemd/system/disable-thp.service
#grep -qxF 'ExecStart=/bin/sh -c "echo never > /sys/kernel/mm/transparent_hugepage/enabled && echo never > /sys/kernel/mm/transparent_hugepage/defrag"' /etc/systemd/system/disable-thp.service || echo 'ExecStart=/bin/sh -c "echo never > /sys/kernel/mm/transparent_hugepage/enabled && echo never > /sys/kernel/mm/transparent_hugepage/defrag"' >> /etc/systemd/system/disable-thp.service
#echo "" >> /etc/systemd/system/disable-thp.service
#grep -qxF "[Install]" /etc/systemd/system/disable-thp.service || echo "[Install]" >> /etc/systemd/system/disable-thp.service
#grep -qxF "WantedBy=multi-user.target" /etc/systemd/system/disable-thp.service || echo "WantedBy=multi-user.target" >> /etc/systemd/system/disable-thp.service
#systemctl daemon-reload
#systemctl start disable-thp
#systemctl enable disable-thp
#echo "Transparent Huge Pages (THP) Disabled."
#echo
#echo "Setting vm.swappiness to 5."
#touch /etc/sysctl.d/99-splunk.conf
#grep -qxF "vm.swappiness=5" /etc/sysctl.d/99-splunk.conf || echo "vm.swappiness=5" >> /etc/sysctl.d/99-splunk.conf
#sysctl -p
#echo "Swappiness value set to 5 in /etc/sysctl.d/99-splunk.conf"
#echo
#echo "Setting ulimits in systemd"
#ulimit -n 65535; ulimit -u 20480; ulimit -f unlimited
#runuser -l splunk -c "ulimit -n 65535; ulimit -u 20480; ulimit -f unlimited"
#grep -qxF "DefaultLimitNOFILE=65535" /etc/systemd/system.conf || echo "DefaultLimitNOFILE=65535" >> /etc/systemd/system.conf
#grep -qxF "DefaultLimitFSIZE=-1" /etc/systemd/system.conf || echo "DefaultLimitFSIZE=-1" >> /etc/systemd/system.conf
#grep -qxF "DefaultLimitNPROC=-1" /etc/systemd/system.conf || echo "DefaultLimitNPROC=-1" >> /etc/systemd/system.conf
#echo
#echo "Setting ulimits in limits.d"
#touch /etc/security/limits.d/99-splunk.conf
#grep -qxF "$splunkUsername hard core 0" /etc/security/limits.d/99-splunk.conf || echo "$splunkUsername hard core 0" >> /etc/security/limits.d/99-splunk.conf
#grep -qxF "$splunkUsername hard maxlogins 10" /etc/security/limits.d/99-splunk.conf || echo "$splunkUsername hard maxlogins 10" >> /etc/security/limits.d/99-splunk.conf
#grep -qxF "$splunkUsername soft nofile 65535" /etc/security/limits.d/99-splunk.conf || echo "$splunkUsername soft nofile 65535" >> /etc/security/limits.d/99-splunk.conf
#grep -qxF "$splunkUsername hard nofile 65535" /etc/security/limits.d/99-splunk.conf || echo "$splunkUsername hard nofile 65535" >> /etc/security/limits.d/99-splunk.conf
#grep -qxF "$splunkUsername soft nproc 20480" /etc/security/limits.d/99-splunk.conf || echo "$splunkUsername soft nproc 20480" >> /etc/security/limits.d/99-splunk.conf
#grep -qxF "$splunkUsername hard nproc 20480" /etc/security/limits.d/99-splunk.conf || echo "$splunkUsername hard nproc 20480" >> /etc/security/limits.d/99-splunk.conf
#grep -qxF "$splunkUsername soft fsize unlimited" /etc/security/limits.d/99-splunk.conf || echo "$splunkUsername soft fsize unlimited" >> /etc/security/limits.d/99-splunk.conf
#grep -qxF "$splunkUsername hard fsize unlimited" /etc/security/limits.d/99-splunk.conf || echo "$splunkUsername hard fsize unlimited" >> /etc/security/limits.d/99-splunk.conf
#echo "ulimit values set."
#echo
## END Disable THP/Ulimits Linux Tuning ##

## Install WGET ##
echo "Installing wget (if missing) and downloading Splunk Enterprise"
yum install wget -y
## END Install WGET ##

## Download Splunk Installer ##
cd /tmp
wget -O splunk-8.1.4-17f862b42a7c-Linux-x86_64.tgz 'https://www.splunk.com/bin/splunk/DownloadActivityServlet?architecture=x86_64&platform=linux&version=8.1.4&product=splunk&filename=splunk-8.1.4-17f862b42a7c-Linux-x86_64.tgz&wget=true'
echo "Splunk Downloaded."
## END Download Splunk Installer ##

## Install Splunk ##
echo
echo "Extracting splunk to /opt/splunk/"
tar -xzvf /tmp/splunk-8.1.4-17f862b42a7c-Linux-x86_64.tgz -C /opt
rm -f /tmp/splunk-8.1.4-17f862b42a7c-Linux-x86_64.tgz
echo
echo "Splunk installed."
## END Install Splunk ##

## Uncomment the lines below to enable SSL during install.
## Do not uncomment these lines if you plan to use custom certs, please configure manually.
#echo
#touch /opt/splunk/etc/system/local/web.conf
#grep -qxF "[settings]" /opt/splunk/etc/system/local/web.conf || echo "[settings]" >> /opt/splunk/etc/system/local/web.conf
#grep -qxF "enableSplunkWebSSL = true" /opt/splunk/etc/system/local/web.conf || echo "enableSplunkWebSSL = true" >> /opt/splunk/etc/system/local/web.conf
#echo
#echo "HTTPS enabled for Splunk Web."
echo

## Set file/directory permissions for Splunk user ##
chown -R $splunkUsername:$splunkGroup /opt/splunk
## END Set file/directory permissions for Splunk user ##

## Set Linux Firewall Rules ##
afz=`firewall-cmd --get-active-zone | head -1`
# Open Web port
firewall-cmd --zone=$afz --add-port=8000/tcp --permanent
# Open splunkd port
firewall-cmd --zone=$afz --add-port=8089/tcp --permanent
# Open indexing receiving port
firewall-cmd --zone=$afz --add-port=9997/tcp --permanent
# Open search replication port
firewall-cmd --zone=$afz --add-port=8181/tcp --permanent
# Open indexer replication port
firewall-cmd --zone=$afz --add-port=8080/tcp --permanent
# Open kv store/replication port
firewall-cmd --zone=$afz --add-port=8191/tcp --permanent
# Open app server port
firewall-cmd --zone=$afz --add-port=8065/tcp --permanent
firewall-cmd --reload
echo
echo "Splunk firewall ports opened."
## END Set Linux Firewall Rules ##

## First start of Splunk as splunkUsername ##
echo
#runuser -l $splunkUsername -c "/opt/splunk/bin/splunk start --accept-license --answer-yes --no-prompt --seed-passwd $adminPass"
runuser -l $splunkUsername -c "/opt/splunk/bin/splunk start --accept-license --answer-yes"
/opt/splunk/bin/splunk enable boot-start -user $splunkUsername
echo
runuser -l $splunkUsername -c '/opt/splunk/bin/splunk stop'
chown root:$splunkGroup /opt/splunk/etc/splunk-launch.conf
chmod 644 /opt/splunk/etc/splunk-launch.conf

## Get custom servername, or use default of hostname command output ##
echo "Enter name for this server:"
read serverName
serverName="${serverName:=$splunkHost}"
## END - Get custom servername, or use default of hostname command output ##

## Update server.conf serverName value with input from previous step ##
sed -i -e 's/serverName = .*/serverName = '$serverName'/g' /opt/splunk/etc/system/local/server.conf
## END - Update server.conf serverName value with input from previous step ##

#  Check to make sure default host value is set, if not, set it now
if [[ -f /opt/splunk/etc/system/local/inputs.conf ]]
        then
                break
        else
                echo "Setting default host value for Splunk..."
                echo "[default]" > /opt/splunk/etc/system/local/inputs.conf
                echo "host = $serverName" >> /opt/splunk/etc/system/local/inputs.conf
                cat /opt/splunk/etc/system/local/inputs.conf
        fi

echo
echo "Splunk test start and stop complete. Enabled Splunk to start at boot. Also, adjusted splunk-launch.conf to mitigate privilege escalation attack."
echo
runuser -l $splunkUsername -c "/opt/splunk/bin/splunk start"
if [[ -f /opt/splunk/bin/splunk ]]
        then
                echo Splunk Enterprise
                cat /opt/splunk/etc/splunk.version | head -1
                echo "has been installed, configured, and started!"
                echo "Visit the Splunk server using https://hostNameORip:8000 as mentioned above."
                echo
                echo
                echo "                        HAPPY SPLUNKING!!!"
                echo
                echo
        else
                echo Splunk Enterprise has FAILED install!
        fi
## END First start of Splunk as splunkUsername ##
#End of File