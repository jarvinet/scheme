#! /bin/bash

# Run the register machine simulator

if [ $# -ne 1 ]
then
    # print usage to stderr, $0 = the name of the script
    echo "Usage: $0 file.rms" >&2
    echo "       where file.rms is the register machine simulator file to run" >&2

    exit
fi

./regsim $1
