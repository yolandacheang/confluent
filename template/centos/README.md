1. docker-compose up -d --build
2. Load source connectors
```
     ./scripts/pageviews_connector
     ./scripts/users_connector
```
3. Create and Write to a Stream and Table using KSQL, also Write Queries
 ```
   docker-compose exec ksql-server ksql http://ksql-server:8088

   ksql> RUN SCRIPT '/scripts/example.sql';
```
