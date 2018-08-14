#!/usr/bin/env sh

kubectl --namespace=kube-system patch deployment tiller-deploy --type=json --patch='[{"op": "add", "path": "/spec/template/spec/containers/0/command", "value": ["/tiller", "--listen=localhost:44134"]}]'
# Or initialize with TLS
#helm init \
#    --override 'spec.template.spec.containers[0].command'='{/tiller,--storage=secret}' \
#    --tiller-tls \
#    --tiller-tls-verify \
#    --tiller-tls-cert=cert.pem \
#    --tiller-tls-key=key.pem \
#    --tls-ca-cert=ca.pem \
#    --service-account=rleastusacr-sp1
