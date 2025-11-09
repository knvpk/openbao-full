ARG VERSION="2.4"

FROM golang:1.24 AS builder

WORKDIR /src

RUN git clone https://github.com/openbao/openbao-plugins .

RUN go build -o dist/openbao-auth-aws ./auth/aws
RUN go build -o dist/openbao-auth-azure ./auth/azure
RUN go build -o dist/openbao-auth-gcp ./auth/gcp
RUN go build -o dist/openbao-auth-github ./auth/github
RUN go build -o dist/openbao-secrets-aws ./secrets/aws
RUN go build -o dist/openbao-secrets-azure ./secrets/azure
RUN go build -o dist/openbao-secrets-consul ./secrets/consul
RUN go build -o dist/openbao-secrets-gcp ./secrets/gcp
RUN go build -o dist/openbao-secrets-gcpkms ./secrets/gcpkms
RUN go build -o dist/openbao-secrets-nomad ./secrets/nomad


FROM openbao/openbao:${VERSION} AS runtime

RUN mkdir -p /openbao/plugins

COPY --from=builder /src/dist/ /openbao/plugins/