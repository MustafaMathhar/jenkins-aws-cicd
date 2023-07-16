FROM golang:1.20.6-alpine3.18 as build
WORKDIR /app
COPY ./src/go.mod ./src/go.sum ./
COPY ./src/*.go ./

RUN CGO_ENABLED=0 GOOS=linux go build -o /hello_docker

FROM golang:1.20.6-alpine3.18 as main
WORKDIR /
COPY --from=build /hello_docker /hello_docker
EXPOSE 8080
CMD ["/hello_docker"]
