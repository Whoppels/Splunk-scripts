#!/bin/bash
echo
echo '###################################################'
echo '#                                                 #'
echo '# Splunk Universal Forwarder 8.0.7 auto-installer #'
echo '# for RHEL/CentOS 7 x64.                          #'
echo '# Last updated 11/04/2020.                        #'
echo '#                                                 #'
echo '###################################################'
echo
# Variables:
splunkUsername="splunk"
splunkGroup="splunk"
echo "Creating user:$splunkUsername group:$splunkGroup"
echo
groupadd $splunkGroup
useradd -m $splunkUsername -g $splunkGroup
mkdir -p /opt/splunkforwarder/
usermod -d /opt/splunkforwarder $splunkUsername
echo "Installing wget"
echo
sudo yum --enablerepo=prod install wget-1.14-18.el7_6.1.x86_64 -y
cd /tmp
echo "Download Splunk Forwarder installer"
echo
wget -O splunkforwarder-8.tgz 'https://www.splunk.com/bin/splunk/DownloadActivityServlet?architecture=x86_64&platform=linux&version=8.0.7&product=universalforwarder&filename=splunkforwarder-8.0.7-cbe73339abca-Linux-x86_64.tgz&wget=true'
echo "Install /tmp/splunkforwarder-8.tgz to /opt/splunkforwarder/"
echo
tar -xzvf /tmp/splunkforwarder-8.tgz -C /opt
rm -rf splunkforwarder-8.tgz
chown -R $splunkUsername:$splunkGroup /opt/splunkforwarder
echo "Start Splunk"
echo
runuser -l $splunkUsername -c "/opt/splunkforwarder/bin/splunk start --accept-license --answer-yes --no-prompt"
echo "Enable Splunk to start on boot"
echo
/opt/splunkforwarder/bin/splunk enable boot-start -user $splunkUsername
runuser -l $splunkUsername -c '/opt/splunkforwarder/bin/splunk stop'
echo "Set Deployment Server"
echo
mkdir -p /opt/splunkforwarder/etc/apps/_faa_deploymentclient_base
mkdir -p /opt/splunkforwarder/etc/apps/_faa_deploymentclient_base/local
echo "[target-broker:deploymentServer]" > /opt/splunkforwarder/etc/apps/_faa_deploymentclient_base/local/deploymentclient.conf
echo "targetUri = 10.1.1.208:8089" >> /opt/splunkforwarder/etc/apps/_faa_deploymentclient_base/local/deploymentclient.conf
chown -R $splunkUsername:$splunkGroup /opt/splunkforwarder
chown root:$splunkGroup /opt/splunkforwarder/etc/splunk-launch.conf
chmod 644 /opt/splunkforwarder/etc/splunk-launch.conf
echo "Starting Splunk one more time"
echo
runuser -l $splunkUsername -c '/opt/splunkforwarder/bin/splunk start'
echo
