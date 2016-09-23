#!/bin/bash
sudo echo "
================================================================================
    Uninstall dnsmasq
================================================================================"
sudo rm -fr /Library/LaunchDaemons/homebrew.mxcl.dnsmasq.plist /etc/resolver/ /usr/local/etc/dnsmasq.conf

sudo echo "
================================================================================
    Unload default apache from system
      sudo launchctl unload -w /System/Library/LaunchDaemons/org.apache.httpd.plist
================================================================================"
sudo launchctl unload -w /System/Library/LaunchDaemons/org.apache.httpd.plist

echo "    Install dnsmasq
================================================================================
"
brew install dnsmasq
mkdir -pv $(brew --prefix)/etc/
echo 'address=/.dev/127.0.0.1' > $(brew --prefix)/etc/dnsmasq.conf
sudo cp -v $(brew --prefix dnsmasq)/homebrew.mxcl.dnsmasq.plist /Library/LaunchDaemons
sudo launchctl load -w /Library/LaunchDaemons/homebrew.mxcl.dnsmasq.plist
sudo mkdir -v /etc/resolver
sudo bash -c 'echo "nameserver 127.0.0.1" > /etc/resolver/dev'




echo "
================================================================================
    Configure MAMP
================================================================================
"

DATE=`date +%Y-%m-%d:%H:%M:%S`

if [[ ! -f /Applications/MAMP/conf/apache/httpd.conf.*.backup ]]; then
  cp /Applications/MAMP/conf/apache/httpd.conf /Applications/MAMP/conf/apache/httpd.conf.${DATE}.backup
  echo "
  Include /Applications/MAMP/conf/apache/extra/httpd-vhosts.conf
  " >> /Applications/MAMP/conf/apache/httpd.conf
fi

if [[ ! -f /Applications/MAMP/conf/apache/extra/httpd-vhosts.conf.*.backup ]]; then
  mv /Applications/MAMP/conf/apache/extra/httpd-vhosts.conf /Applications/MAMP/conf/apache/extra/httpd-vhosts.conf.${DATE}.backup
  echo "
  <VirtualHost *>
      UseCanonicalName Off
      ServerAlias *.%2
      ServerAlias *.xip.io
      VirtualDocumentRoot /Applications/MAMP/htdocs/%2/%1
  </VirtualHost>
  " >> /Applications/MAMP/conf/apache/extra/httpd-vhosts.conf
fi

echo "
================================================================================
    Added sendmail_path to /Applications/MAMP/bin/php/*/php.ini
================================================================================
"
sudo gem install mailcatcher

find /Applications/MAMP/bin/php -name php.ini -exec sh -c 'echo "sendmail_path = /usr/local/bin/catchmail -f catcher@mailcatcher.me" >> {}' \;
mailcatcher -b
sleep 2
php -r "mail('test@test.test', 'testing mailcatcher', 'testing mailcatcher');"


echo "
================================================================================
    Starting MAMP
================================================================================
"
open /Applications/MAMP/
open /Applications/MAMP/MAMP.app
subl /Applications/MAMP/conf/apache
