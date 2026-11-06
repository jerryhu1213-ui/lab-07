
#!/bin/bash

for number in 1 2 3 4
do
    input_dir="Testcase${number}"
    output_dir="Testcase${number}Diff"

    rm -rf "$output_dir"

    for file1 in "$input_dir"/*.1.txt
    do
        if [ ! -f "$file1" ]; then
            continue
        fi

        file2="${file1%.1.txt}.2.txt"

        if [ ! -f "$file2" ]; then
            continue
        fi

        diff -u "$file1" "$file2" > /dev/null
        result=$?

        if [ "$result" -eq 1 ]; then
            filename="${file1##*/}"
            version="${filename%.1.txt}"

            mkdir -p "$output_dir"

            diff -u "$file1" "$file2" > "$output_dir/${version}Diff.txt"
        fi
    done
done
