if [ -z "$1" ] || [ -z "$2" ]
then
        echo "The executable name and the output json name should be given"
else
        cd ../
        echo "Start reocrding.."
        uftrace record -P "_<async_std..task..builder..SupportTaskLocals<F> as core..future..future..Future>::poll::_{{closure}}" -P "_<core..future..from_generator..GenFuture<T> as core..future..future..Future>::poll" -P ".*::_\{\{closure\}\}" -P ".*as core..future..future..Future>::poll" $1
        uftrace dump > dumped_data.txt
        mv ./dumped_data.txt ./profile/
        cd ./profile
        echo "Start parsing.."
        if [ "$3" = "--generated-future" ]
        then
            echo "(Tracing compiler-generated futures only)" 
            python3 parser_nu.py $1 $2
        elif [ "$3" = "--get-location" ]
        then
            echo "(Tracing all futures, get locations for futures)"
            python3 parser.py $1 $2 --get-location
        elif ([ "$3" = "--generated-future" ] && [ "$4" = "--get-location" ]) || ([ "$3" = "--get-location" ] && [ "$4" = "--generated-future" ] )
        then
            echo "(Tracing compiler-generated futures only, get locations for futures)"
            python3 parser_nu.py $1 $2 --get-location
        else
            python3 parser.py $1 $2
        fi
        echo "Output the result to the json file!"
        rm ./dumped_data.txt  
fi
