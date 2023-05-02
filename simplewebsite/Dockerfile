# Extremely quick and simple dockerfile to get a basic service up
FROM python:3.11.3-alpine3.16

WORKDIR /www

COPY ./ ./

# Run the container with `docker run -p 8000:8000 <imagename>`
EXPOSE 80

# -u so that it doesn't buffer the logs
# 80 serves on port 80 to be more compatible with ECS which expects 80 by default
CMD ["python3", "-u", "-m", "http.server", "80"]