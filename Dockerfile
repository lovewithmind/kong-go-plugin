FROM kong:2.0-ubuntu as compiler

RUN apt-get update -y && DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y -q curl build-essential ca-certificates git

RUN curl -s https://storage.googleapis.com/golang/go1.13.5.linux-amd64.tar.gz | tar -v -C /usr/local -xz
ENV GOPATH /go
ENV GOROOT /usr/local/go
ENV PATH $PATH:/usr/local/go/bin


RUN go get github.com/Kong/go-pluginserver

RUN git clone https://github.com/Kong/go-plugins /usr/src/go-plugins
RUN mkdir /tmp/go-plugins; cp /usr/src/go-plugins/go-hello.go /tmp/go-plugins
RUN cd /tmp/go-plugins; go build -buildmode plugin go-hello.go

FROM kong:2.0-ubuntu

RUN useradd kong \
	&& mkdir -p /usr/local/kong \
	&& chown -R kong:0 /usr/local/kong \
	&& chmod -R g=u /usr/local/kong

COPY --from=compiler /tmp/go-plugins/*.so /usr/local/kong/
COPY --from=compiler /go/bin/go-pluginserver /usr/local/bin/go-pluginserver

USER kong

COPY config.yml /tmp/config.yml
