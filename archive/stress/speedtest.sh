#!/bin/bash
echo "Test started, please wait.... :" 
echo "-------------------------------"
for i in `seq 0 1`
do
echo "Testing I3D NL, iteration #"$((i+1))
i3d[$i]="`wget http://mirror.i3d.net/100mb.bin -O /dev/null 2>&1 | grep '\([0-9.]\+ [KMG]B/s\)' | awk '{print $3 $4}'`"
echo "Testing Nforce NL, iteration #"$((i+1))
nforce[$i]="`wget http://mirror.nforce.com/pub/speedtests/100mb.bin -O /dev/null 2>&1 | grep '\([0-9.]\+ [KMG]B/s\)' | awk '{print $3 $4}'`"
echo "Testing Serverius NL, iteration #"$((i+1))
serverius[$i]="`wget http://speedtest.serverius.com/2000/100mb.bin -O /dev/null 2>&1 | grep '\([0-9.]\+ [KMG]B/s\)' | awk '{print $3 $4}'`"
echo "Testing Swiftway NL, iteration #"$((i+1))
swiftnl[$i]="`wget http://speedtest-netherlands2.swiftway.net/100MB.bin -O /dev/null 2>&1 | grep '\([0-9.]\+ [KMG]B/s\)' | awk '{print $3 $4}'`"
echo "Testing Leaseweb NL, iteration #"$((i+1))
leasewebnl[$i]="`wget http://mirror.nl.leaseweb.net/speedtest/100mb.bin -O /dev/null 2>&1 | grep '\([0-9.]\+ [KMG]B/s\)' | awk '{print $3 $4}'`"
echo "Testing Leaseweb USA, iteration #"$((i+1))
leasewebusa[$i]="`wget http://mirror.us.leaseweb.net/speedtest/100mb.bin -O /dev/null 2>&1 | grep '\([0-9.]\+ [KMG]B/s\)' | awk '{print $3 $4}'`"
echo "Testing Leaseweb Germany, iteration #"$((i+1))
leasewebgr[$i]="`wget http://mirror.de.leaseweb.net/speedtest/100mb.bin -O /dev/null 2>&1 | grep '\([0-9.]\+ [KMG]B/s\)' | awk '{print $3 $4}'`"
echo "Testing InstantDedicated NL, iteration #"$((i+1))
id[$i]="`wget http://mirror.global-layer.com/speedtest/100mb.bin -O /dev/null 2>&1 | grep '\([0-9.]\+ [KMG]B/s\)' | awk '{print $3 $4}'`"
echo "Testing Hetzner DE, iteration #"$((i+1))
hetznerde[$i]="`wget http://hetzner.de/100MB.iso -O /dev/null 2>&1 | grep '\([0-9.]\+ [KMG]B/s\)' | awk '{print $3 $4}'`"
echo "Testing Redstation UK, iteration #"$((i+1))
redstationuk[$i]="`wget http://www.as35662.net/100.log -O /dev/null 2>&1 | grep '\([0-9.]\+ [KMG]B/s\)' | awk '{print $3 $4}'`"
echo "Testing OVH FR, iteration #"$((i+1))
ovhfr[$i]="`wget ftp://ftp.ovh.net/test.bin -O /dev/null 2>&1 | grep '\([0-9.]\+ [KMG]B/s\)' | awk '{print $3 $4}'`"
echo "Testing FDCServers CZ, iteration #"$((i+1))
fdcservcz[$i]="`wget http://lg.zlin.fdcservers.net/100MBtest.zip -O /dev/null 2>&1 | grep '\([0-9.]\+ [KMG]B/s\)' | awk '{print $3 $4}'`"
echo "Testing FDCServers Ams, iteration #"$((i+1))
fdcservams[$i]="`wget http://lg.amsterdam.fdcservers.net/100MBtest.zip -O /dev/null 2>&1 | grep '\([0-9.]\+ [KMG]B/s\)' | awk '{print $3 $4}'`"
echo "Testing Cachefly CDN, iteration #"$((i+1))
cachefly[$i]="`wget http://cachefly.cachefly.net/100mb.bin -O /dev/null 2>&1 | grep '\([0-9.]\+ [KMG]B/s\)' | awk '{print $3 $4}'`"
echo "Testing Softlayer Dallas, iteration #"$((i+1))
softdallas[$i]="`wget http://speedtest.dal05.softlayer.com/downloads/test100.zip -O /dev/null 2>&1 | grep '\([0-9.]\+ [KMG]B/s\)' | awk '{print $3 $4}'`"
echo "Testing Softlayer Seattle, iteration #"$((i+1))
softseattle[$i]="`wget http://speedtest.sea01.softlayer.com/downloads/test100.zip -O /dev/null 2>&1 | grep '\([0-9.]\+ [KMG]B/s\)' | awk '{print $3 $4}'`"
echo "Testing Softlayer Washington, iteration #"$((i+1))
softwashington[$i]="`wget http://speedtest.wdc01.softlayer.com/downloads/test100.zip -O /dev/null 2>&1 | grep '\([0-9.]\+ [KMG]B/s\)' | awk '{print $3 $4}'`"
echo "Testing Softlayer Houston, iteration #"$((i+1))
softhouston[$i]="`wget http://speedtest.hou02.softlayer.com/downloads/test100.zip -O /dev/null 2>&1 | grep '\([0-9.]\+ [KMG]B/s\)' | awk '{print $3 $4}'`"
echo "Testing Softlayer San Jose, iteration #"$((i+1))
softsanjose[$i]="`wget http://speedtest.sjc01.softlayer.com/downloads/test100.zip -O /dev/null 2>&1 | grep '\([0-9.]\+ [KMG]B/s\)' | awk '{print $3 $4}'`"
echo "Testing Softlayer Singapore, iteration #"$((i+1))
softsingapore[$i]="`wget http://speedtest.sng01.softlayer.com/downloads/test100.zip -O /dev/null 2>&1 | grep '\([0-9.]\+ [KMG]B/s\)' | awk '{print $3 $4}'`"
echo "Testing Softlayer Amsterdam, iteration #"$((i+1))
softamsterdam[$i]="`wget http://speedtest.ams01.softlayer.com/downloads/test100.zip -O /dev/null 2>&1 | grep '\([0-9.]\+ [KMG]B/s\)' | awk '{print $3 $4}'`"
echo "Testing Limestone Networks (Dallas), iteration #"$((i+1))
limestonenetworks[$i]="`wget http://limestonenetworks.com/test100.zip -O /dev/null 2>&1 | grep '\([0-9.]\+ [KMG]B/s\)' | awk '{print $3 $4}'`"
echo "Testing Incero, iteration #"$((i+1))
incero[$i]="`wget http://mrtg.incero.com/test.tar -O /dev/null 2>&1 | grep '\([0-9.]\+ [KMG]B/s\)' | awk '{print $3 $4}'`"
echo "Testing Gigenet, iteration #"$((i+1))
gigenet[$i]="`wget http://www.gigenet.com/files/100MB.zip -O /dev/null 2>&1 | grep '\([0-9.]\+ [KMG]B/s\)' | awk '{print $3 $4}'`"
echo "Testing Burstnet Scranton, iteration #"$((i+1))
burstnets[$i]="`wget http://66.96.192.225/bigtest.tgz -O /dev/null 2>&1 | grep '\([0-9.]\+ [KMG]B/s\)' | awk '{print $3 $4}'`"
echo "Testing Singlehop, iteration #"$((i+1))
singlehop[$i]="`wget https://leap.singlehop.com/speedtest/100megabytefile.tar.gz -O /dev/null 2>&1 | grep '\([0-9.]\+ [KMG]B/s\)' | awk '{print $3 $4}'`"
echo "Testing Secured Servers, iteration #"$((i+1))
ss[$i]="`wget http://174.138.175.114/100mb-file.zip -O /dev/null 2>&1 | grep '\([0-9.]\+ [KMG]B/s\)' | awk '{print $3 $4}'`"
echo "Testing WholeSaleInternet, iteration #"$((i+1))
wsi[$i]="`wget http://www.wholesaleinternet.net/speedtest/100MB.zip -O /dev/null 2>&1 | grep '\([0-9.]\+ [KMG]B/s\)' | awk '{print $3 $4}'`"
echo "Testing Choopa, iteration #"$((i+1))
choopa[$i]="`wget http://speedtest.choopa.net/100MBtest.bin -O /dev/null 2>&1 | grep '\([0-9.]\+ [KMG]B/s\)' | awk '{print $3 $4}'`"
echo "Testing Netdepot Atl, iteration #"$((i+1))
netdepotatl[$i]="`wget http://www.netdepot.com/speedtest/100MB.BIN -O /dev/null 2>&1 | grep '\([0-9.]\+ [KMG]B/s\)' | awk '{print $3 $4}'`"
echo "Testing Quadranet LA, iteration #"$((i+1))
quadranetla[$i]="`wget http://www.quadranet.com/speedtests/100mb.bin -O /dev/null 2>&1 | grep '\([0-9.]\+ [KMG]B/s\)' | awk '{print $3 $4}'`"
echo "Testing Iweb Canada, iteration #"$((i+1))
iweb[$i]="`wget http://test-bgp.iweb.com/100mbtest.bin -O /dev/null 2>&1 | grep '\([0-9.]\+ [KMG]B/s\)' | awk '{print $3 $4}'`"
echo "Testing 1000Mbps, iteration #"$((i+1))
mbps[$i]="`wget http://mirror.1000mbps.com/100mb.bin -O /dev/null 2>&1 | grep '\([0-9.]\+ [KMG]B/s\)' | awk '{print $3 $4}'`"



echo "---------------Test #"$((i+1)) "completed------------------------------"
done
echo ""
echo ""
{
echo "------------Test results---------------"
echo "Download speed from I3D NL :"  ${i3d[@]}
echo "Download speed from Nforce NL :"  ${nforce[@]}
echo "Download speed from Serverius NL :"  ${serverius[@]}
echo "Download speed from Swiftway NL :"  ${swiftnl[@]}
echo "Download speed from Leaseweb NL :"  ${leasewebnl[@]}
echo "Download speed from Leaseweb USA :"  ${leasewebusa[@]}
echo "Download speed from Leaseweb Germany :"  ${leasewebgr[@]}
echo "Download speed from InstantDedicated NL :"  ${id[@]}
echo "Download speed from Hetzner DE :"  ${hetznerde[@]}
echo "Download speed from Redstation UK :"  ${redstationuk[@]}
echo "Download speed from OVH FR :"  ${ovhfr[@]}
echo "Download speed from FDCSERVERS CZ :"  ${fdcservcz[@]}
echo "Download speed from FDCSERVERS Ams :"  ${fdcservams[@]}
echo "Download speed from Cachefly CDN :"  ${cachefly[@]}
echo "Download speed from Softlayer Dallas :"  ${softdallas[@]}
echo "Download speed from Softlayer Seattle :"  ${softseattle[@]}
echo "Download speed from Softlayer Washington :"  ${softwashington[@]}
echo "Download speed from Softlayer Houston :"  ${softhouston[@]}
echo "Download speed from Softlayer San Jose :"  ${softsanjose[@]}
echo "Download speed from Softlayer Singapore :"  ${softsingapore[@]}
echo "Download speed from Softlayer Amsterdam :"  ${softamsterdam[@]}
echo "Download speed from Limestone Networks (Dallas) :"  ${limestonenetworks[@]}
echo "Download speed from Incero Dallas :"  ${incero[@]}
echo "Download speed from Gigenet Chicago:"  ${gigenet[@]}
echo "Download speed from Burstnet Scranton :"  ${burstnets[@]}
echo "Download speed from Singlehop Chicago :"  ${singlehop[@]}
echo "Download speed from Secured Servers Phoenix :"  ${ss[@]}
echo "Download speed from WholeSaleInternet Kansas :"  ${wsi[@]}
echo "Download speed from Choopa Chicago :"  ${choopa[@]}
echo "Download speed from Netdepot Atlanta :"  ${netdepotatl[@]}
echo "Download speed from Quadranet LA :"  ${quadranetla[@]}
echo "Download speed from Iweb Canada :"  ${iweb[@]}
echo "Download speed from 1000Mbps NL :"  ${mbps[@]}
} 2>&1 | tee speedtest.log
