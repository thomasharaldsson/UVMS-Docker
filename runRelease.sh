#!/bin/sh
docker network create uvms
docker run -it -p 61616:61616 -p 8161:8161 --name activemq --net-alias activemq --net=uvms -v ~/uvms/activemq:/opt/jboss/activemq/data -d uvms/activemq:5.13.2
docker run -it -p 5433:5432 --name postgres --net-alias postgres --net=uvms -d uvms/postgres-release
SLEEP 180
docker run -it -p 9990:9990 -p 8787:8787 -p 8080:8080 --name wildfly --net-alias wildfly --net=uvms -m 6G -d -v ~/uvms/app/logs:/app/logs -v ~/uvms/wildfly:/opt/jboss/wildfly/standalone/log uvms/wildfly-release
