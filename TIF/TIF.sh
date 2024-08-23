#!/bin/sh

ALIAS_DIR="/var/db/aliastables"
ALIAS_NAME="Threat_Intel"
ALIAS_FILE="${ALIAS_DIR}/${ALIAS_NAME}.txt"

if [ ! -d "$ALIAS_DIR" ]; then
    mkdir -p "$ALIAS_DIR"
fi

FEEDS=(
    "https://www.spamhaus.org/drop/drop.txt"
    "https://www.malwaredomainlist.com/hostslist/ip.txt"
    "https://rules.emergingthreats.net/fwrules/emerging-Block-IPs.txt"
    "https://feodotracker.abuse.ch/downloads/ipblocklist.txt"
)

# Clear the existing alias file
> "$ALIAS_FILE"

# Fetch and update aliases
for FEED in "${FEEDS[@]}"; do
    curl -s "$FEED" | grep -Eo '([0-9]{1,3}\.){3}[0-9]{1,3}' >> "$ALIAS_FILE"
done

# Remove duplicate entries and save the updated alias
sort -u -o "$ALIAS_FILE" "$ALIAS_FILE"

# Reload OPNsense aliases
/usr/local/sbin/configctl filter reload

echo "Threat Intelligence feed integration completed and aliases updated."

