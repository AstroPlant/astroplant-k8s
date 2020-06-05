# API

Deployment files for the [astroplant-api repository](https://github.com/AstroPlant/astroplant-api) and the Swagger UI of the OpenAPI specification.

## Docker image

To push a new docker image to the docker hub registry, run:

```
export DOCKER_ID_USER="salekd"
docker login https://index.docker.io/v1/

git clone https://github.com/AstroPlant/astroplant-api.git
cd astroplant-api
docker build . -t astroplant-api
docker tag astroplant-api $DOCKER_ID_USER/astroplant-api:0.0.1
docker push $DOCKER_ID_USER/astroplant-api:0.0.1
```

https://github.com/swagger-api/swagger-ui/blob/master/docs/usage/configuration.md
