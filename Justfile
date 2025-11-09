
[doc("Run locally to test")]
test:
    docker run --rm -it --name openbao-dev --env BAO_DEV_ROOT_TOKEN_ID="foobar" --env BAO_DEV_LISTEN_ADDRESS="0.0.0.0:1337" --publish 1337:1337 ghcr.io/knvpk/openbao-full:sha-c071110
