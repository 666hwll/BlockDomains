# etc

Block Hosts 

## Current contents:

+ `ips` -- A file that can be appended to /etc/hosts to block ads, junk sites, porn, tracking and Google
	+ Add to /etc/hosts in Linux
	+ ...or C:\Windows\System32\drivers\etc\hosts
     you could trigger windows defender for changing those rules

## Installation:
+ Linux:
``` bash
curl https://raw.githubusercontent.com/666hwll/BlockDomains/main/ips > ips && sudo cat ips >> /etc/hosts && shred -u ips
```
+ Windows:
``` powershell
Set-ExecutionPolicy Bypass -Scope Process -Force
.\update-hosts.ps1
```