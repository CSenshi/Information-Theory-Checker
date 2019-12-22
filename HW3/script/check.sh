# !/bin/bash


if [ "$#" -ne 8 ] && [ "$#" -ne 10 ] && [ "$#" -ne 12 ] && [ "$#" -ne 14 ] ; then
    echo "Invalid Arguments"
    echo "Usage: script requires 3-5 Arguments: "
    echo "       -s Path to folder which contains following scripts with exact names:"
    echo "                   StandardForm.XXX, ParityCheck.XXX, DecodingTable.XXX, Encode.XXX Decode.xxx"
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


UTILS='../utils'
run_test_compare(){
    RUN_TEST="${UTILS}/run_test_compare.sh"
    
    PROBLEM_NAME="$1"
    PROGRAM_NAME="$2"
    TEST_SUB_FOLDER="$3"
    TOTAL_TEST="$4"
    
    $RUN_TEST "${PROBLEM_NAME}" "${PROGRAM_NAME}" "${TEST_SUB_FOLDER}" "${TOTAL_TEST}" "${SCRIPT_FOLDER_PATH}" "${TEST_FOLDER_PATH}" "${RESULT_DIR_NAME}" "${INTERPRETER}"
}

run_test_with_checkers(){
    RUN_TEST="${UTILS}/run_test_with_checkers.sh"
    
    PROBLEM_NAME="$1"
    PROGRAM_NAME="$2"
    TEST_SUB_FOLDER="$3"
    TOTAL_TEST="$4"
    PYTHON_TEST="$5"
    
    $RUN_TEST "${PROBLEM_NAME}" "${PROGRAM_NAME}" "${TEST_SUB_FOLDER}" "${TOTAL_TEST}" "${PYTHON_TEST}" "${SCRIPT_FOLDER_PATH}" "${TEST_FOLDER_PATH}" "${RESULT_DIR_NAME}" "${INTERPRETER}" "${TESTER_SCRIPT_FOLDER}" "${PYTHON3}"
}

run_test_compare_2args(){
    RUN_TEST="${UTILS}/run_test_compare_2args.sh"
    
    PROBLEM_NAME="$1"
    PROGRAM_NAME="$2"
    TEST_SUB_FOLDER="$3"
    TOTAL_TEST="$4"
    ARG1_FILE_EXTENSION="$5"
    ARG2_FILE_EXTENSION="$6"
    
    $RUN_TEST "${PROBLEM_NAME}" "${PROGRAM_NAME}" "${TEST_SUB_FOLDER}" "${TOTAL_TEST}" "${ARG1_FILE_EXTENSION}" "${ARG2_FILE_EXTENSION}" "${SCRIPT_FOLDER_PATH}" "${TEST_FOLDER_PATH}" "${RESULT_DIR_NAME}" "${INTERPRETER}"
}


run_test_without_compare(){
    RUN_TEST="${UTILS}/run_test_without_compare.sh"
    
    PROBLEM_NAME="$1"
    PROGRAM_NAME="$2"
    TEST_SUB_FOLDER="$3"
    TOTAL_TEST="$4"
    
    $RUN_TEST "${PROBLEM_NAME}" "${PROGRAM_NAME}" "${TEST_SUB_FOLDER}" "${TOTAL_TEST}" "${SCRIPT_FOLDER_PATH}" "${TEST_FOLDER_PATH}" "${RESULT_DIR_NAME}" "${INTERPRETER}"
}

run_test_with_2input(){
    RUN_TEST="${UTILS}/run_test_with_2input.sh"
    
    PROBLEM_NAME="$1"
    PROGRAM_NAME="$2"
    TEST_SUB_FOLDER="$3"
    TOTAL_TEST="$4"
    GENERATED_CODE_DIR_NAME="$5"
    
    $RUN_TEST "${PROBLEM_NAME}" "${PROGRAM_NAME}" "${TEST_SUB_FOLDER}" "${TOTAL_TEST}" "${GENERATED_CODE_DIR_NAME}" "${SCRIPT_FOLDER_PATH}" "${TEST_FOLDER_PATH}" "${RESULT_DIR_NAME}" "${INTERPRETER}"
}

TEST_SUB_FOLD="C"
RES_DIR=${RESULT_DIR_NAME}/${TEST_SUB_FOLD}/

PROG_NAME="DecodingTable${EXTENSION}"
SCRIPT=${SCRIPT_FOLDER_PATH}/${PROG_NAME}
FNAME=${SCRIPT%.*}
FNAME=${FNAME##*/}

GENERATED_CODE_DIR_NAME=${RES_DIR}/${FNAME}_

run_test_with_checkers "StandardForm" "StandardForm${EXTENSION}" "A" 8 "test_A.py"
run_test_with_checkers "ParityCheck" "ParityCheck${EXTENSION}" "B" 8 "test_B.py"
run_test_compare_2args "Encode" "Encode${EXTENSION}" "D" 6 "code" "dat"
run_test_without_compare "DecodingTable" "DecodingTable${EXTENSION}" "C" 6
run_test_with_2input "Decode" "Decode${EXTENSION}" "E" 6 ${GENERATED_CODE_DIR_NAME}