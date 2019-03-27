#!/usr/bin/env bash
#
# This script generates postman/newman global variables json from yaml file
#
#/ Usage:
#/   ./varman.sh -i <input.yaml> -o <output.json>
#/
#/ Options
#/   -i:            Input yaml file
#/   -o:            Output json file
#/   -h --help:     Display this help message

usage() {
    # Display usage message
    grep '^#/' "$0" | cut -c4-
    exit 0
}

set_var() {
    # Declare variables used in script
    _PREFIX="VARMAN_"
    _SCRIPT_NAME=$(basename "$0")
    _RUN_TIME=$(date "+%Y-%m-%dT%H:%M:%S.%3NZ")
    _UUID=$(uuidgen)
}

get_args() {
    # Declare arguments
    expr "$*" : ".*--help" > /dev/null && usage
    while getopts ":hi:o:" opt; do
        case $opt in
            i)
                _INPUT_FILE="$OPTARG"
                ;;
            o)
                _OUTPUT_FILE="$OPTARG"
                ;;
            h)
                usage
                ;;
            \?)
                echo "Invalid option: -$OPTARG" >&2
                usage
                ;;
        esac
    done
    check_args
    check_file "$_INPUT_FILE"
}

check_file() {
    # Check file if it exists
    if [[ ! -f "$1" ]]; then
        echo "Cannot find file: $1"
        exit 1
    fi
}

check_args() {
    # Check input and output file names
    if [[ -z "$_INPUT_FILE" ]]; then
        echo "Input file is not set!"
        usage
        exit 1
    fi
    if [[ -z "$_OUTPUT_FILE" ]]; then
        echo "Output file is not set!"
        usage
        exit 1
    fi
}

convert_ymal_to_var() {
    # Declare variables from ymal file
    while IFS= read -r line; do
        eval "$line"
    done < <(sed \
    -e '/^\s*$/d' \
    -e '/^#/d' \
    -e 's/^[ \t]*//' \
    -e 's/[ \t]*$//' \
    -e '/:$/d' \
    -e "s/:[^:\/\/]/='/g" \
    -e "s/$/'/g" \
    -e 's/ *=/=/g' \
    -e "s/^/$_PREFIX/g" "$_INPUT_FILE")
}

convert_var_to_json() {
    # Convert variables to json file
    string='{
  "_": {
    "postman_variable_scope": "globals",
    "postman_exported_at": "'$_RUN_TIME'",
    "postman_exported_using": "'$_SCRIPT_NAME'"
  },
  "_postman_variable_scope": "globals",
  "_postman_exported_at": "'$_RUN_TIME'",
  "_postman_exported_using": "'$_SCRIPT_NAME'",
  "id": "'$_UUID'",
  "name": "globals",
  "values": ['

    for var in $(compgen -A variable | grep -E "^$_PREFIX"); do
        string=$string'
    {
      "type": "any",
      "value": "'${!var}'",
      "key": "'${var/$_PREFIX/}'"
    },'
    done

    string=${string:0:$((${#string} - 1))}'
  ]
}'
    echo "$string" > "$_OUTPUT_FILE"
}

main() {
    get_args "$@"
    set_var
    convert_ymal_to_var
    convert_var_to_json
}

main "$@"
