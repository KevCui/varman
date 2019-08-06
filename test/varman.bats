#!/usr/bin/env bats
#
# How to run:
#   ~$ bats test/varman.bats
#

BATS_TEST_SKIPPED=

setup() {
    _SCRIPT="varman.sh"
    _TEST_YAML="test/input.yaml"
    source $_SCRIPT
}

@test "CHECK: check_file() file does not exist" {
    run check_file new
    [ "$status" -eq 1 ]
    [ "$output" = "Cannot find file: new" ]
}

@test "CHECK: check_file() file exists" {
    run check_file $_TEST_YAML
    [ "$status" -eq 0 ]
}

@test "CHECK: check_args() input file null, output file null" {
    run check_args
    [ "$output" = "Input file is not set!" ]
}

@test "CHECK: check_args() input file null, output file exists" {
    _OUTPUT_FILE=$_TEST_YAML
    run check_args
    [ "$output" = "Input file is not set!" ]
}

@test "CHECK: check_args() input file null, output file doesn't exist" {
    _OUTPUT_FILE="filedosenotexist"
    run check_args
    [ "$output" = "Input file is not set!" ]
}

@test "CHECK: check_args() input file exists, output file null" {
    _INPUT_FILE=$_TEST_YAML
    run check_args
    [ "$output" = "Output file is not set!" ]
}

@test "CHECK: check_args() input file exists, output file exists" {
    _INPUT_FILE=$_TEST_YAML
    _OUTPUT_FILE=$_TEST_YAML
    run check_args
    [ "$status" -eq 0 ]
}

@test "CHECK: check_args() input file exists, output file doesn't exist" {
    _INPUT_FILE=$_TEST_YAML
    _OUTPUT_FILE="filedoesnotexist"
    run check_args
    [ "$status" -eq 0 ]
}


@test "CHECK: check_args() input file doesn't exist, output file null" {
    _INPUT_FILE="filedoesnotexist"
    run check_args
    [ "$output" = "Output file is not set!" ]
}


@test "CHECK: check_args() input file doesn't exist, output file exists" {
    _INPUT_FILE="filedoesnotexist"
    _OUTPUT_FILE=$_TEST_YAML
    run check_args
    [ "$status" -eq 0 ]
}

@test "CHECK: check_args() input file doesn't exist, output file doesn't exist" {
    _INPUT_FILE="filedoesnotexist"
    _OUTPUT_FILE="filedoesnotexist"
    run check_args
    [ "$status" -eq 0 ]
}

@test "CHECK: convert_yaml_to_var()" {
    _INPUT_FILE=$_TEST_YAML
    _PREFIX="test_"
    convert_yaml_to_var
    [ "$test_SAMPLE_NUM" = "1" ]
    [ "$test_SAMPLE_URL" = "https://example.com" ]
    [ "$test_SAMPLE_EMAIL" = "tester@test.com" ]
    [ "$test_SAMPLE_USERNAME" = "user" ]
    [ "$test_SAMPLE_PASSWORD" = "123456" ]
    [ "$test_test1" = "test1" ]
}

@test "CHECK: convert_var_to_json()" {
    _RUN_TIME=$(date)
    _SCRIPT_NAME="testscript"
    _UUID=$(uuidgen)
    _PREFIX="_VARMAN_TEST_"
    _OUTPUT_FILE="test/test.output.json"
    _VARMAN_TEST_NUM="666"
    _VARMAN_TEST_URL="https://exmaple.com"
    _VARMAN_TEST_EMAIL="tester@test.com"
    _VARMAN_TEST_USER="testuser"
    _VARMAN_TEST_PASSWORD="123456"

    rm -f $_OUTPUT_FILE
    convert_var_to_json

    _TEST_VALUES=$(compgen -A variable | grep -E "^$_PREFIX")
    _TEST_VALUE_LENGTH=$(echo "$_TEST_VALUES" | wc -l)

    [ "$(jq length $_OUTPUT_FILE)" = "7" ]
    [ "$(jq '.values | length' $_OUTPUT_FILE)" = "$_TEST_VALUE_LENGTH" ]
    [ "$(jq -r '._.postman_variable_scope' $_OUTPUT_FILE)" = "globals" ]
    [ "$(jq -r '._.postman_exported_at' $_OUTPUT_FILE)" = "$_RUN_TIME" ]
    [ "$(jq -r '._.postman_exported_using' $_OUTPUT_FILE)" = "$_SCRIPT_NAME" ]
    [ "$(jq -r '._postman_variable_scope' $_OUTPUT_FILE)" = "globals" ]
    [ "$(jq -r '._postman_exported_at' $_OUTPUT_FILE)" = "$_RUN_TIME" ]
    [ "$(jq -r '._postman_exported_using' $_OUTPUT_FILE)" = "$_SCRIPT_NAME" ]
    [ "$(jq -r '.id' $_OUTPUT_FILE)" = "$_UUID" ]
    [ "$(jq -r '.name' $_OUTPUT_FILE)" = "globals" ]
    for value in $_TEST_VALUES; do
        key=${value/$_PREFIX/}
        [ "$(jq -r '.values[] | select(.key==$key) | length' --arg key "$key" $_OUTPUT_FILE)" = "3" ]
        [ "$(jq -r '.values[] | select(.key==$key).value' --arg key "$key" $_OUTPUT_FILE)" = "${!value}" ]
        [ "$(jq -r '.values[] | select(.key==$key).type' --arg key "$key" $_OUTPUT_FILE)" = "any" ]
    done

    rm -f $_OUTPUT_FILE
}
