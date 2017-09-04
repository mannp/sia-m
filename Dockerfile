FROM golang:1.9.0-alpine3.6

RUN apk update && \
    apk upgrade && \
    apk add git make socat
    
ENV PS1="$(whoami)@$(hostname):$(pwd)$ " \
HOME="/root" \
TERM="xterm"

RUN go-wrapper download -u github.com/NebulousLabs/Sia/...  # "go get -d -v ./..."

WORKDIR /go/src/github.com/NebulousLabs/Sia

ENV REFRESHED_AT 01.9.17

RUN git checkout -b v1.3.0 tags/v1.3.0
RUN make release-std

RUN apk del --purge

EXPOSE 9980

ENTRYPOINT socat tcp-listen:9980,reuseaddr,fork tcp:localhost:8000 & siad --modules=cgtrmw --sia-directory=/mnt/sia --api-addr localhost:8000
