#
# A z-service file that runs redis database server.
#
# Use with plugin manager that supports single plugin load per all active Zsh
# sessions.
#
# You should copy `redis.conf.default' to `redis.conf' and adapt it to your
# needs. The service will use the `*.default' file if there is no `*.conf'
# file.

0="${${(M)0##/*}:-${(%):-%N}}"  # filter absolute path, fallback to %N

typeset -g ZSRV_DIR="${0:h}"
typeset -g ZSRV_PID

local pidfile="$ZSRV_WORK_DIR"/"$ZSRV_ID".pid logfile="$ZSRV_WORK_DIR"/"$ZSRV_ID".log
local cfg="${ZSRV_DIR}/redis.conf"
[[ ! -f "$cfg" ]] && cfg="${ZSRV_DIR}/redis.conf.default"

if [[ -f "$cfg" ]]; then
    { local pid="$(<$pidfile)"; } 2>/dev/null
    if [[ ${+commands[pkill]} = 1 && "$pid" = <-> && $pid -gt 0 ]]; then
        if pkill -INT -x -F "$pidfile" redis-server.\*; then
            print "Stopped previous redis-server instance, PID: $pid"
            LANG=C sleep 0.3
        else
            print "Previous redis-server instance (PID:$pid) not running"
        fi
    fi

    trap 'kill -INT $ZSRV_PID; exit 0' HUP
    redis-server "$cfg" >>!"$logfile" 2>&1 &; ZSRV_PID=$!
    echo "$ZSRV_PID" >! "$pidfile"
    return 0
else
    print "No redis.conf found, redis-server did not run"
    return 1
fi
