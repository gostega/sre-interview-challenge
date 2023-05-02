#!/bin/sh

/remote_syslog/remote_syslog -p 30348 --tls   -d logs6.papertrailapp.com   --pid-file=/var/run/remote_syslog.pid   /web.log || exit 3

# I don't know why this doesn't get send by the syslog
echo "$0: Initialising at $(date +'%Y-%m-%d_%H:%M:%S')" 2>&1 | tee /web.log
echo "." >> /web.log

# switch to the folder with the web assets
cd /www || exit 4

# start python webserver
echo "$0: starting python server" 2>&1 | tee /web.log
# -u so that it doesn't buffer the logs
# 80 serves on port 80 to be more compatible with ECS which expects 80 by default
# 2>&1 is so that the web logs gets sent to the file so we can see them in the syslog destination
>>/web.log python3 -u -m http.server 80 2>&1

# End of script