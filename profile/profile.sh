if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ]
then
    echo "Arguments: [executable file] [output JSON file] [runtime(async_std/tokio)] [get location(optional)]"
else
        cd ../
        echo "Start reocrding.."
        if [ "$3" = "async_std" ]
        then
            uftrace record -P "_<async_std..task..builder..SupportTaskLocals<F> as core..future..future..Future>::poll::_{{closure}}" -P "_<core..future..from_generator..GenFuture<T> as core..future..future..Future>::poll" -P ".*::_\{\{closure\}\}" -P ".*as core..future..future..Future>::poll" $1
        elif [ "$3" = "tokio" ]
        then
            uftrace record -P "tokio..runtime..blocking..task..BlockingTask<T> as core..future..future..Future" -P "tokio::runtime::task::core::CoreStage<T>::poll" -P "_<core..future..from_generator..GenFuture<T> as core..future..future..Future>::poll" -P ".*::_\{\{closure\}\}" -P ".*as core..future..future..Future>::poll" $1
        fi
        uftrace dump > dumped_data.txt
        mv ./dumped_data.txt ./profile/
        cd ./profile
        echo "Start parsing.."
        if [ "$3" = "async_std" ]
        then
            if [ "$4" = "--get-location" ]
            then
               python3 parser.py $1 $2 --get-location
            else
               python3 parser.py $1 $2
            fi
        elif [ "$3" = "tokio" ]
        then
            if [ "$4" = "--get-location" ]
            then
               python3 parser_tokio.py $1 $2 --get-location
            else
               python3 parser_tokio.py $1 $2
            fi
        else
            echo "Wrong arguments."
        fi
        echo "Output the result to the json file!"
        rm ./dumped_data.txt  
fi
