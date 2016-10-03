# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...


# Try it:

### Create swarm cluster with 3 nodes
 `./docker-swarm-compose.sh -n 3`

### Make sure you are on master node
`docker-machine ls`
you should see something like this:

`master        * (swarm)   virtualbox   Running   tcp://192.168.99.140:2376   master (master)      v1.12.1`

notice the `* (swarm)` it means everything is ok

### Run services
`docker-compose up -d`

### Create and migrate DB
`docker-compose exec web rake db:create db:migrate`

### Scale web service
`docker-compose scale web=3`

### Check logs
`docker-compose logs -f`

### Add a few nodes to swarm cluster
`./docker-swarm-compose.sh -i 4 -n 1 -s`
`-i` means first index e.i. `-i 4 -n 3` creates `node4`, `node5`, `node6` and `node7` (4 + 3)
`-s` skip master. does not create master node - it already exists
