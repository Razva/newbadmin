### Edit Variables ###
backup_location="/home/user/backup" # Don't use relative paths
sql_user="my_sql_user"
sql_db="my_sql_database"
sql_pass="MySuperSecretPassword"
backup_directories="/home/user/dir1 /home/user/dir2" # Separate multiple directories by space
excluded_directories="/home/user/excluded"
### Stop Editing ###

now=$(date +"%Y_%m_%d")
echo "Checking & Creating backup location..."
mkdir -p $backup_location/$now
echo "Dumping SQL..."
mysqldump -u $sql_user -p$sql_pass $sql_db > $backup_location/$now/sql-$sql_db-$now.sql
echo "Compressing SQL..."
cd $backup_location/$now && tar czfP sql-$sql_db-$now.tar.gz sql-$sql_db-$now.sql
echo "Cleaning up SQL..."
rm -rf $backup_location/$now/sql-$sql_db-$now.sql
echo "Compressing directories..."
cd $backup_location/$now/ && tar czfP files-$now.tar.gz --exclude="$excluded_directories" $backup_directories
echo "DONE!"
