#! /bin/bash

# Run the scheme interpreter, compile file on command line

# trap clearfile SIGINT

clearfile()
{
    echo "; This file is loaded on startup of my scheme implementation" > init.scm
}

splitfilename() # make FILESTEM and SUFFIX
{
    #
    # If the filename has a dot ('.'), the filestem is the part of
    # filename that precedes the LAST dot excluding the dot. The
    # suffix is the rest of the filename including the dot. If the
    # filename does not have a dot, the filestem is the filename and
    # the suffix is empty.
    #
    if [ ! -z "$INFILE" ]
    then
	FILESTEM=`echo "$INFILE" | sed "s/^\(.*\)\.[^\.]*$/\1/1"`
	if [ "$FILESTEM" = "$INFILE" ]
	then
	    SUFFIX=
	else
	    SUFFIX=`echo "$INFILE" | sed "s/^.*\(\.[^\.]*\)$/\1/1"`
	fi
    else
	FILESTEM=
	SUFFIX=
    fi
}

if [ $# -eq 0 ]
then
    # print usage to stderr, $0 = the name of the script
    echo "Compile Scheme files (.scm) to register machine simulator files (.rms)" >&2
    echo "Usage: $0 infile.scm outfile.rms" >&2
    echo "       where infile.scm is the source scheme file" >&2
    echo "             outfile.rms is the target regsim file" >&2

    exit
fi

INFILE=$1
if [ "$2" ]
then
    OUTFILE="$2"
else
    splitfilename
    OUTFILE="$FILESTEM.rms"
fi
TEMPFILE="$OUTFILE.tmp"

echo "infile $INFILE"
echo "outfile $OUTFILE"
echo "tempfile $TEMPFILE"

clearfile

echo "(define input-file-name \"$INFILE\")" > compiler/file-to-compile.scm
echo "(define output-file-name \"$TEMPFILE\")" >> compiler/file-to-compile.scm

if [ 1 -eq 2 ]
then
    echo "Interpreted Compiler"
    ./sci.sh -ii \
	"compiler/file-to-compile.scm \
	compiler/ch5-syntax.scm \
	compiler/ch5-compiler.scm \
	compiler/compiler.scm"
else
    echo "Compiled Compiler"
    ./sci.sh -ic \
	"compiler/file-to-compile.scm \
         compiler/ch5-syntax.rms \
	 compiler/ch5-compiler.rms \
	 compiler/compiler.scm"
fi

# Pretty-print the tempfile, put result in outfile
./regsim -p $TEMPFILE > $OUTFILE

rm $TEMPFILE
