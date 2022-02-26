if [ -z "$1" ] || [ -z "$2" ]
then
        echo "The executable name and the output json name should be given"
else
        cd ../
        echo "Start reocrding.."
        uftrace record ./$1
        uftrace dump > dumped_data.txt
        mv ./dumped_data.txt ./profile/
        cd ./profile
        echo "Start parsing.."
        python3 parser.py $1 $2
	VAR1=".json"
        echo "Output the result to the json file!" 
fi
