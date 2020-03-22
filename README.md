RUN this command to get a docker image for kong with go-pluginserver
`docker build kong .`

To run the docker image
`
docker run -d --name kong \
    --link kong-database:kong-database \
    -e "KONG_DATABASE=off" -e  "KONG_GO_PLUGINS_DIR=/usr/local/kong" -e "KONG_PLUGINS=go-hello" \
    -e "KONG_PG_HOST=kong-database" -e "KONG_DECLARATIVE_CONFIG=/tmp/config.yml" \
    -e "KONG_CASSANDRA_CONTACT_POINTS=kong-database" \
    -e "KONG_PROXY_ACCESS_LOG=/dev/stdout" \
    -e "KONG_ADMIN_ACCESS_LOG=/dev/stdout" \
    -e "KONG_PROXY_ERROR_LOG=/dev/stderr" \
    -e "KONG_ADMIN_ERROR_LOG=/dev/stderr" \
    -e "KONG_ADMIN_LISTEN=0.0.0.0:8001, 0.0.0.0:8444 ssl" \
    -p 8000:8000 \
    -p 8443:8443 \
    -p 8001:8001 \
    -p 8444:8444 \
    kong
`

Hit 
`curl -I -X GET http://localhost:8000/`

You should get a hello header in response due to hello plugin in kong :)
