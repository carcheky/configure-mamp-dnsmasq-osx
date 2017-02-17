# if [[ -f MAMP_MAMP_PRO_4.1.1.pkg ]]; then
# sudo echo "
# ================================================================================
#     Installing MAMP
# ================================================================================"
#   FILE=MAMP_MAMP_PRO_4.1.1.pkg
#   sudo installer -allowUntrusted -verboseR -pkg "$FILE" -target / -lang en 2>&1
# fi

sudo echo "
================================================================================
    Installing composer
================================================================================"
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php -r "if (hash_file('SHA384', 'composer-setup.php') === '55d6ead61b29c7bdee5cccfb50076874187bd9f21f65d8991d46ec5cc90518f447387fb9f76ebae1fbbacf329e583e30') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
php composer-setup.php
php -r "unlink('composer-setup.php');"
rm composer.phar


sudo echo "
================================================================================
    Installing drush
================================================================================"
rm /usr/local/bin/drush
# Download latest stable release using the code below or browse to github.com/drush-ops/drush/releases.
yes | php -r "readfile('https://s3.amazonaws.com/files.drush.org/drush.phar');" > drush
# Or use our upcoming release: php -r "readfile('https://s3.amazonaws.com/files.drush.org/drush-unstable.phar');" > drush
# Test your install.
php drush core-status
# Make `drush` executable as a command from anywhere. Destination can be anywhere on $PATH.
chmod +x drush
sudo mv drush /usr/local/bin
# Optional. Enrich the bash startup file with completion and aliases.
drush init

#copy ~/.bashrc to ~/bash_profile in MAC
cat ~/.bashrc >> ~/.bash_profile
rm ~/.bashrc


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
yes|/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
source ~/.bash_profile


sudo echo "
================================================================================
    Installing Ruby
================================================================================"
brew install ruby
brew install ruby-build


sudo echo "
================================================================================
    Installing Rails
================================================================================"
gem install rails
rbenv rehash


sudo echo "
================================================================================
    Uninstall dnsmasq
================================================================================"
sudo rm -fr /Library/LaunchDaemons/homebrew.mxcl.dnsmasq.plist /etc/resolver/ /usr/local/etc/dnsmasq.conf
echo "sudo rm -fr /Library/LaunchDaemons/homebrew.mxcl.dnsmasq.plist /etc/resolver/ /usr/local/etc/dnsmasq.conf"


sudo echo "
================================================================================
    Unload default apache from system
      sudo launchctl unload -w /System/Library/LaunchDaemons/org.apache.httpd.plist
================================================================================"
sudo killall httpd mailcatcher
sudo launchctl unload -w /System/Library/LaunchDaemons/org.apache.httpd.plist


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
    Install MAMP No Password
================================================================================
"
sudo rm -fr /tmp/configmamp
git clone https://github.com/carcheky/configure-mamp-dnsmasq-osx.git /tmp/configmamp
cd /tmp/configmamp/
mv MAMP\ No\ Password.txt  MAMP\ No\ Password.app
sudo rm -fr /Applications/MAMP\ No\ Password.app
mv MAMP\ No\ Password.app /Applications/MAMP\ No\ Password.app


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


echo "
================================================================================
    FINISHING.... starting apache&mysql
================================================================================
"
mkdir /Applications/MAMP/bin/php/other
mv /Applications/MAMP/bin/php/php7* /Applications/MAMP/bin/php/other

sudo /Applications/MAMP/Library/bin/apachectl start
/Applications/MAMP/Library/bin/mysqld_safe --port=3306 --socket=/Applications/MAMP/tmp/mysql/mysql.sock --pid-file=/Applications/MAMP/tmp/mysql/mysql.pid --log-error=/Applications/MAMP/logs/mysql_error_log &

open /Applications/MAMP/MAMP.app
open /Applications/MAMP\ No\ Password.app/
sleep 3
open http://home.dev


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

