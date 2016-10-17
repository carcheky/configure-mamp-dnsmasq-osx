#!/bin/bash
sudo echo "
================================================================================
    Installing composer & drush
================================================================================"
sudo php -r "copy('http://getcomposer.org/installer', 'composer-setup.php');"
sudo php composer-setup.php
sudo php -r "unlink('composer-setup.php');"
sudo mv composer.phar /usr/local/bin/composer
composer -V
composer global require drush/drush:6.7
composer global update
rm -fr /usr/bin/drush
sudo ln -s ~/.composer/vendor/drush/drush/drush /usr/bin/
drush
sudo echo "
================================================================================
    stop & kill apache
================================================================================"
sudo apachectl stop
sudo killall httpd mailcatcher

sudo echo "
================================================================================
    Installing carcheky.bashrc (with some drush tools)
================================================================================"
mkdir ~/.drush
curl https://raw.githubusercontent.com/carcheky/drush.carcheky/master/carcheky.bashrc >> ~/.drush/carcheky.bashrc
echo ". ~/.drush/carcheky.bashrc" >> ~/.bash_profile
source ~/.bash_profile

sudo echo "
================================================================================
    Reinstalling HomeBrew
================================================================================"
yes | ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/uninstall)"
sudo chmod 0755 /usr/local
sudo chown root:wheel /usr/local
yes | ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
source ~/.bash_profile
sudo echo "
================================================================================
    Installing Ruby
================================================================================"
brew install rbenv ruby-build

# Add rbenv to bash so that it loads every time you open a terminal
echo 'if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi' >> ~/.bash_profile
source ~/.bash_profile

# Install Ruby
rbenv install 2.3.1 -s
rbenv global 2.3.1
ruby -v

sudo echo "
================================================================================
    Installing Rails
================================================================================"
gem install rails -v 4.2.6
rbenv rehash

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
sudo killall httpd mailcatcher
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

DATE=`date +%Y-%m-%d-%H-%M-%S`

if [[ ! -d /Applications/MAMP/conf/apache/backup ]]; then
  mkdir /Applications/MAMP/conf/apache/backup
  cp /Applications/MAMP/conf/apache/httpd.conf /Applications/MAMP/conf/apache/backup/httpd.conf.${DATE}.backup
  echo "
  Include /Applications/MAMP/conf/apache/extra/httpd-vhosts.conf
  " >> /Applications/MAMP/conf/apache/httpd.conf

  mv /Applications/MAMP/conf/apache/extra/httpd-vhosts.conf /Applications/MAMP/conf/apache/backup/httpd-vhosts.conf.${DATE}.backup
  echo "<VirtualHost *>
    UseCanonicalName Off
    ServerAlias *.%2
    ServerAlias *.xip.io
    VirtualDocumentRoot /Applications/MAMP/htdocs/%2/%1
</VirtualHost>" >> /Applications/MAMP/conf/apache/extra/httpd-vhosts.conf
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
    Starting MAMP & MAMP No Password & home.dev
================================================================================
"
rm -fr /tmp/configmamp
git clone https://github.com/carcheky/configure-mamp-dnsmasq-osx.git /tmp/configmamp
cd /tmp/configmamp/
mv MAMP\ No\ Password.txt  MAMP\ No\ Password.app
rm -fr /Applications/MAMP\ No\ Password.app
mv MAMP\ No\ Password.app /Applications/MAMP\ No\ Password.app

if [[ ! -d /Applications/MAMP/htdocs/dev/home ]]; then
  mkdir -p /Applications/MAMP/htdocs/dev/
  git clone https://github.com/carcheky/home-lamp.git /tmp/hometmp
  mv /tmp/hometmp/home/ /Applications/MAMP/htdocs/dev/
  rm -fr /tmp/hometmp
fi

sudo rm /usr/local/bin/mysql
sudo rm /usr/local/bin/mysqldump
sudo ln -s /Applications/MAMP/Library/bin/mysql /usr/local/bin/mysql
sudo ln -s /Applications/MAMP/Library/bin/mysqldump /usr/local/bin/mysqldump

# open /Applications/MAMP/
# open /Applications/MAMP/conf/apache
sleep 2
# subl /Applications/MAMP/conf/apache
sleep 2
# open /Applications/MAMP/MAMP.app
# open /Applications/MAMP\ No\ Password.app/
sleep 3
# open http://home.dev
