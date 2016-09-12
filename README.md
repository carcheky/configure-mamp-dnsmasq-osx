# configure-mamp-dnsmasq-osx
Configure MAMP after upgrade &amp; reinstall dnsmasq
(as explained here https://gist.github.com/mgalloway/7121912)

1. Install MAMP
2. Open MAMP
3. Save prefs MAMP (PHP Standard Version, Set Web & MySQL ports to 80 & 3306)
4. Copy & Paste in terminal
```bash
curl -s 'https://raw.githubusercontent.com/carcheky/configure-mamp-dnsmasq-osx/master/run.sh' | sh
```
