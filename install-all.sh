clear
echo "
================================================================================
    Pidiendo sudo
================================================================================"
sudo rm ~/.bash_profile


read -n1 -r -p "Press space to continue..." key
clear
sudo echo "
================================================================================
    Installing composer
================================================================================"
curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer
read -n1 -r -p "Press space to continue..." key
clear
sudo rm /usr/local/bin/drush
sudo rm /usr/bin/drush
sudo rm -fr ~/.drush
sudo echo "
================================================================================
     Installing drush
================================================================================"
composer global require drush/drush
sudo ln -s ~/.composer/vendor/drush/drush/drush /usr/bin/drush
source ~/.bash_profile
yes|drush init
cat ~/.bashrc >> ~/.bash_profile
rm ~/.bashrc
source ~/.bash_profile
drush version


read -n1 -r -p "Press space to continue..." key
clear
sudo echo "
================================================================================
    Installing carcheky.bashrc (with some drush tools)
================================================================================"
mkdir ~/.drush
curl https://raw.githubusercontent.com/carcheky/drush.carcheky/master/carcheky.bashrc >> ~/.drush/carcheky.bashrc
echo "
if [[ ~/.drush/carcheky.bashrc ]]; then
  . ~/.drush/carcheky.bashrc
fi
" >> ~/.bash_profile
source ~/.bash_profile


read -n1 -r -p "Press space to continue..." key
clear
sudo echo "
================================================================================
    stop & kill apache
================================================================================"
sudo apachectl stop
sudo killall httpd mailcatcher


read -n1 -r -p "Press space to continue..." key
clear
sudo echo "
================================================================================
    Reinstalling HomeBrew
================================================================================"
yes|/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
source ~/.bash_profile


read -n1 -r -p "Press space to continue..." key
clear
sudo echo "
================================================================================
    Installing Ruby
================================================================================"
brew install ruby
brew install ruby-build


read -n1 -r -p "Press space to continue..." key
clear
sudo echo "
================================================================================
    Installing Rails
================================================================================"
yes|sudo gem install rails -v 2.2.2
sudo rbenv rehash


read -n1 -r -p "Press space to continue..." key
clear
sudo echo "
================================================================================
    Uninstall dnsmasq
================================================================================"
sudo rm -fr /Library/LaunchDaemons/homebrew.mxcl.dnsmasq.plist /etc/resolver/ /usr/local/etc/dnsmasq.conf
echo "sudo rm -fr /Library/LaunchDaemons/homebrew.mxcl.dnsmasq.plist /etc/resolver/ /usr/local/etc/dnsmasq.conf"


read -n1 -r -p "Press space to continue..." key
clear
sudo echo "
================================================================================
    Unload default apache from system
      sudo launchctl unload -w /System/Library/LaunchDaemons/org.apache.httpd.plist
================================================================================"
sudo killall httpd mailcatcher
sudo launchctl unload -w /System/Library/LaunchDaemons/org.apache.httpd.plist


read -n1 -r -p "Press space to continue..." key
clear
echo "
================================================================================
    Installing dnsmasq
================================================================================
"
brew install dnsmasq
mkdir -pv $(brew --prefix)/etc/
echo 'address=/.dev/127.0.0.1' > $(brew --prefix)/etc/dnsmasq.conf
sudo cp -v $(brew --prefix dnsmasq)/homebrew.mxcl.dnsmasq.plist /Library/LaunchDaemons
sudo launchctl load -w /Library/LaunchDaemons/homebrew.mxcl.dnsmasq.plist
sudo mkdir -v /etc/resolver
sudo bash -c 'echo "nameserver 127.0.0.1" > /etc/resolver/dev'


read -n1 -r -p "Press space to continue..." key
clear
echo "
================================================================================
    Install MAMP No Password
================================================================================
"
sudo rm -fr /tmp/configmamp
git clone https://github.com/carcheky/configure-mamp-dnsmasq-osx.git /tmp/configmamp
cd /tmp/configmamp/
mv MAMP\ No\ Password.txt  MAMP\ No\ Password.app
sudo rm -fr /Applications/MAMP\ No\ Password.app
mv MAMP\ No\ Password.app /Applications/MAMP\ No\ Password.app


read -n1 -r -p "Press space to continue..." key
clear
echo "
================================================================================
    Install home.dev
================================================================================
"
if [[ ! -d /Applications/MAMP/htdocs/home ]]; then
  mkdir -p /Applications/MAMP/htdocs/
  git clone https://github.com/carcheky/home-lamp.git /tmp/hometmp
  mv /tmp/hometmp/home/ /Applications/MAMP/htdocs/
  sudo rm -fr /tmp/hometmp
fi

mkdir /Applications/MAMP/bin/php/other
mv /Applications/MAMP/bin/php/php7* /Applications/MAMP/bin/php/other


read -n1 -r -p "Press space to continue..." key
clear
echo "
================================================================================
    Configure MAMP
================================================================================
"
DATE=`date +%Y-%m-%d-%H-%M-%S`
if [[ ! -f /Applications/MAMP/conf/apache/*.backup ]]; then
  cp /Applications/MAMP/conf/apache/httpd.conf /Applications/MAMP/conf/apache/httpd.conf.${DATE}.backup
  echo "
  Include /Applications/MAMP/conf/apache/extra/httpd-vhosts.conf
  " >> /Applications/MAMP/conf/apache/httpd.conf

  mv /Applications/MAMP/conf/apache/extra/httpd-vhosts.conf /Applications/MAMP/conf/apache/extra/httpd-vhosts.conf.${DATE}.backup
  echo "<VirtualHost *>
    UseCanonicalName Off
    ServerAlias *.%2
    ServerAlias *.xip.io
    VirtualDocumentRoot /Applications/MAMP/htdocs/%1
</VirtualHost>" >> /Applications/MAMP/conf/apache/extra/httpd-vhosts.conf
fi


read -n1 -r -p "Press space to continue..." key
clear
echo "
================================================================================
    FINISHING.... starting MAMP
================================================================================
"
# sudo /Applications/MAMP/Library/bin/apachectl start
# /Applications/MAMP/Library/bin/mysqld_safe --port=3306 --socket=/Applications/MAMP/tmp/mysql/mysql.sock --pid-file=/Applications/MAMP/tmp/mysql/mysql.pid --log-error=/Applications/MAMP/logs/mysql_error_log &

open /Applications/MAMP/MAMP.app
sleep 3
open http://home.dev


read -n1 -r -p "Press space to continue..." key
clear
echo "
================================================================================
    Added sendmail_path to /Applications/MAMP/bin/php/php.X.X.X/php.ini
================================================================================
"
sudo gem install mailcatcher

find /Applications/MAMP/bin/php -name php.ini -exec sh -c 'echo "sendmail_path = /usr/local/bin/catchmail -f catcher@mailcatcher.me" >> {}' \;
mailcatcher -b
sleep 2
php -r "mail('test@test.test', 'testing mailcatcher', 'testing mailcatcher');"


echo "
================================================================================
    Added drush scripts to bash_profile
================================================================================
"
echo "
# Include Drush completion.
if [[ ~/.drush/drush.complete.sh ]]; then
  . ~/.drush/drush.complete.sh
fi
# Include Drush prompt customizations.
if [[ ~/.drush/drush.prompt.sh ]]; then
  . ~/.drush/drush.prompt.sh
fi
# Include Drush bash customizations.
if [[ ~/.drush/drush.bashrc ]]; then
  . ~/.drush/drush.bashrc
fi
" >> ~/.bash_profile

#copy ~/.bashrc to ~/bash_profile in MAC
# cat ~/.bashrc >> ~/.bash_profile
rm ~/.bashrc
source ~/.bash_profile
