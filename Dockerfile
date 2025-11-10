ARG VERSION="2.4"

FROM golang:1.24 AS builder

ENV CGO_ENABLED=0
ENV GOOS=linux

WORKDIR /src

RUN git clone https://github.com/openbao/openbao-plugins .

RUN mkdir -p dist
RUN touch dist/sha_256.txt

RUN go build -o dist/auth-aws ./auth/aws
RUN sha256sum dist/auth-aws >> dist/sha_256.txt

RUN go build -o dist/auth-azure ./auth/azure
RUN sha256sum dist/auth-azure >> dist/sha_256.txt

RUN go build -o dist/auth-gcp ./auth/gcp
RUN sha256sum dist/auth-gcp >> dist/sha_256.txt

RUN go build -o dist/auth-github ./auth/github
RUN sha256sum dist/auth-github >> dist/sha_256.txt

RUN go build -o dist/secrets-aws ./secrets/aws
RUN sha256sum dist/secrets-aws >> dist/sha_256.txt

RUN go build -o dist/secrets-azure ./secrets/azure
RUN sha256sum dist/secrets-azure >> dist/sha_256.txt

RUN go build -o dist/secrets-consul ./secrets/consul
RUN sha256sum dist/secrets-consul >> dist/sha_256.txt

RUN go build -o dist/secrets-gcp ./secrets/gcp
RUN sha256sum dist/secrets-gcp >> dist/sha_256.txt

RUN go build -o dist/secrets-gcpkms ./secrets/gcpkms
RUN sha256sum dist/secrets-gcpkms >> dist/sha_256.txt

RUN go build -o dist/secrets-nomad ./secrets/nomad
RUN sha256sum dist/secrets-nomad >> dist/sha_256.txt


FROM openbao/openbao:${VERSION} AS runtime

RUN mkdir -p /openbao/plugins

COPY --from=builder /src/dist/ /openbao/plugins/