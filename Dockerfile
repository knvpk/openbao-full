ARG VERSION="2.4"

FROM golang:1.24 AS builder

WORKDIR /src

RUN git clone https://github.com/openbao/openbao-plugins .

RUN mkdir -p dist
RUN touch dist/sha_256.txt

RUN go build -o dist/auth-aws ./auth/aws
RUN sha2566sum dist/auth-aws > dist/sha_256.txt

RUN go build -o dist/auth-azure ./auth/azure
RUN sha2566sum dist/auth-azure > dist/sha_256.txt

RUN go build -o dist/auth-gcp ./auth/gcp
RUN sha2566sum dist/auth-gcp > dist/sha_256.txt

RUN go build -o dist/auth-github ./auth/github
RUN sha2566sum dist/auth-github > dist/sha_256.txt

RUN go build -o dist/secrets-aws ./secrets/aws
RUN sha2566sum dist/secrets-aws > dist/sha_256.txt

RUN go build -o dist/secrets-azure ./secrets/azure
RUN sha2566sum dist/secrets-azure > dist/sha_256.txt

RUN go build -o dist/secrets-consul ./secrets/consul
RUN sha2566sum dist/secrets-consul > dist/sha_256.txt

RUN go build -o dist/secrets-gcp ./secrets/gcp
RUN sha2566sum dist/secrets-gcp > dist/sha_256.txt

RUN go build -o dist/secrets-gcpkms ./secrets/gcpkms
RUN sha2566sum dist/secrets-gcpkms > dist/sha_256.txt

RUN go build -o dist/secrets-nomad ./secrets/nomad
RUN sha2566sum dist/secrets-nomad > dist/sha_256.txt


FROM openbao/openbao:${VERSION} AS runtime

RUN mkdir -p /openbao/plugins

COPY --from=builder /src/dist/ /openbao/plugins/