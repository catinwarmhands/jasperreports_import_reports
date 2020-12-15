REPORTS_DIR=${1:-JR_templates} # опционально можно задать папку с архивами для импорта. По умолчанию это JR_templates
JRS_DIR=/opt/jasper/buildomatic

SCRIPT_DIR=$(
	cd $(dirname "$0")
	pwd
)

TEMP_DIR=$SCRIPT_DIR/temp
TEMP_LINK=$TEMP_DIR/link

LOG_DIR=$SCRIPT_DIR/log
LOG_FILE=$LOG_DIR/JRS_import.log

echo Starting

mkdir -p $TEMP_DIR
rm -f $TEMP_LINK

mkdir -p $LOG_DIR
rm -f $LOG_FILE

for f in $SCRIPT_DIR/$REPORTS_DIR/*.zip; do
	printf "Importing \"$f\"..."
	
	ln -s "$f" $TEMP_LINK
	if [ -e "$f" ]; then # проверка, что файл найден
		cd $JRS_DIR
		echo "---------------- Importing \"$f\" ----------------" &>> $LOG_FILE
		
		sh js-import.sh --input-zip $TEMP_LINK --broken-dependencies include --update --skip-user-update &>> $LOG_FILE
		
		if [ $? -eq 0 ]; then # проверка, что импорт прошёл успешно
			echo OK
		else
			rm -rf $TEMP_DIR
			echo FAIL
			echo Logs written at $LOG_FILE
			exit 1
		fi
		cd $SCRIPT_DIR
	else
		rm -rf $TEMP_DIR
		echo Files not found!
		exit 1
	fi
	rm -f $TEMP_LINK
done

rm -rf $TEMP_DIR
echo Done!
echo Logs written at $LOG_FILE
exit 0
