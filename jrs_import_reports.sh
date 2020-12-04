REPORTS_DIR=${1:-JR_templates} # опционально можно задать папку с архивами для импорта. По умолчанию это JR_templates
JRS_DIR=/opt/jasper/buildomatic

SCRIPT_DIR=$(
    cd $(dirname "$0")
    pwd
)
LOG_DIR=$SCRIPT_DIR/log
LOG_FILE=$LOG_DIR/JRS_import.log

echo Starting

mkdir -p $LOG_DIR
rm -f $LOG_FILE

for f in $SCRIPT_DIR/$REPORTS_DIR/*.zip; do
    if [ -e $f ]; then # проверка, что файл найден
        printf "Importing \"$f\"..."
        cd $JRS_DIR
        echo "---------------- Importing $f ----------------" &>> $LOG_FILE
        sh js-import.sh --broken-dependencies include --update --skip-user-update --input-zip $f &>> $LOG_FILE
        if [ $? -eq 0 ]; then # проверка, что импорт прошёл успешно
            echo OK
        else
            echo FAIL
            echo Logs written at $LOG_FILE
            exit 1
        fi
        cd $SCRIPT_DIR
    else
        echo Files not found!
        exit 1
    fi
done

echo Done!
echo Logs written at $LOG_FILE
exit 0
