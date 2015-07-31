#bin 

PROJECT_NAME="$1"

# if no args specified, show usage
if [ $# = 0 ]; then
  echo "Usage: sync2master project_name"
  exit 1
fi

BIN=$HOME"/bin"
DEV_HOSTNAME=`cat $BIN/conf/dev`
SLAVES=`cat $BIN/conf/slaves`
SLAVE_USER=`cat $BIN/conf/slave-user`

EXCLUDE_FILES=$HOME"/bin/exclude-list.txt"

SOURCE_DIR=$HOME"/workspace/$PROJECT_NAME"
TARGET_DIR="~"
TARGET_HOSTNAMES=$SLAVES

if [ ! -d "$SOURCE_DIR" ]; then
  echo "project directory $SOURCE_DIR does not exists"
  exit 1
fi

function sync2one() {
  EXEC_CALL="rsync --update -raz --progress --exclude-from "$EXCLUDE_FILES" "$SOURCE_DIR" "$SLAVE_USER@"$1":$TARGET_DIR

  echo $EXEC_CALL
#  exec $EXEC_CALL &
}

for TARGET_HOST in $TARGET_HOSTNAMES
do
  sync2one $TARGET_HOST
done

