#! /bin/bash

# Run the scheme interpreter, load init.scm and all files on command line

# $@ all the rest arguments of a procedure
# $# number of arguments
# $1 first argument
# $2 second argument
#
#
#

trap clearfile SIGINT

clearfile()
{
    echo "; This file is loaded on startup of my scheme implementation" > init.scm
}

initialize()
{
    PROGRAMTEXT="sci"		# constants
    VERSIONTEXT="$Revision: 1.10 $"
    oHelp=h
    oInitFiles=i		# option characters
    oInitNone=in
    oInitInterpreted=ii
    oInitCompiled=ic
    oVerbose=v
    fInitFiles=i              # option arguments
    fVerbose=
    PROGRAM=$PROGRAMTEXT
    FILES=
}

usage()
{
    echo "Usage: $PROGRAM [ <option> ] ... <file.[ scm | rms ]> ..." >&2
    echo "Options:" >&2
    echo "   -$oHelp  Print this help text" >&2
    echo "   -$oInitInterpreted load interpreted (scheme) initialization files (default)" >&2
    echo "   -$oInitCompiled load compiled (regsim) initialization files" >&2
    echo "   -$oInitNone do not load any initialization files" >&2
    echo "   -$oVerbose  Print verbose information" >&2
    echo "If any of the options -$oInitNone, -$oInitInterpreted, -$oInitCompiled is used multiple times, " >&2
    echo "only the last is effective" >&2

}

collectoptions()
{
    for arg in $ARGS
    do
	case "$arg" in
	    -$oInitNone)
		fInitFiles=n
		;;
	    -$oInitInterpreted)
		fInitFiles=i
		;;
	    -$oInitCompiled)
		fInitFiles=c
		;;
	    -$oVerbose)
		fVerbose=r
		;;
	    -$oHelp)
		usage
		exit 1
		;;
	    -*)
		echo "$PROGRAM: Unknown option \"$arg\"" >&2
		usage
		exit 1
		;;
	    *)
		FILES="$FILES $arg"
		;;
	esac
    done
}

processarguments()
{
    ARGUMENTS=$@
    for FILE in $ARGUMENTS
    do
	BASENAME=`basename $FILE`
	if [ $BASENAME != `basename $BASENAME .scm` ]
	then
	    # scm files
	    echo "(load \"$FILE\")" >> init.scm
	elif [ $BASENAME != `basename $BASENAME .rms` ]
	then
	    # rms files
	    RMSFILES="$RMSFILES $FILE"
	else
	    echo "Unknown file type $FILE"
	fi
    done
}

ARGS=$*

clearfile
initialize
collectoptions

case "$fInitFiles" in
    n)
	# Do not load any initialization files
	if [ ! -z "$fVerbose" ]
	then
	    echo "Loading no initialization files"
	fi
	ALLFILES="interpreter/interpreterInit.rms $FILES interpreter/interpreterRun.rms"
    ;;
    i)
	# Use Scheme initialization files
	if [ ! -z "$fVerbose" ]
	then
	    echo "Loading interpreted initialization files"
	fi
	ALLFILES="interpreter/init.scm interpreter/interpreterInit.rms $FILES interpreter/interpreterRun.rms"
    ;;
    c)
	# Use rms initialization files
	if [ ! -z "$fVerbose" ]
	then
	    echo "Loading compiled initialization files"
	fi
	ALLFILES="interpreter/interpreterInit.rms interpreter/r5rs.rms interpreter/extra.rms $FILES interpreter/interpreterRun.rms"
	;;
    *)
	echo "Unknown init file argument $fInitFiles"
    ;;
esac

processarguments $ALLFILES

#valgrind --leak-check=yes -v ./regsim -m 100000 -l scheme rms/interpreter.rms
#valgrind --logfile-fd=9 ./regsim -m 100000 -l scheme rms/interpreter.rms 9> logfile 
#./regsim -m 100000 -l scheme rms/interpreter.rms rms/goto.rms

#VALGRIND="valgrind --leak-check=yes -v --workaround-gcc296-bugs=yes"
VALGRIND=

CMD="$VALGRIND ./regsim -m 500000 $RMSFILES"

if [ ! -z "$fVerbose" ]
then
    echo $CMD
fi

exec $CMD
