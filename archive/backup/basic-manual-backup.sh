### Edit Variables ###
backup_location="/home/user/backup" # Don't use relative paths
sql_user="my_sql_user"
sql_db="my_sql_database"
sql_pass="MySuperSecretPassword"
backup_directories="/home/user/dir1 /home/user/dir2" # Separate multiple directories by space
### Stop Editing ###

now=$(date +"%m_%d_%Y")
echo "Checking & Creating backup location..."
mkdir -p $backup_location/$now
echo "Dumping SQL..."
mysqldump -u $sql_user -p$sql_pass $sql_db > $backup_location/$now/$sql_db-$now.sql
echo "Compressing SQL..."
cd $backup_location/$now && tar -czf $sql_db-$now-sql.tar.gz $sql_db-$now.sql
echo "Cleaning up SQL..."
rm -rf $backup_location/$now/$sql_db-$now.sql
echo "Compressing directories..."
cd $backup_location/$now/ && tar -czf files-$now.tar.gz $backup_directories
echo "DONE!"
