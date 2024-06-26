#!/bin/sh
items="download-web
fair
lida
news
npay-test
parse
phone-getter3
silk-road-media
srqg-test
srqz-bl003
srqz-bl003-admin
srqz-hg001
srqz-hg001-admin
srqz-jsh
srqz-jsh-admin
srqz-jz
srqz-xh001
srqz-xh001-admin
srqz-yicai
srqz-yicai-admin
taohuadao
twlhc
video-91spider
weave
wo-shop
wpay-release-api
wpay-release-user
wpay-test
wwwww
wwwww-admin
xlx-release2
zb-discuz"

# Loop through each item and echo it
for item in $items; do
  kubectl -n $item get deploy  -o json | jq 'del(.items[].status, .items[].metadata.creationTimestamp,  .items[].metadata.annotations."kubesphere.io/creator", .items[].metadata.resourceVersion, .items[].metadata.uid)' | jq -c '.items[]' | sed 's/harbor/harbor6/g' > $item-deploy.json
  kubectl -n $item get svc  -o json | jq 'del(.items[].spec.clusterIP,  .items[].spec.clusterIPs,.items[].spec.ipFamilies,.items[].spec.ipFamilyPolicy,.items[].spec.externalTrafficPolicy, .items[].status, .items[].metadata.creationTimestamp, .items[].metadata.annotations."kubesphere.io/creator", .items[].metadata.annotations.finalizers, .items[].metadata.resourceVersion, .items[].metadata.uid)' | jq -c '.items[]'  > $item-svc.json
  kubectl -n $item get cm  -o json | jq 'del(.items[].metadata.creationTimestamp,  .items[].metadata.annotations."kubesphere.io/creator", .items[].metadata.annotations."kubectl.kubernetes.io/last-applied-configuration", .items[].metadata.resourceVersion, .items[].metadata.uid) | .items |= map(select(.metadata.name != "istio-ca-root-cert")) | .items |= map(select(.metadata.name != "kube-root-ca.crt"))' | jq -c '.items[]' > $item-cm.json
  kubectl -n $item get secret  -o json | jq 'del(.items[].metadata.creationTimestamp,  .items[].metadata.annotations."kubesphere.io/creator", .items[].metadata.annotations."kubectl.kubernetes.io/last-applied-configuration", .items[].metadata.resourceVersion, .items[].metadata.uid)' | jq -c '.items[]' > $item-secret.json
  kubectl -n $item get ing  -o json | jq 'del(.items[].status, .items[].metadata.creationTimestamp,  .items[].metadata.annotations."kubesphere.io/creator", .items[].metadata.resourceVersion, .items[].metadata.uid)' | jq -c '.items[]' > $item-ing.json
  kubectl -n $item get pvc  -o json  | jq 'del(.items[].status,.items[].spec.volumeName,.items[].spec.storageClassName, .items[].metadata.creationTimestamp,  .items[].metadata.annotations."kubesphere.io/creator", .items[].metadata.resourceVersion, .items[].metadata.uid, .items[].metadata.finalizers, .items[].metadata.annotations)' | jq -c '.items[]' > $item-pvc.json
  echo "$item"
done
