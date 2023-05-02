# pinpayments-challenge

Deployment and documentation of a simple website.

- Deployed website URL: https://srechallenge.online
- Deployed alternate environment: https://alternate.srechallenge.online
- Deployed cloudfront URL: https://d318mzutsp2tq6.cloudfront.net
- Status/monitoring: https://status.srechallenge.online/
- Status/monitoring for internal services: https://internal-status.srechallenge.online/
  - (The internal page would not normally be public, but the free version doesn't support password protecting pages).

![draw io_SwkvProLf9](https://user-images.githubusercontent.com/16591081/235646169-501c3aab-df6b-4ed3-806c-d33fded16c5b.gif)

### Challenge Requirements

- [x] build simple website with text & image
- [x] deploy in AWS
- [x] upload to public Github repo
- [x] Provide documentation for running locally
- [x] Set up monitoring and alerting
  - https://status.srechallenge.online/
  - https://internal-status.srechallenge.online/ (would not normally be public, but the free version doesn't support password protecting pages).
- [x] Add logging
  - I plan to add logging from the container to either Papertrail, Datadog or Coralogix.
  - My main goal is observability as to which containers are being hit to see if loadbalancing and scaling are working as expected.
  - Normally with docker compose or docker swarm, this would be simple to do but ECS has its own requirements.
  - So options are:
    - log from inside the container (there are a copule of methods I can think of for doing this)
    - use AWS tools and configuation to ship logs out to our chosen 3rd party service
    - Such as: https://docs.datadoghq.com/integrations/ecs_fargate/?tab=awscli
    - Or: https://www.papertrail.com/help/amazon-ecs/
  - I ended up adding logging into the container itself. Logs get sent to Papertrail. See screenshots below.
- [x] Provide a mechanism for scaling the service [WIP]
  - Cloudfront/S3 are inherently scalable with no further action required.
  - However since the exercise appears to require it, I am going to add an alternative deployment method that can be manually scaled.
  - I have chosen a container deployed on ECS, with an elastic load balancer in front. Cloudflare is also in front of that.
- [x] Provide documentation for scaling up (See below)
- [x] Add automation
  - Github actions will run and deploy on pushes to `main`
  - I have only implemented simple pipeline automation here because I'm not so familiar with Github, my experience is primarily with Gitlab.
- [x] Provide network diagrams
- [x] Make it reasonably secure [WIP]
  - [x] content is served from Cloudfront to hide the S3 bucket origin
  - [ ] make bucket private [PLANNED]
- [x] Use modern standards
  - Using a pipeline deployment (Github actions) for automation and better maintainability
  - Using IaC rather than manual configuration is considered a modern standard.
- [x] Use modern practices in AWS
  - I chose a combination of S3 with something in front (CDN/API Gateway/WAF) which is one of the best ways of hosting a static website currently.

## To run website locally

There are a few options.

### Python

#### Python 3

```bash
cd ./simplewebsite
python3 -m http.server
```

#### Python 2

```bash
cd ./simplewebsite
python -m SimpleHTTPServer
```

Then go to http://localhost:PORT. Get the port from the output.

Example output:

```log
james@SHAKURAS:~/git/james/pinpayments-challenge/simplewebsite$ python -m SimpleHTTPServer
Serving HTTP on 0.0.0.0 port 8000 ...
127.0.0.1 - - [30/Apr/2023 21:41:05] "GET / HTTP/1.1" 200 -
127.0.0.1 - - [30/Apr/2023 21:41:05] "GET /assets/style.css HTTP/1.1" 200 -
127.0.0.1 - - [30/Apr/2023 21:41:05] "GET /assets/main.js HTTP/1.1" 200 -
127.0.0.1 - - [30/Apr/2023 21:41:05] "GET /assets/perth-koondoola-evening.jpg HTTP/1.1" 200 -
```

### Docker

If you don't have Python installed locally, this is a good option (assuming you have Docker). Unfortunately it doesn't printout the initial text showing what port, but it should always be `http://localhost:8000`.

#### Docker Compose

`docker compose up` (CTRL+C to stop), add `-d` to run in the background. `docker compose down` to stop and/or delete the container.

Example output:

```log
james@SHAKURAS:~/git/james/pinpayments-challenge$ docker compose up
[+] Running 1/1
 ⠿ Container pinpayments-challenge-python-1  Recreated                                                                                                                                                                                                                       0.1s
Attaching to pinpayments-challenge-python-1
pinpayments-challenge-python-1  | 172.18.0.1 - - [30/Apr/2023 13:57:21] "GET / HTTP/1.1" 304 -
pinpayments-challenge-python-1  | 172.18.0.1 - - [30/Apr/2023 13:57:21] "GET /assets/style.css HTTP/1.1" 304 -
pinpayments-challenge-python-1  | 172.18.0.1 - - [30/Apr/2023 13:57:21] "GET /assets/main.js HTTP/1.1" 304 -
pinpayments-challenge-python-1  | 172.18.0.1 - - [30/Apr/2023 13:57:21] "GET /assets/perth-koondoola-evening.jpg HTTP/1.1" 304 -
```

#### Docker

```bash
cd ./simplewebsite
docker build . -t simpleweb
docker run -p 8000:8000 simpleweb # -d optional
```

# Deployment

The site can be deployed from a local terminal (Pulumi is required).

It can also be deployed by a merge into the `production` branch of the Github repo.

## Local Deployment

1. Install pulumi
2. Ensure AWS credentials are present in `./aws/credentials`
3. Ensure Cloudflare API token is present (`export CLOUDFLARE_API_TOKEN=xxx`)
4. Run `pulumi stack select dev` or `pulumi stack select production` depending on requirements
5. Run `pulumi preview` (optionally, with `--diff`)
6. Run `pulumi up`

Pulumi will output various values of interest. Such as

```log
Outputs:
    altURL        : "https://alternate.srechallenge.online"
    cdnHostname   : "d318******tq6.cloudfront.net"
    cdnURL        : "https://d318******tq6.cloudfront.net"
    lbUrl         : "http://lb-******-1578047453.ap-southeast-2.elb.amazonaws.com"
    originHostname: "bucket-****.s3-website-ap-southeast-2.amazonaws.com"
    originURL     : "http://bucket-****.s3-website-ap-southeast-2.amazonaws.com"
    publicURL     : "https://srechallenge.online"
```

## Automated Deployment

1. Make changes (either to infrastructure, or the website code)
2. Commit to git and push to `main` on this Github repository.
3. The changes will be deployed automatically.

# Scaling

The alternate method using ECS, Fargate and ELB can be scaled by increasing the memory/cpu on the containers, or increasing the `desiredCount` of the service.

![draw io_PaIyFt7Amk](https://user-images.githubusercontent.com/16591081/235678557-0e499390-bdd9-4a57-86ce-815e1ef1aa2e.gif)

## Steps for scaling

1. In `Pulumi.yaml`, find `desiredCount` and increase as required.

OR

1. In `Pulumi.yaml`, find `cpu:` and `memory:` and increase as desired. This will cause Fargate to reprovision on higher spec instances.

> Note: this is not really required for the current use case since Cloudflare & Cloudfront caching will handle any kind of increase in load.

```yaml
service:
  type: awsx:ecs:FargateService
  properties:
    cluster: ${cluster.arn}
    assignPublicIp: true
    desiredCount: 4 # <<<<
    taskDefinitionArgs:
      container:
        image: ${image.imageUri}
        cpu: 512 # <<<<
        memory: 128 # <<<<
```

## Logging

Logging is to papertrail. It happens from inside the container.

Example:

```log
May 02 23:00:21 f247fca9c11c web.log 172.17.0.1 - - [02/May/2023 15:00:20] "GET / HTTP/1.1" 304 -
May 02 23:03:11 745851fab700 web.log 172.17.0.1 - - [02/May/2023 15:03:10] "GET / HTTP/1.1" 200 -
May 02 23:03:11 745851fab700 web.log 172.17.0.1 - - [02/May/2023 15:03:10] "GET /assets/main.js HTTP/1.1" 200 -
May 02 23:03:11 745851fab700 web.log 172.17.0.1 - - [02/May/2023 15:03:10] "GET /assets/style.css HTTP/1.1" 200 -
May 02 23:03:11 745851fab700 web.log 172.17.0.1 - - [02/May/2023 15:03:10] "GET /assets/perth-koondoola-evening.jpg HTTP/1.1" 200 -
May 02 23:03:11 745851fab700 web.log 172.17.0.1 - - [02/May/2023 15:03:10] "GET /favicon.ico HTTP/1.1" 200 -
May 02 23:03:12 745851fab700 web.log 172.17.0.1 - - [02/May/2023 15:03:11] "GET / HTTP/1.1" 304 -
May 02 23:03:18 745851fab700 web.log 172.17.0.1 - - [02/May/2023 15:03:18] "GET / HTTP/1.1" 304 -
May 02 23:05:14 2cbaa51b01c9 web.log 172.17.0.1 - - [02/May/2023 15:05:13] "GET / HTTP/1.1" 200 -
May 02 23:05:14 2cbaa51b01c9 web.log 172.17.0.1 - - [02/May/2023 15:05:13] "GET /assets/style.css HTTP/1.1" 200 -
May 02 23:05:14 2cbaa51b01c9 web.log 172.17.0.1 - - [02/May/2023 15:05:13] "GET /assets/main.js HTTP/1.1" 200 -
May 02 23:05:14 2cbaa51b01c9 web.log 172.17.0.1 - - [02/May/2023 15:05:13] "GET /assets/perth-koondoola-evening.jpg HTTP/1.1" 200 -
May 02 23:05:14 2cbaa51b01c9 web.log 172.17.0.1 - - [02/May/2023 15:05:14] "GET /favicon.ico HTTP/1.1" 200 -
May 02 23:11:56 cebea6415c34 web.log 172.19.0.1 - - [02/May/2023 15:11:55] "GET / HTTP/1.1" 304 -
May 02 23:12:01 cebea6415c34 web.log 172.19.0.1 - - [02/May/2023 15:12:00] "GET / HTTP/1.1" 304 -
May 02 23:12:04 cebea6415c34 web.log 172.19.0.1 - - [02/May/2023 15:12:03] "GET / HTTP/1.1" 200 -
May 02 23:12:04 cebea6415c34 web.log 172.19.0.1 - - [02/May/2023 15:12:03] "GET /assets/main.js HTTP/1.1" 200 -
May 02 23:12:04 cebea6415c34 web.log 172.19.0.1 - - [02/May/2023 15:12:03] "GET /assets/style.css HTTP/1.1" 200 -
May 02 23:12:04 cebea6415c34 web.log 172.19.0.1 - - [02/May/2023 15:12:03] "GET /assets/perth-koondoola-evening.jpg HTTP/1.1" 200 -
May 02 23:12:04 cebea6415c34 web.log 172.19.0.1 - - [02/May/2023 15:12:03] "GET /favicon.ico HTTP/1.1" 200 -
```

#### Screenshots:

Screenshot showing that individual containers can be seen (running locally)
<img width="535" alt="image" src="https://user-images.githubusercontent.com/16591081/235727320-79ae1429-6ace-4dc4-bea0-52b5052cd8ad.png">

Screenshot showing loadbalancing spread over multiple containers (running in ECS)
<img width="670" alt="image" src="https://user-images.githubusercontent.com/16591081/235727589-4526c180-c2e4-4788-b621-405c3c71edde.png">

## Credits

- favicon: generated free from https://favicon.io/favicon-generator/
- morning, afternoon, evening images: James' personal photographs.
- website: based on https://codepen.io/bradtraversy/pen/XLrQvz
