#!/bin/zsh
autoload colors
colors

driver=digitalocean
node_number=3
keystore=keystore
skip_master="0"
index=1

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

let "to = $index + $node_number"

if [ $skip_master != "0" ]; then
  echo "Skipping master and keystore";
  eval "$(docker-machine env --swarm master)"
else
  echo $fg_bold[red] "\nCreate keystore machine...\n"
  echo $fg[white]
  docker-machine create -d $driver --digitalocean-access-token $DIGITALOCEAN_ACCESS_TOKEN $keystore

  eval "$(docker-machine env $keystore)"

  echo $fg_bold[red] "\nRun consul key/value store on $keystore machine...\n"
  echo $fg[white]

  docker run -d \
      -p "8500:8500" \
      -h "consul" \
      progrium/consul -server -bootstrap

  echo $fg_bold[red] "\nCreate swarm master machine...\n"
  echo $fg[white]

  docker-machine create -d $driver --digitalocean-access-token $DIGITALOCEAN_ACCESS_TOKEN \
    --swarm --swarm-master \
    --swarm-discovery="consul://$(docker-machine ip $keystore):8500" \
    --engine-opt="cluster-store=consul://$(docker-machine ip $keystore):8500" \
    --engine-opt="cluster-advertise=eth0:2376" \
    master
fi

for i in `seq $index $to`; do
  echo $fg_bold[red] "\nCreate node$i machine...\n"
  echo $fg[white]
  docker-machine create -d $driver --digitalocean-access-token $DIGITALOCEAN_ACCESS_TOKEN --swarm \
    --swarm-discovery="consul://$(docker-machine ip $keystore):8500" \
    --engine-opt="cluster-store=consul://$(docker-machine ip $keystore):8500" \
    --engine-opt="cluster-advertise=eth0:2376" \
    node$i
done

eval "$(docker-machine env --swarm master)"
