

A simple S3 connector setup



1. You need to create a s3 bucket with your AWS account
  https://docs.aws.amazon.com/quickstarts/latest/s3backup/step-1-create-bucket.html

2. Set up your credential file for the user which is running the connect process
   
   ~/.aws/credentials

   https://docs.aws.amazon.com/sdk-for-java/v1/developer-guide/credentials.html#credentials-file-format


3. Create the replicator connector:

```
$docker-compose exec connect bash
root@connect:/#/scripts/connector
```

4. Check the status of the connector

```
root@connect:/# curl -X GET http://localhost:8082/connectors/s3-sink/status
{"name":"s3-sink","connector":{"state":"RUNNING","worker_id":"localhost:8082"},"tasks":[{"state":"RUNNING","id":0,"worker_id":"localhost:8082"}],"type":"sink"}
```

