# pinpayments-challenge

Deployment and documentation of a simple website.

- Deployed website URL: https://srechallenge.online
- Deployed alternate environment: https://alternate.srechallenge.online
- Deployed cloudfront URL: https://d318mzutsp2tq6.cloudfront.net
- Status/monitoring: https://status.srechallenge.online/
- Status/monitoring for internal services: https://internal-status.srechallenge.online/

![draw io_SwkvProLf9](https://user-images.githubusercontent.com/16591081/235646169-501c3aab-df6b-4ed3-806c-d33fded16c5b.gif)

### Challenge Requirements

- [x] build simple website with text & image
- [x] deploy in AWS
- [x] upload to public Github repo
- [x] Provide documentation for running locally
- [x] Set up monitoring and alerting
  - https://status.srechallenge.online/
- [ ] Provide a mechanism for scaling the service [WIP]
  - Cloudfront/S3 are inherently scalable with no further action required.
  - However since the exercise appears to require it, I am going to add an alternative deployment method that can be manually scaled.
  - I have chosen a container deployed on ECS, with an elastic load balancer in front. Cloudflare is also in front of that.
- [ ] Provide documentation for scaling up
- [x] Add automation
  - Github actions will run and deploy on pushes to `main`
  - I have only implemented simple pipeline automation here because I'm not so familiar with Github, my experience is primarily with Gitlab.
- [ ] Provide network diagrams
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
cdnHostname   : "d318mzutsp2tq6.cloudfront.net"
cdnURL        : "https://d318mzutsp2tq6.cloudfront.net"
originHostname: "bucket-redacted.s3-website-ap-southeast-2.amazonaws.com"
originURL     : "http://bucket-redacted.s3-website-ap-southeast-2.amazonaws.com"
publicURL     : "https://srechallenge.online"
```

## Automated Deployment

1. Make changes (either to infrastructure, or the website code)
2. Commit to git and push to `main` on this Github repository.
3. The changes will be deployed automatically.

## Credits

- favicon: generated free from https://favicon.io/favicon-generator/
- morning, afternoon, evening images: James' personal photographs.
- website: based on https://codepen.io/bradtraversy/pen/XLrQvz
