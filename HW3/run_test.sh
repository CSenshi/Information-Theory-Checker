# !/bin/bash

if [ "$#" -ne 0 ] && [ "$#" -ne 2 ] && [ "$#" -ne 4 ] && [ "$#" -ne 6 ] ; then
    echo "Invalid Arguments"
    echo "Usage: script requires 0-3 Arguments: "
    echo "       -e Extension of your file (pass with dot exaple: .py)"
    echo "       -i Your Interpreter (no need if using executable)"
    echo "       -py3 Your python3 Interpreter (Used to test C and D)"
    echo ""
    echo "Example: ./run_test.sh -i python3 -e .py -py3 python3"
    echo "         ./run_test.sh -e .out -py3 python3           (for executables)"
    echo "         ./run_test.sh -py3 python3                   (for executables without extensions)"
    
    exit
fi

# Read Command Line Arguments
POSITIONAL=()
while [[ $# -gt 0 ]]
do
    key="$1"
    case $key in
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

RESULT_DIR_NAME='res'
SRC_FOLDER_PATH='src'
TEST_FOLDER_PATH='Public Tests'
SCRIPT_FOLDER_PATH='script'

script/check.sh -s "${SRC_FOLDER_PATH}" -t "${TEST_FOLDER_PATH}" -r "${RESULT_DIR_NAME}" -i "${INTERPRETER}" -e "${EXTENSION}" -T "${SCRIPT_FOLDER_PATH}" -py3 "${PYTHON3}"