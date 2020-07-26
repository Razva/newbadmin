# SETTINGS
#
workdir="/root"
publink="http://db.cphulk.com"
pubfile="cphulkdb.sql"
sqluser="root"
sqlpass="SOME_PASSWORD"
#
#### SCRIPT ###
echo "Changing current dir to workdir..."
cd $workdir
echo "Removing old DB..."
rm -rf $workdir/$pubfile
echo "Downloading DB..."
wget $publink/$pubfile
echo "Importing DB..."
mysql -u $sqluser -p$sqlpass cphulkd < $workdir/$pubfile
echo "Cleanup..."
rm -rf $workdir/$pubfile
echo "DONE! Succesfully imported DB from $publink/$pubfile!"
