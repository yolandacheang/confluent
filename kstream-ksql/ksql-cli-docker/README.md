1. Start docker compose environment
```
docker-compose up -d 
```

2. Find out network the environment is running on
```
#docker network ls
NETWORK ID          NAME                      DRIVER              SCOPE
8fa40fb7f5f4        ksql-cli-docker_default   bridge              local
```

3. Start ksql-cli container on this network
```
docker run --network ksql-cli-docker_default -it -v $PWD/secrets:/etc/ksql/secrets confluentinc/cp-ksql-cli:5.3.1 https://ksql-server:8088 --config-file /etc/ksql/secrets/ksql-cli.properties
```
