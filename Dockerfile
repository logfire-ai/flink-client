FROM golang:1.19.4-alpine as builder
# RUN apk update && apk add --no-cache git && apk add --no-cache bash && apk add build-base
RUN apk update && apk add --no-cache git && apk add --no-cache bash && apk add build-base

# Setup folders
RUN mkdir /app
WORKDIR /app


# Copy the source from the current directory to the working Directory inside the container
# COPY ./app ./app
COPY main.go .
COPY go.mod .

RUN go get -d -v ./...

# Install the package
RUN go install -v ./...

RUN go build -o main .


######## Start a new stage from scratch #######

FROM flink:1.16.1-scala_2.12-java11

# ARG GO_VERSION
ENV GO_VERSION=1.19.4
# RUN apk --no-cache add ca-certificates
RUN apt-get update
RUN apt-get install -y wget git gcc

RUN wget -P /tmp "https://dl.google.com/go/go${GO_VERSION}.linux-amd64.tar.gz"

RUN tar -C /usr/local -xzf "/tmp/go${GO_VERSION}.linux-amd64.tar.gz"
RUN rm "/tmp/go${GO_VERSION}.linux-amd64.tar.gz"


# ENV GOPATH /go
# ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH
# RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH"

# WORKDIR $GOPATH

WORKDIR /root/

COPY --from=builder /app/main .
# COPY ./app ./app

# Expose port 8080 to the outside world
EXPOSE 8080

# Command to run the executable
CMD ["./main"]