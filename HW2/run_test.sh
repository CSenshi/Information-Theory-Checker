# !/bin/bash

if [ "$#" -ne 0 ] && [ "$#" -ne 2 ] && [ "$#" -ne 4 ] ; then
    echo "Invalid Arguments"
    echo "Usage: script requires 0-2 Arguments: "
    echo "       -e Extension of your file (pass with dot exaple: .py)"
    echo "       -i Your Interpreter (no need if using executable)"
    echo ""
    echo "Example: ./run_test.sh -i python3 -e .py"
    echo "         ./run_test.sh -e .out           (for executables)"
    echo "         ./run_test.sh                   (for executables without extensions)"
    
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
        *)    # unknown option
            POSITIONAL+=("$1") # save it in an array for later
            shift # past argument
        ;;
    esac
done
set -- "${POSITIONAL[@]}" # restore positional parameters

RESULT_DIR_NAME=res
SRC_FOLDER_PATH=src
TEST_FOLDER_PATH='Public Tests'

script/check.sh -s "${SRC_FOLDER_PATH}" -t "${TEST_FOLDER_PATH}" -r "${RESULT_DIR_NAME}" -i "${INTERPRETER}" -e "${EXTENSION}"
