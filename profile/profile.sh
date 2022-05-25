if [ -z "$1" ] || [ -z "$2" ]
then
        echo "The executable name and the output json name should be given"
else
        cd ../
        echo "Start reocrding.."
        uftrace record -F "_<async_std..task..builder..SupportTaskLocals<F> as core..future..future..Future>::poll::_{{closure}}" -N "core::ptr.*" -N "core::alloc.*" -N "core::mem.*" -N "core::sync.*" -N "core::str.*" -N "core::iter.*" -N "alloc.*" -N "core::slice.* " -N "core::core_arch.*" -N "core::pin.*" -N "core::cmp.*" $1 
        uftrace dump > dumped_data.txt
        mv ./dumped_data.txt ./profile/
        cd ./profile
        echo "Start parsing.."
        python3 parser_nu.py $1 $2
        echo "Output the result to the json file!"
        rm ./dumped_data.txt  
fi
