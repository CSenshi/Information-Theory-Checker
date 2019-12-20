
# Test for problems that need .ans .dat and .code files
TNAME="$1"
PROG_NAME="$2"
TEST_SUB_FOLD="$3"
TNUM="$4"
SCRIPT_FOLDER_PATH="$5"
TEST_FOLDER_PATH="$6"
RESULT_DIR_NAME="$7"
INTERPRETER="$8"

echo
echo "### Checking ${TNAME}"

SCRIPT=${SCRIPT_FOLDER_PATH}/${PROG_NAME}
TESTS=${TEST_FOLDER_PATH}/${TEST_SUB_FOLD}/
RES_DIR=${RESULT_DIR_NAME}/${TEST_SUB_FOLD}/

if [ ! -f "${SCRIPT}" ]; then
    echo "Script not found (Try using -e flag)"
    return
fi

if [ -d "${RES_DIR}" ]; then
    rm -rf ${RES_DIR}
fi
mkdir $RES_DIR


compare_files_2args(){
    SCRIPT_PATH=$1
    PTEST_DIR_NAME=$2
    RES_DIR_NAME=$3
    TNUM=$4
    
    FNAME=${SCRIPT_PATH%.*}
    FNAME=${FNAME##*/}
    
    for i in $(seq 1 $TNUM);
    do
        while [ ${#i} -lt 3 ]; do
            i=0$i
        done
        
        CURRENT_TEST=${PTEST_DIR_NAME}${i}.dat
        CURRENT_TEST_CODE=${PTEST_DIR_NAME}${i}.code
        CURRENT_TEST_ANS=${PTEST_DIR_NAME}${i}.ans
        DEST_FILE_NAME=${RES_DIR_NAME}/${FNAME}_${i}.txt
        
        # launch your python script
        eval ${INTERPRETER} ${SCRIPT_PATH} \"$CURRENT_TEST_CODE\" \"$CURRENT_TEST\" "${DEST_FILE_NAME}"
        
        # check if correct
        echo "Test ${i} : $(eval diff -w -q \"$CURRENT_TEST_ANS\" \"$DEST_FILE_NAME\" && echo "Success: files are same!" || echo "Failed: files are different")"
    done
}
eval compare_files_2args \"${SCRIPT}\" \"${TESTS}\" \"${RES_DIR}\" "${TNUM}"