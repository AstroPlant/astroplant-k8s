# Static website

```
git clone https://github.com/astroplant/astroplant-frontend-web
cd astroplant-frontend-web/local_modules/astroplant-api
npm install
cd ../..
npm install
export REACT_APP_API_URL=https://api.astroplant.sda-projects.nl
export REACT_APP_WEBSOCKET_URL=wss://ws.astroplant.sda-projects.nl
npm run build
```

https://hub.docker.com/_/nginx

https://github.com/nginxinc/docker-nginx/blob/e3bbc1131a683dabf868268e62b9d3fbd250191b/stable/buster/Dockerfile

https://www.docker.com/blog/tips-for-deploying-nginx-official-image-with-docker/

```
docker run --name nginx -v $(pwd)/static:/usr/share/nginx/html:ro \
  -v $(pwd)/default.conf:/etc/nginx/conf.d/default.conf:ro -p 8080:80 -d nginx:1.16.1

docker ps -a
```

http://localhost:8080

```
export POD_NAME=$(kubectl get pods -l app=nginx -o jsonpath='{ .items[0].metadata.name}')
kubectl port-forward $POD_NAME 8080:80
```
