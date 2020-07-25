red=$'\e[91m'
green=$'\e[92m'
yellow=$'\e[93m'
cyan=$'\e[96m'
normal=$'\e[0m'

h1() { printf '%s=== %s%s' "$green" "$1" "$normal"; }
h2() { printf '%s== %s%s' "$yellow" "$1" "$normal"; }
h3() { printf '%s= %s%s' "$cyan" "$1" "$normal"; }
yl() { printf '%s' "$yellow" "$1" "$normal"; }
cy() { printf '%s' "$cyan" "$1" "$normal"; }
