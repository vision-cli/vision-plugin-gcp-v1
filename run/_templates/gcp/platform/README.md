# Cloud Infrastructure

## Deployed Infrastructure

The platform consists of:

- Terraform code to deploy the following infra components

```
   |-----------------------------------------------------|
   |                  Https Load Balancer                |     // Https ingress to the platform
   |-----------------------------------------------------|
         |                              |
         |                 |------------------------|
         |                 |  Identity Aware Proxy  |          // Authentication proxy
         |                 |------------------------|
         |                              |
         |           |----------| |----------| |----------|
         |           |   NEG    | |    NEG   | |    NEG   |     // Network endpoint groups for cloud run containers
         |           |----------| |----------| |----------|
         |                 |            |            |
   |----------|      |----------| |----------| |----------|
   | cloud    |      | cloud    | | cloud    | | cloud    |
   | run      |      | run      | | run      | | run      |    // Cloud functions for platform services
   | gcs-proxy|      | gcs-proxy| | graphql  | | (various)|    // Only egress to VPN
   |----------|      |----------| |----------| |----------|
         |                     |                 |
  |-------------|       |-------------|   |-------------|    |---------|
  |   Storage   |       |   Storage   |   |   private   |----| Jumpbox |  // VPN jumpbox
  |   (public)  |       |  (private)  |   |   network   |    |---------|
  |-------------|       |-------------|   |-------------|----VPC peering  // VPC peering IP
                                                 |
                                          |-------------|
                                          |   Database  |
                                          |  (private)  |
                                          |-------------|

```

## Remote access

Use the jumpbox to access the private network and componets attached to the network e.g. database

The best way to connect is using the gcloud cli. Find the jumpbox in the console and cut-and-paste the connection command. It will be something like

```
gcloud compute ssh --zone "europe-west2-c" "jumpbox" --project "<your project name>"
```

You should install the postgres tools with

```
sudo apt-get update && sudo apt-get install postgresql
```

Connect to the database with

```
psql -h INSTANCE_IP -U USERNAME DATABASE
```

for example

```
psql -h 10.x.x.x -U dbuser defaultdb
```
