#!/bin/bash
# chkconfig: 2345 97 80#
# Command to start postFix in a docker container.....
#

### BEGIN INIT INFO
# Provides:          startPostfixInDocker
# Required-Start:    $remote_fs $syslog
# Required-Stop:     $remote_fs $syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Start postfix daemon at boot time
# Description:       Enable postfix service provided by daemon.
### END INIT INFO


start() {
    # code to start app comes here
		service postfix start
}

status() {
		service postfix status
}

stop() {
		service postfix stop
}


case "$1" in 
    start)
       start
       ;;
    stop)
       stop
       ;;
    restart)
       stop
       start
       ;;
    status)
    	 status
       ;;
    *)
       echo "Usage: $0 {start|stop|status|restart}"
esac

exit 0 

