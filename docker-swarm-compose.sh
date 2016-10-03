docker-machine create -d virtualbox mh-keystore

docker run -d \
    -p "8500:8500" \
    -h "consul" \
    progrium/consul -server -bootstrap

eval "$(docker-machine env mh-keystore)"

docker-machine create -d virtualbox \
  --swarm --swarm-master \
  --swarm-discovery="consul://$(docker-machine ip mh-keystore):8500" \
  --engine-opt="cluster-store=consul://$(docker-machine ip mh-keystore):8500" \
  --engine-opt="cluster-advertise=eth1:2376" \
  mhs-demo0

docker-machine create -d virtualbox \                                                                                                                                                               2.3.1
    --swarm \
    --swarm-discovery="consul://$(docker-machine ip mh-keystore):8500" \
    --engine-opt="cluster-store=consul://$(docker-machine ip mh-keystore):8500" \
    --engine-opt="cluster-advertise=eth1:2376" \
  mhs-demo1

docker-machine create -d virtualbox \                                                                                                                                                               2.3.1
    --swarm \
    --swarm-discovery="consul://$(docker-machine ip mh-keystore):8500" \
    --engine-opt="cluster-store=consul://$(docker-machine ip mh-keystore):8500" \
    --engine-opt="cluster-advertise=eth1:2376" \
  mhs-demo2

docker-machine create -d virtualbox \                                                                                                                                                               2.3.1
    --swarm \
    --swarm-discovery="consul://$(docker-machine ip mh-keystore):8500" \
    --engine-opt="cluster-store=consul://$(docker-machine ip mh-keystore):8500" \
    --engine-opt="cluster-advertise=eth1:2376" \
  mhs-demo3

eval "$(docker-machine env mhs-demo0)"

docker run \                                                                                                                                                                                        2.3.1
  -P \
  -d \
  -ti \
  -v nginx:/etc/conf \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v /Users/anton/Projects/sanbox/swarm-test/config/config.toml:/etc/config.toml \
  -v $DOCKER_CERT_PATH:/var/lib/boot2docker:ro \
  --network mydockerizedapp_front-tier --name interlock \
  ehazlett/interlock \
  -D run -c /etc/config.toml

docker run -ti -d --label interlock.ext.name=nginx --link=interlock:interlock --network mydockerizedapp_front-tier -v nginx:/etc/conf --name nginx nginx nginx -g "daemon off;" -c /etc/conf/nginx.conf
