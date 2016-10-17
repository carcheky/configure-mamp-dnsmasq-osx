# Configure MAMP macOS Sierra version 10.12
¡¡¡SEE CODE BEFORE!!!
Configure MAMP after upgrade &amp; reinstall dnsmasq or update to macOS Sierra

1. Install MAMP
2. Open MAMP
3. Save prefs MAMP (PHP Standard Version, Set Web & MySQL ports to 80 & 3306)
4. Copy & Paste in terminal
```bash
curl -s 'https://raw.githubusercontent.com/carcheky/configure-mamp-dnsmasq-osx/master/run.sh' | sh
```


sources:
- http://www.46palermo.com/blog/run-mamp-without-password-easy-way/


silent install mamp after download:

```bash
sudo installer -verbose -pkg ~/Downloads/MAMP_MAMP_PRO_4.0.5.pkg -target / ; rm -fr /Applications/MAMP\ PRO/
```
