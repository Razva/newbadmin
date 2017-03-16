#!/bin/bash
# Special thanks go to geirha, Soliton, greycat, _adb, phogg and all the great folks from Freenode that guided me

### Configurable options ###

# Directories
working_dir="/backup/tmp" # where will all the magic happen
source="/home/test" # directory which you want to backup, recursively
target="/backup" # where backups are stored
exclude_dirs=(./exclude1 ./exclude2) # a list of directories that you want to exclude from backups. These files should be inside the source.

# Databases
sql_user="root" # DB username
sql_pass="ra88du457E45G9s" # DB pass
sql_excludes="gadget_wp|gadget_ads" # insert databases separated by pipes

# Miscellaneous
days="7" # how many days should we keep the files
filename="backup" # backup filename, it will result in a filename.tar.gz

### STOP EDITING ###

# Prerequisites
rm -rf "$working_dir"
id=$(date +%Y%m%d-%H%M%S)

# Dumping and compressing databases
mkdir -p "$working_dir/db"
mysql -s -r -u "$sql_user" -p"$sql_pass" -e 'show databases' | grep -Ev 'Database|mysql|information_schema|performance_schema|phpmyadmin|'"$sql_excludes" | while read db; do mysqldump -u "$sql_user" -p"$sql_pass" "$db" -r "$working_dir/db/${db}-$id.sql" && gzip "$working_dir/db/${db}-$id.sql"; done

# Prune function, necessary for excludes
get_prune() {
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
find "$target" -type d ! -newermt "$days days ago" -delete
