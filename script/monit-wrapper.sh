#!/bin/bash

BASE_DIR="`dirname $0`/.."
PORT=`cat $BASE_DIR/config/port`
PID_FILE="$BASE_DIR/tmp/coop-post.pid"

cd $BASE_DIR

mkdir -p tmp


case $1 in
   start)
      echo $$ > $PID_FILE
      exec ruby script/coop-post -p $PORT 1> tmp/coop-post.log 2>&1
      ;;
    stop)
      kill `cat $PID_FILE` ;;
    *)
      echo "usage: $0 {start|stop}" ;;
esac
exit 0
