#!/bin/bash

cd "$(dirname "$0")" || exit 1

# Mark for Moodle trace cleanup
[ -n "$CI" ] && echo "VMCHECKER_TRACE_CLEANUP"

EXECUTABLE="../src/perfect"
TIMEOUT_DURATION=10

test_err()
{
    local temp_output=''
    temp_output="$(mktemp)"

    timeout "$TIMEOUT_DURATION" xargs -a ./input/input1 -0 -I{} bash -c "$EXECUTABLE {} > $temp_output 2>&1"

    diff -Zq "$temp_output" "./references/ref1" > /dev/null 2>&1
    return $?
}

test_single()
{
    local temp_output=''
    temp_output="$(mktemp)"

    timeout "$TIMEOUT_DURATION" xargs -a ./input/input2 -0 -I{} bash -c "$EXECUTABLE {} > $temp_output 2>&1"

    diff -Zq "$temp_output" "./references/ref2" > /dev/null 2>&1
    return $?
}

test_multiple()
{
    local temp_output=''
    temp_output="$(mktemp)"

    timeout "$TIMEOUT_DURATION" xargs -a ./input/input3 -0 -I{} bash -c "$EXECUTABLE {} > $temp_output 2>&1"

    diff -Zq "$temp_output" "./references/ref3" > /dev/null 2>&1
    return $?
}

test_edge()
{
    local temp_output=''
    temp_output="$(mktemp)"

    timeout "$TIMEOUT_DURATION" xargs -a ./input/input4 -0 -I{} bash -c "$EXECUTABLE {} > $temp_output 2>&1"

    diff -Zq "$temp_output" "./references/ref4" > /dev/null 2>&1
    return $?
}


setup()
{
    pushd ../src > /dev/null || exit 1
    make -s build
    popd > /dev/null || exit 1
}

cleanup()
{
    pushd ../src > /dev/null || exit 1
    make -s clean
    popd > /dev/null || exit 1
}

test_fun_array=(                        \
	test_err            "Name 1"    5   \
	test_single         "Name 2"    5   \
	test_multiple       "Name 3"    5   \
	test_edge           "Name 4"    5   \
)

test_all()
{
    local score=0

    for i in $(seq 0 "$((${#test_fun_array[@]} / 3 - 1))") ; do
        test_index=$((i * 3))
        description=${test_fun_array[$((test_index + 1))]}
        points=${test_fun_array[$((test_index + 2))]}


        echo -e "Testing\t\t$description"
        if ${test_fun_array["$test_index"]} ; then
            score=$((score + points))
        fi
    done

    echo -e "\nTotal: $score"
}

setup
test_all
cleanup
