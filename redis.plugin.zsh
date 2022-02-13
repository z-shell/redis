#
# A z-service file that runs redis database server (redis-server).
#
# Use with plugin manager that supports single plugin load per all active Zsh
# sessions. The p-m should set parameters ZSRV_WORK_DIR and ZSRV_ID.
#
# You should copy `redis.conf.default' to `redis.conf' and adapt it to your
# needs. The service will use the `*.default' file if there is no `*.conf'
# file.
#

0="${${ZERO:-${(M)0##/*}}:-${(%):-%N}}"  # try ZERO, filter absolute path from $0, fallback to %N

(( ! ${+ZSRV_WORK_DIR} || ! ${+ZSRV_ID} )) && { print "Error: plugin \`zservices/redis' needs to be loaded as service, aborting."; return 1; }

typeset -g ZSRV_DIR="${0:h}"
typeset -g ZSRV_PID

local pidfile="$ZSRV_WORK_DIR"/"$ZSRV_ID".pid logfile="$ZSRV_WORK_DIR"/"$ZSRV_ID".log
local cfg="${ZSRV_DIR}/redis.conf"
[[ ! -f "$cfg" ]] && cfg="${ZSRV_DIR}/redis.conf.default"

if [[ -f "$cfg" ]]; then
    { local pid="$(<$pidfile)"; } 2>/dev/null
    if [[ ${+commands[pkill]} = 1 && "$pid" = <-> && $pid -gt 0 ]]; then
        if command pkill -INT -x -F "$pidfile" redis-server.\*; then
            builtin print "ZSERVICE: Stopped previous redis-server instance, PID: $pid" >>! "$logfile"
            LANG=C sleep 1.5
        else
            builtin print "ZSERVICE: Previous redis-server instance (PID:$pid) not running" >>! "$logfile"
        fi
    fi

    builtin trap 'kill -INT $ZSRV_PID; command sleep 2; builtin exit 1' HUP
    redis-server "$cfg" >>!"$logfile" 2>&1 &; ZSRV_PID=$!
    builtin echo "$ZSRV_PID" >! "$pidfile"
    LANG=C command sleep 0.7
    builtin return 0
else
    builtin print "ZSERVICE: No redis.conf found, redis-server did not run" >>! "$logfile"
    builtin return 1
fi
