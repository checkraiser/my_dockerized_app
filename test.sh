#!/bin/zsh
autoload colors
colors

driver=virtualbox
node_number=3

while [ "$1" != "" ]; do
    case $1 in
        -d | --driver )         shift
                                driver=$1
                                ;;
        -n | --nodes )          shift
                                node_number=$1
    esac
    shift
done

echo "driver = $driver";
echo "node_number = $node_number";

for i in `seq 1 $node_number`; do
  echo $fg_bold[red] "\nCreate node$i machine...\n"
  echo $fg[white]
  echo 123
  echo 123
  echo $fg_bold[red] "\nRun node$i machine...\n"
  echo $fg[white]
  echo 123
  echo 123
done
