ARG VERSION="2.4"

FROM golang:1.24 AS builder

WORKDIR /src

RUN git clone https://github.com/openbao/openbao-plugins .

RUN mkdir -p dist
RUN touch dist/sha_256.txt

RUN go build -o dist/openbao-auth-aws ./auth/aws
RUN sha2566sum dist/openbao-auth-aws > dist/sha_256.txt

RUN go build -o dist/openbao-auth-azure ./auth/azure
RUN sha2566sum dist/openbao-auth-azure > dist/sha_256.txt

RUN go build -o dist/openbao-auth-gcp ./auth/gcp
RUN sha2566sum dist/openbao-auth-gcp > dist/sha_256.txt

RUN go build -o dist/openbao-auth-github ./auth/github
RUN sha2566sum dist/openbao-auth-github > dist/sha_256.txt

RUN go build -o dist/openbao-secrets-aws ./secrets/aws
RUN sha2566sum dist/openbao-secrets-aws > dist/sha_256.txt

RUN go build -o dist/openbao-secrets-azure ./secrets/azure
RUN sha2566sum dist/openbao-secrets-azure > dist/sha_256.txt

RUN go build -o dist/openbao-secrets-consul ./secrets/consul
RUN sha2566sum dist/openbao-secrets-consul > dist/sha_256.txt

RUN go build -o dist/openbao-secrets-gcp ./secrets/gcp
RUN sha2566sum dist/openbao-secrets-gcp > dist/sha_256.txt

RUN go build -o dist/openbao-secrets-gcpkms ./secrets/gcpkms
RUN sha2566sum dist/openbao-secrets-gcpkms > dist/sha_256.txt

RUN go build -o dist/openbao-secrets-nomad ./secrets/nomad
RUN sha2566sum dist/openbao-secrets-nomad > dist/sha_256.txt


FROM openbao/openbao:${VERSION} AS runtime

RUN mkdir -p /openbao/plugins

COPY --from=builder /src/dist/ /openbao/plugins/