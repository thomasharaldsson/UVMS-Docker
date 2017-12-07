#!/bin/sh
#
# /etc/init.d/wildfly -- startup script for WildFly
#
#
### BEGIN INIT INFO
# Provides:             wildfly
# Required-Start:       $remote_fs $network
# Required-Stop:        $remote_fs $network
# Should-Start:         $named
# Should-Stop:          $named
# Default-Start:        2 3 4 5
# Default-Stop:         0 1 6
# Short-Description:    WildFly Application Server
# Description:          Provide WildFly startup/shutdown script
### END INIT INFO
# Source function library.
#. /etc/init.d/functions
. /etc/rc.status

# First reset status of this service
rc_reset

# Load Java configuration.
[ -r /etc/java/java.conf ] && . /etc/java/java.conf
export JAVA_HOME

# Load JBoss AS init.d configuration.
if [ -z "$JBOSS_CONF" ]; then
	JBOSS_CONF="/etc/default/wildfly.conf"
fi


[ -r "$JBOSS_CONF" ] && . "${JBOSS_CONF}"

# Set defaults.

if [ -z "$JBOSS_HOME" ]; then
	JBOSS_HOME=/opt/wildfly
fi
export JBOSS_HOME

if [ -z "$JBOSS_PIDFILE" ]; then
	JBOSS_PIDFILE=/var/run/wildfly/wildfly.pid
fi
export JBOSS_PIDFILE

if [ -z "$JBOSS_CONSOLE_LOG" ]; then
	JBOSS_CONSOLE_LOG=/var/log/wildfly/console.log
fi

if [ -z "$STARTUP_WAIT" ]; then
	STARTUP_WAIT=30
fi

if [ -z "$SHUTDOWN_WAIT" ]; then
	SHUTDOWN_WAIT=30
fi

# Startup mode of wildfly
if [ -z "$JBOSS_MODE" ]; then
	JBOSS_MODE=standalone
fi

# Startup mode script
if [ "$JBOSS_MODE" = "standalone" ]; then
	JBOSS_SCRIPT=$JBOSS_HOME/bin/standalone.sh
	if [ -z "$JBOSS_CONFIG" ]; then
		JBOSS_CONFIG=standalone.xml
	fi
else
	JBOSS_SCRIPT=$JBOSS_HOME/bin/domain.sh
	if [ -z "$JBOSS_DOMAIN_CONFIG" ]; then
		JBOSS_DOMAIN_CONFIG=domain.xml
	fi
	if [ -z "$JBOSS_HOST_CONFIG" ]; then
		JBOSS_HOST_CONFIG=host.xml
	fi
fi

if [ -z "$JBOSS_USER" ]; then
	JBOSS_USER=wildfly
fi
export JBOSS_USER

prog='wildfly'

CMD_PREFIX=''

if [ ! -z "$JBOSS_USER" ]; then
	if [ -r /etc/rc.d/init.d/functions ]; then
		CMD_PREFIX="daemon --user $JBOSS_USER"
	else
		CMD_PREFIX="su  - $JBOSS_USER -C"
	fi
fi

start() {
	echo -n "Starting $prog: "
	if [ -f $JBOSS_PIDFILE ]; then
		read ppid < $JBOSS_PIDFILE
		if [ `ps --pid $ppid 2> /dev/null | grep -c $ppid 2> /dev/null` -eq '1' ]; then
			echo -n "$prog is already running"
	        rc_status -s
       	    rc_exit
		else
			rm -f $JBOSS_PIDFILE
		fi
	fi
	mkdir -p $(dirname $JBOSS_CONSOLE_LOG)
	cat /dev/null > $JBOSS_CONSOLE_LOG

	mkdir -p $(dirname $JBOSS_PIDFILE)
	chown $JBOSS_USER $(dirname $JBOSS_PIDFILE) || true
	#$CMD_PREFIX JBOSS_PIDFILE=$JBOSS_PIDFILE $JBOSS_SCRIPT 2>&1 >> $JBOSS_CONSOLE_LOG &
	#$CMD_PREFIX JBOSS_PIDFILE=$JBOSS_PIDFILE $JBOSS_SCRIPT &
	
	if [ ! -z "$JBOSS_USER" ]; then
		if [ "$JBOSS_MODE" = "standalone" ]; then
			
			if [ -r /etc/rc.d/init.d/functions ]; then
				$CMD_PREFIX LAUNCH_JBOSS_IN_BACKGROUND=1 JBOSS_PIDFILE=$JBOSS_PIDFILE $JBOSS_SCRIPT -c $JBOSS_CONFIG >> $JBOSS_CONSOLE_LOG 2>&1 &
			else
				$CMD_PREFIX "LAUNCH_JBOSS_IN_BACKGROUND=1 JBOSS_PIDFILE=$JBOSS_PIDFILE $JBOSS_SCRIPT -c $JBOSS_CONFIG" >> $JBOSS_CONSOLE_LOG 2>&1 &
			fi
		else
			if [ -r /etc/rc.d/init.d/functions ]; then
				$CMD_PREFIX LAUNCH_JBOSS_IN_BACKGROUND=1 JBOSS_PIDFILE=$JBOSS_PIDFILE $JBOSS_SCRIPT --domain-config=$JBOSS_DOMAIN_CONFIG --host-config=$JBOSS_HOST_CONFIG >> $JBOSS_CONSOLE_LOG 2>&1 &
			else
				$CMD_PREFIX "LAUNCH_JBOSS_IN_BACKGROUND=1 JBOSS_PIDFILE=$JBOSS_PIDFILE $JBOSS_SCRIPT --domain-config=$JBOSS_DOMAIN_CONFIG --host-config=$JBOSS_HOST_CONFIG" >> $JBOSS_CONSOLE_LOG 2>&1 &
			fi
		fi
	fi
	
    count=0
    launched=false
	echo "wait for start"
	
	until [ $count -gt $STARTUP_WAIT ]
	do
		grep 'JBAS015874:' $JBOSS_CONSOLE_LOG > /dev/null
		if [ $? -eq 0 ] ; then
			launched=true
			break
		fi
			
		sleep 1
		echo -n .
		let count=$count+1;
	done

    rc_reset
}

stop() {
  echo -n $"Stopping $prog: "
  count=0;

  if [ -f $JBOSS_PIDFILE ]; then
    read kpid < $JBOSS_PIDFILE
    let kwait=$SHUTDOWN_WAIT

    # Try issuing SIGTERM

    kill -15 $kpid
    until [ `ps --pid $kpid 2> /dev/null | grep -c $kpid 2> /dev/null` -eq '0' ] || [ $count -gt $kwait ]
    do
      sleep 1
	  echo -n .
      let count=$count+1;
    done

    if [ $count -gt $kwait ]; then
      kill -9 $kpid
    fi
  fi
  rm -f $JBOSS_PIDFILE
  rc_reset
  
}

status() {
  if [ -f $JBOSS_PIDFILE ]; then
    read ppid < $JBOSS_PIDFILE
    if [ `ps --pid $ppid 2> /dev/null | grep -c $ppid 2> /dev/null` -eq '1' ]; then
      echo -n "$prog is running (pid $ppid)"
	  rc_reset 
	  
    else
      echo -n "$prog dead but pid file exists"
      rc_failed 1 
    fi
  else
	echo -n "$prog is not running"
	rc_failed 3
  fi
  
}

case "$1" in
  start)
      start
	  rc_status -v
      ;;
  stop)
      stop
	  rc_status -v

      ;;
  restart)
      $0 stop
	  $0 start
	  rc_status

      ;;
  status)
      status
	  rc_status -v

      ;;
  *)
      ## If no parameters are given, print which are avaiable.
      echo "Usage: $0 {start|stop|status|restart}"
      exit 1
      ;;
esac
