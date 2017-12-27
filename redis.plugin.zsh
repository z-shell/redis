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

typeset -g ZSRV_REDIS="${0:h}"

if [[ -f "${ZSRV_REDIS}/redis.conf" ]]; then
    redis-server "${ZSRV_REDIS}/redis.conf"
elif [[ -f "${ZSRV_REDIS}/redis.conf.default" ]]; then
    redis-server "${ZSRV_REDIS}/redis.conf.default"
else
    print "No redis.conf found, redis-server did not run"
fi
