# SETTINGS
#
# DumpDir: path to temporary working directory
# DumpFile: name of the exported SQL file
# PubDir: path to public domain
# PubLink: link to public domain, without final slash
# PubUser: ower user of the public domain
# PubGroup: usergroup of the public domain
# PubDirChmod (optional): chmod flag for the public domain directory
# PubFileChmod (optional: chmod flag for the public domain file
#
dumpdir="/root/nadmin/cphulk"
dumpfile="cphulkdb.sql"
pubdir="/home/cphulk/public_html/db"
publink="http://db.cphulk.com"
pubuser="cphulk"
pubgroup="cphulk"
pubdirchmod="755"
pubfilechmod="644"
#
#
#### SCRIPT ####
echo "Dumping DBs..."
mysqldump --add-drop-table cphulkd blacklist > $dumpdir/$dumpfile
echo "Removing old DB..."
rm -rf $pubdir/$dumpfile
echo "Moving SQL file to public domain..."
mv $dumpdir/$dumpfile $pubdir
echo "Chowning..."
chown -R $pubuser:$pubgroup $pubdir
echo "Chmoding..."
chmod $pubfilechmod $pubdir
chmod $pubdirchmod $pubdir
echo "DONE! Public link: $publink/$dumpfile"
