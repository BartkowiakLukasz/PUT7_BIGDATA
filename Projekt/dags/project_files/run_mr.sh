#!/usr/bin/env bash

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ "$#" -ne 2 ]; then
    echo "Error: Requires 2 arguments"
    echo "Usage: $0 <hdfs_input_dir> <hdfs_output_dir>"
    exit 1
fi

INPUT_DIR="$1"
OUTPUT_DIR="$2"

if ! hdfs dfs -test -e "$INPUT_DIR"; then
    echo "Error: Input directory not found in HDFS: $INPUT_DIR" >&2
    exit 1
fi

if hdfs dfs -test -d "$OUTPUT_DIR"; then
    hdfs dfs -rm -r -f "$OUTPUT_DIR"
fi


mapred streaming \
-files $DIR/mapper.py,$DIR/combiner.py,$DIR/reducer.py \
-input "$INPUT_DIR" \
-output "$OUTPUT_DIR" \
-mapper "python3 mapper.py" \
-combiner "python3 combiner.py" \
-reducer "python3 reducer.py"

