# !/bin/bash

if [ "$#" -ne 10 ] && [ "$#" -ne 8 ] && [ "$#" -ne 6 ] ; then
    echo "Invalid Arguments"
    echo "Usage: script requires 3-5 Arguments: "
    echo "       -s Path to folder which contains following scripts with exact names:"
    echo "                      ParityCheck.py Encode.py Decode.py MinimalPolynomial.py BCH.py"
    echo "       -t Path to folder which contains public tests(where A,B,C,D folders are located)"
    echo "       -r Path to folder where we should put output for each test"
    echo "       -e Extension of your file (pass with dot exaple: .py)"
    echo "       -i Your Interpreter (no need if using executable)"
    echo "Example: ./check.sh -s src -t public_tests -r result -i python3 -e .py"
    
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



run_test_compare(){
    UTILS='../utils'
    RUN_TEST="${UTILS}/run_test_compare.sh"
    
    PROBLEM_NAME="$1"
    PROGRAM_NAME="$2"
    TEST_SUB_FOLDER="$3"
    TOTAL_TEST="$4"
    
    $RUN_TEST "${PROBLEM_NAME}" "${PROGRAM_NAME}" "${TEST_SUB_FOLDER}" "${TOTAL_TEST}" "${SCRIPT_FOLDER_PATH}" "${TEST_FOLDER_PATH}" "${RESULT_DIR_NAME}" "${INTERPRETER}"
}

run_test_compare "Parity Check" "ParityCheck${EXTENSION}" "A" 6
run_test_compare "Encode" "Encode${EXTENSION}" "B" 5
run_test_compare "Decode" "Decode${EXTENSION}" "C" 10
run_test_compare "Minimal Polynomial" "MinimalPolynomial${EXTENSION}" "D" 10
run_test_compare "BCH" "BCH${EXTENSION}" "D" 10