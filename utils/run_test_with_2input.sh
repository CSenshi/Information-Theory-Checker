# !/bin/bash

TNAME="$1"
PROG_NAME="$2"
TEST_SUB_FOLD="$3"
TNUM="$4"
GENERATED_CODE_DIR_NAME="$5"
SCRIPT_FOLDER_PATH="$6"
TEST_FOLDER_PATH="$7"
RESULT_DIR_NAME="$8"
INTERPRETER="$9"

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

compare_files4(){
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
        CURRENT_TEST_ANS=${PTEST_DIR_NAME}${i}.ans
        CUR_CODE=${GENERATED_CODE_DIR_NAME}${i}.txt
        DEST_FILE_NAME=${RES_DIR_NAME}/${FNAME}_${i}.txt
        
        # launch your python script
        eval ${INTERPRETER} ${SCRIPT_PATH} \"${CUR_CODE}\" \"${CURRENT_TEST}\" "${DEST_FILE_NAME}"
        
        # check if correct
        echo "Test ${i} : $(eval diff -w -q \"$CURRENT_TEST_ANS\" \"$DEST_FILE_NAME\" && echo "Success: files are same!" || echo "Failed: files are different")"
    done
}
eval compare_files4 \"${SCRIPT}\" \"${TESTS}\" \"${RES_DIR}\" "${TNUM}"