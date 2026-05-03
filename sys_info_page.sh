#!/bin/bash

# Basic info
TITLE="System Information Report For $HOSTNAME"
CURRENT_TIME="$(date "+%x %r %Z")"
TIMESTAMP="Generated $CURRENT_TIME, by $USER"
KERNEL="$(uname -r)"
CPU="$(grep -m1 'model name' /proc/cpuinfo | cut -d: -f2)"
MEM="$(free -h | awk '/Mem:/ {print $3 " / " $2}')"

DELAY=3

# Functions
report_uptime () {
    uptime -p
}

report_disk_space () {
    df -h / | awk 'NR==2 {print $3 " used out of " $2}'
}

report_home_space () {
    df -h ~ | awk 'NR==2 {print $3 " used out of " $2}'
}

generate_html () {
{
echo "<!DOCTYPE html>"
echo "<html>"
echo "<head>"
echo "<title>$TITLE</title>"
echo "<style>"
echo "body { font-family: Arial; background:#0f172a; color:#e2e8f0; margin:40px; }"
echo "h1 { color:#38bdf8; }"
echo ".card { background:#1e293b; padding:20px; border-radius:10px; max-width:600px; }"
echo "</style>"
echo "</head>"
echo "<body>"
echo "<div class='card'>"
echo "<h1>$TITLE</h1>"
echo "<p>$TIMESTAMP</p>"
echo "<hr>"
echo "<p><b>Uptime:</b> $(report_uptime)</p>"
echo "<p><b>Kernel:</b> $KERNEL</p>"
echo "<p><b>CPU:</b> $CPU</p>"
echo "<p><b>Memory:</b> $MEM</p>"
echo "<p><b>Disk (/):</b> $(report_disk_space)</p>"
echo "<p><b>Home (~):</b> $(report_home_space)</p>"
echo "</div>"
echo "</body>"
echo "</html>"
} > index.html

echo "HTML report generated → index.html"
}

# MENU LOOP
while true; do
    clear

    cat <<EOF
==============================
   SYSTEM INFO MENU
==============================
1. Display System Information
2. Display Disk Space
3. Display Home Space
4. Generate HTML Report
0. Quit
==============================
EOF

    read -p "Enter selection [0-4]: " REPLY

    if [[ "$REPLY" =~ ^[0-4]$ ]]; then

        if [[ "$REPLY" == 1 ]]; then
            echo "Hostname: $HOSTNAME"
            echo "Uptime: $(report_uptime)"
            sleep $DELAY
            continue
        fi

        if [[ "$REPLY" == 2 ]]; then
            report_disk_space
            sleep $DELAY
            continue
        fi

        if [[ "$REPLY" == 3 ]]; then
            report_home_space
            sleep $DELAY
            continue
        fi

        if [[ "$REPLY" == 4 ]]; then
            generate_html
            sleep $DELAY
            continue
        fi

        if [[ "$REPLY" == 0 ]]; then
            break
        fi

    else
        echo "Invalid entry."
        sleep $DELAY
    fi

done

echo "Program terminated."
