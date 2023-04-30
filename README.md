# pinpayments-challenge

Deployment and documentation of a simple website.

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

Then go to http://localhost:PORT.  Get the port from the output.

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

## Credits

- favicon: generated free from https://favicon.io/favicon-generator/
- morning, afternoon, evening images: James' personal photographs.
- website: based on https://codepen.io/bradtraversy/pen/XLrQvz