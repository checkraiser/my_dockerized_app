#!/bin/zsh
autoload colors
colors

driver=virtualbox
node_number=3
skip_master=0
index=1
let "to = $index + $node_number"

while [ "$1" != "" ]; do
    case $1 in
        -d | --driver )         shift
                                driver=$1
                                ;;
        -n | --nodes )          shift
                                node_number=$1
                                ;;
        -i | --index )          shift
                                index=$1
                                ;;
        -s | --skip-master )    skip_master=1
    esac
    shift
done

echo "driver = $driver";
echo "node_number = $node_number";
echo "skip_master = $skip_master";


if [ $skip_master != "0" ]; then
  echo "TRUE";
else
  echo "FALSE";
fi

for i in `seq $index (($index + $node_number))`; do
  echo $fg_bold[red] "\nCreate node$i machine...\n"
  echo $fg[white]
  echo 123
  echo 123
  echo $fg_bold[red] "\nRun node$i machine...\n"
  echo $fg[white]
  echo 123
  echo 123
done
