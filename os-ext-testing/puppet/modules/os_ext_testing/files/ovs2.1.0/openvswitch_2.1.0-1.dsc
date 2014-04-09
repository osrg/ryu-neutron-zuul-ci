Format: 3.0 (quilt)
Source: openvswitch
Binary: openvswitch-datapath-source, openvswitch-datapath-dkms, openvswitch-common, openvswitch-switch, openvswitch-ipsec, openvswitch-pki, openvswitch-dbg, python-openvswitch, ovsdbmonitor, openvswitch-test, openvswitch-vtep
Architecture: all linux-any
Version: 2.1.0-1
Maintainer: Open vSwitch developers <dev@openvswitch.org>
Uploaders: Ben Pfaff <pfaffben@debian.org>, Simon Horman <horms@debian.org>
Homepage: http://openvswitch.org/
Standards-Version: 3.9.3
Build-Depends: debhelper (>= 8), autoconf (>= 2.64), automake (>= 1.10) | automake1.10, libssl-dev, bzip2, openssl, graphviz, python-all (>= 2.6.6-3~), procps, python-qt4, python-zopeinterface, python-twisted-conch, libtool
Package-List: 
 openvswitch-common deb net extra
 openvswitch-datapath-dkms deb net extra
 openvswitch-datapath-source deb net extra
 openvswitch-dbg deb debug extra
 openvswitch-ipsec deb net extra
 openvswitch-pki deb net extra
 openvswitch-switch deb net extra
 openvswitch-test deb net extra
 openvswitch-vtep deb net extra
 ovsdbmonitor deb utils extra
 python-openvswitch deb python extra
Checksums-Sha1: 
 a42c36abc4710b303fc2617a078e2579a2741bed 3103784 openvswitch_2.1.0.orig.tar.gz
 70646028022f050bf22f47c9852976983331946c 60005 openvswitch_2.1.0-1.debian.tar.gz
Checksums-Sha256: 
 a032fcc3becd98802b4816488cb3a2441b6b88b510ec28a929e756f948eb48c0 3103784 openvswitch_2.1.0.orig.tar.gz
 87bd0258c3dd555068dd1aba7b58c8197c3616877a0eb1ae09f250651d2a956b 60005 openvswitch_2.1.0-1.debian.tar.gz
Files: 
 7c5861b0ef7f3002c15c61be6f5066f2 3103784 openvswitch_2.1.0.orig.tar.gz
 ee22e9fe0dcf264d3df300268d427a40 60005 openvswitch_2.1.0-1.debian.tar.gz
