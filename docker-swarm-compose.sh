driver=virtualbox
keystore=keystore

while [ "$1" != "" ]; do
    case $1 in
        -d | --driver )         shift
                                driver=$1
                                ;;
        * )                     usage
                                exit 1
    esac
    shift
done

echo docker-machine create -d $driver $keystore
docker-machine create -d $driver $keystore

docker run -d \
    -p "8500:8500" \
    -h "consul" \
    progrium/consul -server -bootstrap

eval "$(docker-machine env $keystore)"

docker-machine create -d $driver \
  --swarm --swarm-master \
  --swarm-discovery="consul://$(docker-machine ip $keystore):8500" \
  --engine-opt="cluster-store=consul://$(docker-machine ip $keystore):8500" \
  --engine-opt="cluster-advertise=eth1:2376" \
  master

docker-machine create -d virtualbox \                                                                                                                                                               2.3.1
    --swarm \
    --swarm-discovery="consul://$(docker-machine ip $keystore):8500" \
    --engine-opt="cluster-store=consul://$(docker-machine ip $keystore):8500" \
    --engine-opt="cluster-advertise=eth1:2376" \
  node1

docker-machine create -d virtualbox \                                                                                                                                                               2.3.1
    --swarm \
    --swarm-discovery="consul://$(docker-machine ip $keystore):8500" \
    --engine-opt="cluster-store=consul://$(docker-machine ip $keystore):8500" \
    --engine-opt="cluster-advertise=eth1:2376" \
  node2

docker-machine create -d virtualbox \                                                                                                                                                               2.3.1
    --swarm \
    --swarm-discovery="consul://$(docker-machine ip $keystore):8500" \
    --engine-opt="cluster-store=consul://$(docker-machine ip $keystore):8500" \
    --engine-opt="cluster-advertise=eth1:2376" \
  node3

eval "$(docker-machine env master)"
