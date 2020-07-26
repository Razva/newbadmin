#!/usr/bin/perl

# display the commands to update an OpenVZ VPS with new disk space requirements
# script taken from http://chrisschuld.com/2009/11/setting-vps-disk-space-with-openvz-the-easy-way/
# and fixed with help from Botje & archon- @ #perl @ FreeNode

use strict;

print "Enter VPS CID: "; my $_CID = <> ; chomp($_CID);
print "Enter SOFT Diskspace Limit (ex 10GB):"; my $_SOFT = <>; chomp($_SOFT); $_SOFT =~ s/[^0-9]//g;
print "Enter HARD Diskspace Limit (ex 11GB):"; my $_HARD = <>; chomp($_HARD); $_HARD =~ s/[^0-9]//g;
my $_INODE_SOFT = ( 200000 * $_SOFT );
my $_INODE_HARD = ( 220000 * $_HARD );
print "Run these commands:\n";
print "vzctl set $_CID --diskspace ".$_SOFT."G:".$_HARD."G --save\n";
print "vzctl set $_CID --diskinodes $_INODE_SOFT:$_INODE_HARD --save\n";
