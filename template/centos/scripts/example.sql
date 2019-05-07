CREATE STREAM pageviews 
      (viewtime BIGINT, 
       userid VARCHAR, 
       pageid VARCHAR) 
      WITH (KAFKA_TOPIC='pageviews', 
            VALUE_FORMAT='AVRO');
CREATE TABLE users 
      (registertime BIGINT, 
       gender VARCHAR, 
       regionid VARCHAR, 
       userid VARCHAR, 
       interests array<VARCHAR>, 
       contactinfo map<VARCHAR, VARCHAR>) 
      WITH (KAFKA_TOPIC='users', 
            VALUE_FORMAT='AVRO', 
            KEY = 'userid');
CREATE STREAM pageviews_female AS SELECT users.userid AS userid, pageid, regionid, gender FROM pageviews LEFT JOIN users ON pageviews.userid = users.userid WHERE gender = 'FEMALE';

CREATE STREAM pageviews_female_like_89 WITH (kafka_topic='pageviews_enriched_r8_r9', value_format='AVRO') AS SELECT * FROM pageviews_female WHERE regionid LIKE '%_8' OR regionid LIKE '%_9';

CREATE TABLE pageviews_regions AS SELECT gender, regionid , COUNT(*) AS numusers FROM pageviews_female WINDOW TUMBLING (size 30 second) GROUP BY gender, regionid HAVING COUNT(*) > 1;


