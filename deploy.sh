if [ -z "$1" ]; then
    echo "Service name required"
    exit 0
fi

docker-compose build $1

old=$(docker-compose ps -q $1)
if [ -z "$old" ]; then
    docker-compose up -d $1
    exit 0
fi

docker-compose scale $1=$(($(echo "$old" | wc -l)*2))
docker stop $old
docker rm $old
