# Simulation

https://github.com/AstroPlant/astroplant-simulation

https://github.com/AstroPlant/astroplant-kit

```
export DOCKER_ID_USER="salekd"
docker login https://index.docker.io/v1/

docker build . -f ./Dockerfile -t astroplant-simulation --no-cache
docker tag astroplant-simulation $DOCKER_ID_USER/astroplant-simulation:0.0.2
docker push $DOCKER_ID_USER/astroplant-simulation:0.0.2
```

```
PGPASSWORD=$PASSWORD psql --host postgresql.$CLUSTER --port 9999 -U postgres -d astroplant -c "SELECT * FROM raw_measurements" | cat
PGPASSWORD=$PASSWORD psql --host postgresql.$CLUSTER --port 9999 -U postgres -d astroplant -c "SELECT * FROM aggregate_measurements" | cat
```

https://website.{{CLUSTER}}/kit/k-test
