#!/usr/bin/env bash
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <input_dir3> <input_dir4> <output_dir6>"
    exit 1
fi

INPUT_DIR3="$1"
INPUT_DIR4="$2"
OUTPUT_DIR6="$3"

if ! hdfs dfs -test -d "$INPUT_DIR3"; then
    echo "Error: Input directory not found in HDFS: $INPUT_DIR3"
    exit 1
fi

if ! hdfs dfs -test -d "$INPUT_DIR4"; then
    echo "Error: Input directory not found in HDFS: $INPUT_DIR4"
    exit 1
fi

hdfs dfs -rm -r -f "$OUTPUT_DIR6"

beeline -u "jdbc:hive2://localhost:10000" -n hadoop \
  --hivevar input_dir3="$INPUT_DIR3" \
  --hivevar input_dir4="$INPUT_DIR4" \
  --hivevar output_dir6="$OUTPUT_DIR6" \
  -f "$DIR/hive.hql"