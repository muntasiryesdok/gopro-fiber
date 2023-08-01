FROM golang:1.19-alpine AS builder

RUN apk update && apk add --no-cache curl
RUN apk add --no-cache git
#Live reload changes file
RUN go install github.com/githubnemo/CompileDaemon@latest

# Move to working directory (/build).
WORKDIR /app

# Copy and download dependency using go mod.
COPY go.mod go.sum ./
RUN go mod download

# Copy the code into the container.
COPY ./ ./

ENTRYPOINT CompileDaemon --build="go build -o build/gofiber" -command="./build/gofiber" -build-dir=/app

# Set necessary environment variables needed for our image and build the API server.
# ENV CGO_ENABLED=0 GOOS=linux GOARCH=amd64
# RUN go build -ldflags="-s -w" -o apiserver .

# FROM scratch

# Copy binary and config files from /build to root folder of scratch container.
# COPY --from=builder ["/build/apiserver", "/build/.env", "/"]

# Command to run when starting the container.
# ENTRYPOINT ["/apiserver", "air"]
