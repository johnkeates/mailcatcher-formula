#!/bin/sh
### BEGIN INIT INFO
# Provides:          mailcatcher
# Required-Start:    $local_fs $remote_fs $network $syslog $named
# Required-Stop:     $local_fs $remote_fs $network $syslog $named
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Start/stop mailcatcher smtp server
### END INIT INFO

NAME=mailcatcher
DAEMON="{{ mailcatcher['mailcatcher_bin'] }}"
PIDFILE=/var/run/mailcatcher.pid

set -e

. /lib/lsb/init-functions

test -f /etc/default/rcS && . /etc/default/rcS

test -f $DAEMON || exit 0

case $1 in
    start)
        log_daemon_msg "Starting smtp server" $NAME
        start_daemon -p $PIDFILE --make-pidfile $DAEMON --http-ip 0.0.0.0 --smtp-port 25
        log_end_msg $?
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
