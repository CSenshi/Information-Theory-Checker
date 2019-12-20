# !/bin/bash

if [ "$#" -ne 8 ] && [ "$#" -ne 10 ] && [ "$#" -ne 12 ] && [ "$#" -ne 14 ] ; then
    echo "Invalid Arguments"
    echo "Usage: script requires 3-5 Arguments: "
    echo "       -s Path to folder which contains following scripts with exact names:"
    echo "                   SimpleRead.py, SimpleWrite.py, CompleteWrite.py, CompleteRead.py"
    echo "       -t Path to folder which contains public tests(where A,B,C,D folders are located)"
    echo "       -T Path to folder which contains test scriptis (i.e. test_C.py, test_d.py"
    echo "       -r Path to folder where we should put output for each test"
    echo "       -e Extension of your file (pass with dot exaple: .py)"
    echo "       -i Your Interpreter (If using executable)"
    echo "       -py Your Python Interpreter (Used to test C and D)"
    echo "Example: /check.sh -s src/ -t public_tests/ -r res/ -e .py -i python3 -T script/"
    
    exit
fi
# Read Command Line Arguments
POSITIONAL=()
while [[ $# -gt 0 ]]
do
    key="$1"
    case $key in
        -s)
            SCRIPT_FOLDER_PATH="$2"
            shift # past argument
            shift # past value
        ;;
        -t)
            TEST_FOLDER_PATH="$2"
            shift # past argument
            shift # past value
        ;;
        -T)
            TESTER_SCRIPT_FOLDER="$2"
            shift # past argument
            shift # past value
        ;;
        -r)
            RESULT_DIR_NAME="$2"
            shift # past argument
            shift # past value
        ;;
        -e)
            EXTENSION="$2"
            shift # past argument
            shift # past value
        ;;
        -i)
            INTERPRETER="$2"
            shift # past argument
            shift # past value
        ;;
        -py3)
            PYTHON3="$2"
            shift # past argument
            shift # past value
        ;;
        *)    # unknown option
            POSITIONAL+=("$1") # save it in an array for later
            shift # past argument
        ;;
    esac
done
set -- "${POSITIONAL[@]}" # restore positional parameters


[ -z "$SCRIPT_FOLDER_PATH" ] && printf "Script Folder path shouldn't be empty (use -s) \nexiting...\n" && exit
echo "Script Folder path:    $(pwd)/${SCRIPT_FOLDER_PATH}"

[ -z "$TEST_FOLDER_PATH" ] && printf "Test Folders path shouldn't be empty (use -t) \nexiting...\n" && exit
echo "Test Folders path:     $(pwd)/${TEST_FOLDER_PATH}"

[ -z "$RESULT_DIR_NAME" ] && printf "Result Directory Path shouldn't be empty (use -s) \nexiting...\n" && exit
echo "Result Directory Path: $(pwd)/${RESULT_DIR_NAME}"

echo "Extension:             ${EXTENSION}"
echo "Interpreter:           ${INTERPRETER}"

# delete Result Dir if exists
if [ ! -d "${RESULT_DIR_NAME}" ]; then
    mkdir ${RESULT_DIR_NAME}
fi

echo
echo "Starting Tests..."

# Run Simple Comparision
run_test_compare(){
    TNAME="$1"
    PROG_NAME="$2"
    TEST_SUB_FOLD="$3"
    TNUM="$4"
    
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
    eval compare_files \"${SCRIPT}\" \"${TESTS}\" \"${RES_DIR}\" "${TNUM}"
}

compare_files(){
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
        DEST_FILE_NAME=${RES_DIR_NAME}/${FNAME}_${i}.txt
        
        # launch your python script
        eval ${INTERPRETER} ${SCRIPT_PATH} \"$CURRENT_TEST\" "${DEST_FILE_NAME}"
        
        # check if correct
        echo "Test ${i} : $(eval diff -w -q \"$CURRENT_TEST_ANS\" \"$DEST_FILE_NAME\" && echo "Success: files are same!" || echo "Failed: files are different")"
    done
}

# Compare files that require checker scripts
run_test_with_checkers(){
    TNAME="$1"
    PROG_NAME="$2"
    TEST_SUB_FOLD="$3"
    TNUM="$4"
    TEST_SCRIPT="$5"
    
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
    eval compare_files_with_checker \"${SCRIPT}\" \"${TESTS}\" \"${RES_DIR}\" "${TNUM}" ${TEST_SCRIPT}
}

compare_files_with_checker(){
    SCRIPT_PATH=$1
    PTEST_DIR_NAME=$2
    RES_DIR_NAME=$3
    TNUM=$4
    TEST_SCRIPT=$5
    
    FNAME=${SCRIPT_PATH%.*}
    FNAME=${FNAME##*/}
    
    for i in $(seq 1 $TNUM);
    do
        while [ ${#i} -lt 3 ]; do
            i=0$i
        done
        
        CURRENT_TEST=${PTEST_DIR_NAME}${i}.dat
        CURRENT_TEST_ANS=${PTEST_DIR_NAME}${i}.ans
        DEST_FILE_NAME=${RES_DIR_NAME}/${FNAME}_${i}.txt
        
        # launch your python script
        eval ${INTERPRETER} ${SCRIPT_PATH} \"$CURRENT_TEST\" "${DEST_FILE_NAME}"
        
        # check if correct
        echo "Test ${i}: "
        ${PYTHON3} "${TESTER_SCRIPT_FOLDER}/${TEST_SCRIPT}" "$CURRENT_TEST_ANS" "${DEST_FILE_NAME}"
        echo
    done
}

# Test for problems that need .ans .dat and .code files
run_test_compare_2args(){
    TNAME="$1"
    PROG_NAME="$2"
    TEST_SUB_FOLD="$3"
    TNUM="$4"
    
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
    eval compare_files_2args \"${SCRIPT}\" \"${TESTS}\" \"${RES_DIR}\" "${TNUM}"
}

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

run_test_compare "Distrib" "Distrib${EXTENSION}" "A" 2
run_test_compare "Entropy" "Entropy${EXTENSION}" "B" 2
run_test_with_checkers "PrefCode" "PrefCode${EXTENSION}" "C" 8 "test_C.py"
run_test_with_checkers "Huffman" "Huffman${EXTENSION}" "D" 5 "test_D.py"
run_test_compare_2args "Compress" "Compress${EXTENSION}" "E" 5
run_test_compare_2args "Decompress" "Decompress${EXTENSION}" "F" 5