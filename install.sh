#!/usr/bin/env bash

# ----- REQUIREMENTS -----

# Your base system should be a current Debian/testing system.
# Other systems might work but are not supported.

# Hostnames for the different servers MUST be:
#  1. FQDN (e.g. "server.example.com", not "server")
#  2. Valid DNS names (that resolve using IPv4 and/or IPv6)
# These are both required to ensure clients can properly access
# the server.

# ----- ADD REPOSITORY -----
# Add
#    deb http://debian.sotelips.net/shimaore shimaore main
# to your existing /etc/apt/sources.list

REPOSITORY=${REPOSITORY:-debian.sotelips.net}
sudo tee -a /etc/apt/sources.list > /dev/null <<EOT
deb http://${REPOSITORY}/shimaore shimaore main
EOT

# Alternatively use
#   apt-add-repository "deb http://${REPOSITORY}/shimaore shimaore main"

# ----- ADD KEY -----

# Add the GPG key for stephane@shimaore.net, which is used
# to sign the "shimaore" distribution.

sudo apt-key add - <<'GPG'
-----BEGIN PGP PUBLIC KEY BLOCK-----
Version: GnuPG v1.4.11 (GNU/Linux)

mQINBE77A44BEADYqO8dkYuTUdvim5X4P5+MZuJQs3eME/OK0HY0xrGa2Bcw3dhY
tM6ctEtNpVAG9JB56nBnINis70lW1NGCeLAQjpa2EAtXxqki8XxBkPbNNo5ywhxl
y431Wnk4573I0w5/E60lkBXT4PC/vVIdqXsfTarYOiYkMeCuNI49F7W7Tjrc0hgj
//pjIzUJmluC3CmUmLZs7n0sO8jhqNqNV9ve7TudmhaUzlX0fhMPIenkCFhU2OAp
LVdUx+GXE6Fs82w8pk+qcR1BwUtm+dajg7WwNi+CrnrZ2/4zFvdqQpORpRnhUIYs
jGz9BA7EH3iw6GSjSN7vohDsKR8uCvQk+ShqEXAMApDtkE5YJZLOSTvhGbOgiglO
AiAtJu/RHMZneRQXeRTlj0Et9RyoqDfdSHjmIwKtr5c6xmcBAzvec5BA+aG2uz6i
ZvS4+FpfsivJKLCsWrzGbbuu+W3mL9BGPcs0OSa43ptP4Mu18mpoJHS4qpQf4p9h
aCv1gFnvheCZp474ThXauXojKFfeJWcXMLBFBU26pfPJhpll1KnY04NOCp/yrfOO
0JchqNyYUH8wUTgmltx+trej5KWqQhAw06L9Ovjvc9dNIzAaScFyxg4B04z17gNn
J3eEycfx2LK+BekSkVuuukffLoT7oRNnIoKEAqkXhaCYaFPFhucw8D82/wARAQAB
tDJTdGVwaGFuZSBBbG5ldCAoUGFja2FnaW5nKSA8c3RlcGhhbmVAc2hpbWFvcmUu
bmV0PokCOAQTAQIAIgUCTvsDjgIbAwYLCQgHAwIGFQgCCQoLBBYCAwECHgECF4AA
CgkQqoOEcfJLkgDiPg//en5gxfztFNkJPgu5iPBQmTAJXrnGzdAGq/iFub9XqZEP
fq5M5Twdkv3I1lX1XLbC1DUZa3YCYh1AZhJ/n3p7+WWJ8IWN1jRdR5MtZcSWY16n
/bb7x2fcnRGuiWcDciRLgmW4W3vpqRKq5AzPZzjwyHLhGQAqUGKkUoXGGZM4WopT
kklCGQTNsGU9wsnXVOuw1EbBXU8lWnWm81sIcfa35HbpJ9IEPxhk+6tk/CsVjS1R
BiRGF7+P6tqlp8qOUUu24YX+njaTj7vRprnYBXSUDxNuCyqX1Xh9PrduS0xDNlBx
S4YM4KuppEvWN3Kbf/N87xL1k+BkSaHi08A16bmP0um4ouTyKkZak0B0Ik68Qof7
olONoJS/80p2pLcb9znVJ+mtfrGUxG9djGSnBbMMPDgG5k7qw1/fZlG/f9eozKX7
ZC5mLCu3bgS0kXMoKuh3w9XXA6DsxIyw2vy3XUyEi/YLNyHN3jC2i0dc5fhjFtct
Cgm2CaZEDLLRLn6Z4LjzfD4c++b1d9C1EsFJEt1zeLH1b5hL7B0zO028yHCE0RcQ
xTniNbfKH5xbApR26zpoIytjpqbcgnQwJs/817URuFfNf036H0CVmK4tZN8N/akz
+B8h8WM/YX9ZZBsYi+QsQnUqfz8UoI1fe9wUrfvWeNpVi8BQDhCOAf8fCXZEXHa5
Ag0ETvsDjgEQAMBxsWjmsF4fEop8aNYYLTD2s1GWRbYWG5sSzKeb7Ivy9tW+VTiE
yNIbo9g5XPMO8QyJjQA03norlfLS87XJsb4P8CBSV9DCJN1TSSvsLsV0zKbBRqzr
Brp05WIkqN9fszOxhBawYWhAJd5l+m0fx/x4UB5ZhztmtagR1rAu706eco6uxjXH
J1+mYM8pAY0o3gMFhzXpbDmJDR+kHorkBRgkJzEOVr3qeIgI8JGId72eYMtbBoFa
+Pf2un/hHt8m+0EiLUp1LAYoF/1qYw4YySaU6MZ5XAwad1IG4bwkGnZciqWjfQwY
M43IOCOOeWKDdT9aFKiWKJB00d2brQDYwpj1+XnYS1TPd574ZahHsGY+hYS2EiU9
F2Ky5blkDuuCjl9KSdBKRwyC6IpCm7iqrmbe+iIw5tDuA1YwAyHW8HY1UBuDqaAO
/K2HdykuNUda3IU+YtnzN9GFrXEcCNHThnF/ZwFSORmrE4jxcjVYODZLnjCrihpb
wZiImzfEY1Bo0jlh1rRFXgiTXUgmSIT/wZ6g1yIGXilOdBYNLCPoMqI+Nlc67O4J
3Pza0Xk6/d6LE5L1hPxsDR0EG8RWES2z79P40bJLbAZa0MoFcv0n7frrhkOoUiIw
KJHDmaSo9LUe9j27Zmq8r1+UcQf4B8fZFaV3kNMAIWcIhpBIB5Cojz+dABEBAAGJ
Ah8EGAECAAkFAk77A44CGwwACgkQqoOEcfJLkgC9Tg//R0+bHsCLgr6JAHUzAso5
bARTkqswesI/VafyV9HeYkT0AhXKm/Crfw8IXDMS7SANb/QQhunmi6yHnFRTBs7/
iulaHXB3rYUvKR0KG+l1ArDewibcoqQwUwGdjQ7OFch2OHCjaqO8h/cgj3HJ6kvZ
NFWewdA1RK/xOhFqzom/0kM0fJFDupiHgFvC+kpGrQWMCVVjuTlxFuE3yKuyIChU
PwUH+xWsJ4FMyLDN2sgRD+Hu51aSKfLmwPxBmk3Z1XIAdcwoBuIjl/NslXOMBjJP
XLf71wpugNgisHB9+Cnp72Dw0jtWGR6XQt2SHfvx7bVbuTfi1j7UMheZwulNm9HG
dWGALJqCg5ox04eQDF/RGadTFBPFgOaruVz/ylnKXD3C212UcX+44P9aLTNNEKLA
eEd5xQjmvrzkMwQRgwQyzICye8nOglBNBk47lTtelO0qQXGSehdnpsOxd3cLrASF
OBykrOCP2xkJXm5KO2biX462aonOBXt1KKWljRamN78QBVpvON8JkSD90pKiDeh1
87zGf66NymplVqV6Ri9SnI36F+UwRSEnEr3PxXVKhFM5nQfUVjvcqlANClgAReiA
91jYh+Ev+c6nD7qSzqAZUKPZgZmUOZ4MWCuCuDNE1BD6FSfyUxsOWzcJbcBJbdVh
3FuSepTWd4opF5wgYQ3ZtPM=
=+BNA
-----END PGP PUBLIC KEY BLOCK-----
GPG

# Alternatively retrieve the key then add it:
#   MAINTAINER='Stephane Alnet (Packaging) <stephane@shimaore.net>'
#   gpg --recv-keys "=${MAINTAINER}"
#   gpg --armor --export "=${MAINTAINER}" | sudo apt-key add -


# ----- UPDATE SYSTEM, INSTALL PACKAGES -----

# Once the above is done, update your system...
sudo aptitude update
sudo aptitude -y dist-upgrade
# ... then install the ccnq packages.
sudo aptitude -y install ccnq-base ccnq3 ccnq3-traces
# Normally you should not run voice services on the manager,
# however if you intend to do so you will need to install
# the ccnq3-voice package as well.

# ----- START INSTALLATION ----

# Finally start the installation

# The first host you will install is your "manager" host.
# (sudo is needed to overwrite your existing CouchDB configuration).
cd /opt/ccnq3/src
sudo ./bootstrap-manager.sh

# If you have an existing CouchDB/BigCouch installation, use
#   cd /opt/ccnq3/src
#   export CDB_URI=http://admin:password@host:5984/
#   sudo su -s /bin/bash -c ./bootstrap.sh ccnq3
# instead.

# On a non-manager host you will use:
#   sudo aptitude install ccnq3-voice
#   cd /opt/ccnq3/src
#   sudo ./bootstrap-local.sh http://....
# where the URI is provided by the provisioning system.


# ----- TUNE UP ----

# Additionally I recommend modifying the rsyslog configuration
# to either a centralized syslog server, or a smaller local
# configuration such as:

sudo tee /etc/rsyslog.conf >/dev/null <<'EOT'
$ModLoad imuxsock # provides support for local system logging
$ModLoad imklog   # provides kernel logging support (previously done by rklogd)
$ActionFileDefaultTemplate RSYSLOG_TraditionalFileFormat
$FileOwner root
$FileGroup adm
$FileCreateMode 0640
$DirCreateMode 0755
auth,authpriv.*             /var/log/auth.log
*.info;auth,authpriv.none  -/var/log/syslog
# Uncomment the following line to gather debug messages
# *.debug                  -/var/log/debug
EOT

sudo /etc/init.d/rsyslog restart
