#!/bin/bash

all_pass=0

for n in 1 2 3 4; do
    dir="Testcase$n"
    out="${dir}Diff"
    failed=0
    has_diff=0

    for first in "$dir"/*.1.txt; do
        [ -f "$first" ] || continue

        second="${first%.1.txt}.2.txt"
        name="${first##*/}"
        name="${name%.1.txt}"
        result="$out/${name}Diff.txt"

        if [ ! -f "$second" ]; then
            failed=1
        elif cmp -s "$first" "$second"; then
            [ -e "$result" ] && failed=1
        else
            has_diff=1

            if [ ! -f "$result" ] || ! cmp -s \
                <(diff -u "$first" "$second" | tail -n +3) \
                <(tail -n +3 "$result"); then
                failed=1
            fi
        fi
    done

    if [ "$has_diff" -eq 0 ]; then
        [ -e "$out" ] && failed=1
    else
        [ -d "$out" ] || failed=1

        for file in "$out"/*; do
            [ -e "$file" ] || continue

            name="${file##*/}"
            base="${name%Diff.txt}"

            if [ "$base" = "$name" ] || [ ! -f "$dir/${base}.1.txt" ] || [ ! -f "$dir/${base}.2.txt" ]; then
                failed=1
            fi
        done
    fi

    if [ "$failed" -eq 0 ]; then
        echo "Testcase$n: PASS"
    else
        echo "Testcase$n: FAIL"
        all_pass=1
    fi
done

exit "$all_pass"