# Omnistrate Supabase Proxy Example
This is a simple example to show how to leverage supabase proxy with Omnistrate platform to build serverless product.
This code is not intended for production use but can be used as reference.

## Build Example Proxy Docker Image

```
make docker-build
```


## Setup Simple Supabase Serverless With Omnistrate

**Step 1: Import Service Definition From Docker Compose**

Sample docker compose file exist in /dockercompose/supabase_demo.yaml folder

You can import the docker image using the UI using the **Import docker compose** option

![image](https://github.com/omnistrate/pg-proxy/assets/1789738/08a6257c-5877-41cb-a827-7ab23dbe537b)


The docker compose example uses two images: 
- njnjyyh/supabase-demo:custom-scaling-metrics <- supabase all in one image https://github.com/supabase/postgres/tree/develop/docker/all-in-one with custom metrics
- docker.io/njnjyyh/pg-proxy-demo:1.0 <- proxy image built from this repo

Setup Service Name to **Supabase Serverless**. Using this name is important as the following commands will reference the service with this name. 

**Step 2: Setup Supabase Instance**

In Omnistrate console access page, provision a Supabase instance 

<img width="399" alt="Screenshot 2023-11-16 at 2 54 52 PM" src="https://github.com/omnistrate/pg-proxy/assets/19898780/4a986be0-6ba9-4091-bbfa-67c159b818e9">

**Step 3: Access Supabase instance**

Once Supabase instance is up and running, check the connectivity from access page and get the endpoint/port for connection. Note that the endpoint shown in the page is pointing to the proxy and not directly to the provisioned instance. 

<img width="1626" alt="Screenshot 2023-11-16 at 3 07 26 PM" src="https://github.com/omnistrate/pg-proxy/assets/19898780/1b51d1d3-44c1-45fe-a1f2-be156fac904c">

Note that if the instance is not used for some time it will be stopped automatically. 

```
psql -U postgres -W -h <endpoint> postgres -p <port>
```

The default password for the demo is **postgres**

Once we attempt to start the connection the instance will be automatically started, it will take a few minutes for the server to start and then you can operate on the open connection.

While the connection is open the instance will be Running and after the connection is close the instance will be Stopped automatically. Auto stop in this example relies on prometheus metrics pg_stat_database_num_backends. If you want to use other metrics, please update docker compose.
