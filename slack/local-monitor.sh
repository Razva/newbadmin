#!/bin/bash
# Special thanks to koala_man @ FreeNode
# Requirements: JQ 1.5+ should be installed. For CentOS "yum install jq", for Ubuntu "apt-get install jq".

# Configuration
file="/some/file.log"
hook="https://hooks.slack.com/services/YOUR-HOOK"
ignores="ignored_keyword|another_ignored_keyword" # split multiple ignores with pipes
### STOP EDITING ###

export LC_ALL=C
tail -n0 -F "$file" | while IFS= read -r line; do
  (printf '%s\n' "$line" | grep -vE -e "$ignores") && curl -X POST --silent --data-urlencode \
    "payload={\"text\": $(jq -sR '.' <<< "$line" ) }" "$hook";
done
