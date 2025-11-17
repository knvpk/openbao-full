ARG VERSION="2.4"

FROM golang:1.24-alpine3.22 AS builder

ENV GOOS=linux
ENV GOARCH=amd64
ENV CGO_ENABLED=0

WORKDIR /src

RUN apk add git

RUN git clone https://github.com/openbao/openbao-plugins .

RUN mkdir -p dist
RUN touch dist/sha_256.txt

RUN go build -o dist/auth-aws ./auth/aws/cmd
RUN sha256sum dist/auth-aws >> dist/sha_256.txt

RUN go build -o dist/auth-azure ./auth/azure/cmd
RUN sha256sum dist/auth-azure >> dist/sha_256.txt

RUN go build -o dist/auth-gcp ./auth/gcp/cmd
RUN sha256sum dist/auth-gcp >> dist/sha_256.txt

RUN go build -o dist/auth-github ./auth/github/cmd
RUN sha256sum dist/auth-github >> dist/sha_256.txt

RUN go build -o dist/secrets-aws ./secrets/aws/cmd
RUN sha256sum dist/secrets-aws >> dist/sha_256.txt

RUN go build -o dist/secrets-azure ./secrets/azure/cmd
RUN sha256sum dist/secrets-azure >> dist/sha_256.txt

RUN go build -o dist/secrets-consul ./secrets/consul/cmd
RUN sha256sum dist/secrets-consul >> dist/sha_256.txt

RUN go build -o dist/secrets-gcp ./secrets/gcp/cmd
RUN sha256sum dist/secrets-gcp >> dist/sha_256.txt

RUN go build -o dist/secrets-gcpkms ./secrets/gcpkms/cmd
RUN sha256sum dist/secrets-gcpkms >> dist/sha_256.txt

RUN go build -o dist/secrets-nomad ./secrets/nomad/cmd
RUN sha256sum dist/secrets-nomad >> dist/sha_256.txt


FROM openbao/openbao:${VERSION} AS runtime

RUN mkdir -p /openbao/plugins

COPY --from=builder /src/dist/ /openbao/plugins/

RUN chown -R openbao:openbao /openbao/plugins/

RUN chmod 777 -R /openbao/plugins