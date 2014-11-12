#!/bin/sh
### BEGIN INIT INFO
# Provides:          mailcatcher
# Required-Start:    $local_fs $remote_fs $network $syslog $named
# Required-Stop:     $local_fs $remote_fs $network $syslog $named
# X-Start-Before:    {% if salt['pillar.get']('mailcatcher:apache_integration', False)
                      %}{{ mailcatcher.apache_service }} {% endif %}
                     {%- if salt['pillar.get']('mailcatcher:nginx_integration', False)
                      %}{{ mailcatcher.nginx_service }} {% endif %}
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Start/stop mailcatcher smtp server
### END INIT INFO

NAME=mailcatcher
DAEMON="{{ mailcatcher['mailcatcher_bin'] }}"
DAEMON_ARGS="--http-ip 0.0.0.0 --smtp-port 25"
PIDFILE=/var/run/mailcatcher.pid

set -e

. /lib/lsb/init-functions

test -f /etc/default/rcS && . /etc/default/rcS

test -f $DAEMON || exit 0

case $1 in
    start)
        log_daemon_msg "Starting smtp server" $NAME
        /sbin/start-stop-daemon --start --nicelevel 0 --quiet --oknodo \
            --pidfile $PIDFILE --exec $DAEMON -- $DAEMON_ARGS
        RETVAL=$?
        if [ x$? = x0 ]; then
            sleep 2  # give it a chance to fork
            ps auxgw | grep $DAEMON | grep -v grep | head -n 1 | awk '{print $2}' > $PIDFILE
        fi
        log_end_msg $RETVAL
        exit $RETVAL
    ;;
    stop)
        log_daemon_msg "Stopping smtp server" $NAME
        killproc -p $PIDFILE $DAEMON
        RETVAL=$?
        [ $RETVAL -eq 0 ] && [ -e "$PIDFILE" ] && rm -f $PIDFILE
        log_end_msg $RETVAL
    ;;
    force-reload|reload|restart)
        log_daemon_msg "Restarting smtp server" $NAME
        $0 stop
        $0 start
        exit $?
    ;;
	status)
        status_of_proc -p $PIDFILE "$DAEMON" $NAME
        exit $?
    ;;
    *)
        log_action_msg "Usage: $NAME {start|stop|force-reload|reload|restart|status}"
        exit 2
    ;;
esac
