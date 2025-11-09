
[doc("Run locally to test")]
test:
    docker run --rm -it --name openbao-dev --env BAO_DEV_ROOT_TOKEN_ID="foobar" --env BAO_DEV_LISTEN_ADDRESS="0.0.0.0:1337" --volume ./config:/openbao/config --publish 1337:1337 ghcr.io/knvpk/openbao-full:main

register:
    export BAO_ADDR='http://0.0.0.0:1337'
    bao login foobar
    docker exec -it openbao-dev cat /openbao/plugins/sha_256.txt
    bao plugin register -sha256="" secret secrets-aws