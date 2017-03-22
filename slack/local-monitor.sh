#!/bin/bash
# Special thanks to koala_man @ FreeNode

# Configuration
file="/some/file.log"
hook="https://hooks.slack.com/services/YOUR-HOOK"
ignores="ignored_keyword|another_ignored_keyword" # split multiple ignores with pipes
### STOP EDITING ###

tail -n0 -F "$file" | while read LINE; do
  (echo "$LINE" | grep -vE -e "$ignores") && curl -X POST --silent --data-urlencode \
    "payload={\"text\": \"$(echo $LINE | sed "s/\"/'/g")\"}" "$hook";
done
