#!/usr/bin/env bash

if [[ ${#@} -lt 1 ]]; then
   echo "Usage: java_run MainClass [args...]"
   exit 1
fi

main_class=$1
args=${@:2}

echo -ne "Compiling...\r"
compile_output=$(javac -d bin $(find . -name '*.java') 2>&1)

if [[ $? -ne 0 ]]; then
   rm -f *java.log
   printf '%s\n' "$compile_output" > "$(date +'%m-%d_%H-%M-%S')_java.log"
   echo -n "Compilation failed, check the log file."
   exit 1
fi

class_file=$(find bin -name "$main_class.class" | sed 's|^bin/||;s|/|.|g;s|\.class$||')

if [[ -z $class_file ]]; then
    echo -n "Error: Could not find class '$main_class'."
    exit 1
fi

echo -ne "            \r"
java -cp bin "$class_file" $args

