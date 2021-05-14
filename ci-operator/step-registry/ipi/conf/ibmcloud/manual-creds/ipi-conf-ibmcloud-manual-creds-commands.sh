#!/bin/bash

set -o nounset
set -o errexit
set -o pipefail

# cluster-image-registry-operator credentials manifest
cat >> "${SHARED_DIR}/manifest_openshift-image-registry-installer-cloud-credentials-credentials.yaml" << EOF
---
apiVersion: v1
kind: Secret
metadata:
  name: installer-cloud-credentials
  namespace: openshift-image-registry
stringData:
  ibmcloud_api_key: "$(cat "${CLUSTER_PROFILE_DIR}/ibmcloud-api-key" | base64 -w 0)"
type: Opaque

EOF

# cluster-ingress-operator credentials manifest
cat >> "${SHARED_DIR}/manifest_openshift-ingress-operator-cloud-credentials-credentials.yaml" << EOF
---
apiVersion: v1
kind: Secret
metadata:
  name: cloud-credentials
  namespace: openshift-ingress-operator
stringData:
  ibmcloud_api_key: "$(cat "${CLUSTER_PROFILE_DIR}/ibmcloud-api-key" | base 64 -w 0)"
type: Opaque

EOF

# toggle CCO to manual mode via configmap
# NOTE(cjschaef): This may not be require when using instal-config.yaml
cat >> "${SHARED_DIR}/manifest_cco-configmap.yaml" << EOF
apiVersion: v1
kind: ConfigMap
metadata:
  name: cloud-credential-operator-config
  namespace: openshift-cloud-credential-operator
  annotations:
    release.openshift.io/create-only: "true"
data:
  disabled: "true"

EOF
