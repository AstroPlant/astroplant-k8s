# API

https://github.com/AstroPlant/astroplant-api

```
export DOCKER_ID_USER="salekd"
docker login https://index.docker.io/v1/

docker build . -f ./Dockerfile -t astroplant-api
docker tag astroplant-api $DOCKER_ID_USER/astroplant-api:0.0.2
docker push $DOCKER_ID_USER/astroplant-api:0.0.2
```

https://github.com/swagger-api/swagger-ui/blob/master/docs/usage/configuration.md
