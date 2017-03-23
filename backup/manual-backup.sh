#!/bin/bash
#
# Written with the help of greycat, _adb, phogg, geirha and other great folks from Freenode
# Special thanks go to Soliton for guiding, reviewing and correcting this script
#
### Configurable options ###

# Debugging - uncomment the following line if you would like to see what is happening
#set -x

# Directories
working_dir="/tmp/backup" # Where will all the magic happen. Local storage is highly recommended.
source="/home/some-dir" # What do you want to backup.
target="/backup" # Where do you want to store backups.
exclude_dirs=(./exclude1 ./exclude2) # Directories that you want to exclude from backups. These files should be inside the previously specified source. Use () for no exclusions.

# Databases
sql_user="root" # DB username
sql_pass="MySecurePassword" # DB pass
sql_excludes="excluded_database|another_excluded_database" # Excluded databases, separated by pipes. Use "" for no exclusions.

# Miscellaneous
days="7" # How many days should we keep the files.
filename="backup" # Backup filename, it will result in a filename.tar.gz

### STOP EDITING ###

# Prerequisites
rm -rf "$working_dir"
id=$(date +%Y%m%d-%H%M%S)

# Dumping and compressing databases
mkdir -p "$working_dir/db"
mysql -s -r -u "$sql_user" -p"$sql_pass" -e 'show databases' | grep -Ev -e 'Database|mysql|information_schema|performance_schema|phpmyadmin' ${sql_excludes:+-e "$sql_excludes"} | while read db; do mysqldump -u "$sql_user" -p"$sql_pass" "$db" -r "$working_dir/db/${db}-$id.sql" && gzip "$working_dir/db/${db}-$id.sql"; done

# Prune function, necessary for excludes
get_prune() {
	(($#)) || return
    prune=('(' '(')
    local arg or=()
    for arg; do
        prune+=("${or[@]}")
        if [[ $arg == */* ]]; then
            prune+=(-path)
        else
            prune+=(-name)
        fi
        prune+=("$arg")
        or=(-o)
    done
    prune+=(')' '!' -prune ')' -o)
}

# Archiving files
mkdir -p "$working_dir/files"
cd "$source" || exit;
get_prune "${exclude_dirs[@]}";
find . "${prune[@]}" -type f -print0 | tar -czf "$working_dir/files/$filename-$id.tar.gz" --null -T -

# Cleaning up
mv "$working_dir" "$target/$id"
#find "$target" -type d ! -path "$target" ! -newermt "$days days ago" -prune -exec rm -rf {} \; # uncomment this if you would like to remove backups older than X days, rather than latest X backups
backups=( "$target"/*/ ) n=${#backups[@]}; if (( n > 3 )); then echo rm -rf "${backups[@]:0:n-3}"; else printf 'Leaving all %s backups alone\n' "$n"; fi
