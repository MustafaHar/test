#!bin/bash

# Téléchargement du fichier d'installation de Kubeflow

git clone https://github.com/kubeflow/manifests.git

cd manifests

# Installation Cert-manager

kustomize build common/cert-manager/cert-manager/base | kubectl apply -f -
kustomize build common/cert-manager/kubeflow-issuer/base | kubectl apply -f -

# Installation Istio

kustomize build common/istio-1-16/istio-crds/base | kubectl apply -f -
kustomize build common/istio-1-16/istio-namespace/base | kubectl apply -f -
kustomize build common/istio-1-16/istio-install/base | kubectl apply -f -

# Installation Dex

kustomize build common/dex/overlays/istio | kubectl apply -f -

# Installation OIDC AuthService

kustomize build common/oidc-authservice/base | kubectl apply -f -

# Installation Knative

kubectl apply -f https://github.com/knative/serving/releases/download/knative-v1.8.3/serving-crds.yaml

kubectl apply -f https://github.com/knative/serving/releases/download/knative-v1.8.3/serving-core.yaml

kustomize build common/knative/knative-serving/overlays/gateways | kubectl apply -f -
kustomize build common/istio-1-16/cluster-local-gateway/base | kubectl apply -f -
kustomize build common/knative/knative-eventing/base | kubectl apply -f -

# Installation Kubeflow Namespace

kustomize build common/kubeflow-namespace/base | kubectl apply -f -

# Installation Kubeflow Roles

kustomize build common/kubeflow-roles/base | kubectl apply -f -

# Installation Istio Resources

kustomize build common/istio-1-16/kubeflow-istio-resources/base | kubectl apply -f -

# Installation Kubeflow Pipelines

kustomize build apps/pipeline/upstream/env/cert-manager/platform-agnostic-multi-user | kubectl apply -f -

#####
# kustomize build apps/pipeline/upstream/env/platform-agnostic-multi-user-pns | kubectl apply -f -
#####

# Installation KServe

kubectl apply -f https://github.com/kserve/kserve/releases/download/v0.9.0/kserve.yaml

kustomize build contrib/kserve/kserve | kubectl apply -f -

kustomize build contrib/kserve/models-web-app/overlays/kubeflow | kubectl apply -f -

# Installation Katib

kustomize build apps/katib/upstream/installs/katib-with-kubeflow | kubectl apply -f -

# Installation Central Dashboard

kustomize build apps/centraldashboard/upstream/overlays/kserve | kubectl apply -f -

# Installation Admission Webhook

kustomize build apps/admission-webhook/upstream/overlays/cert-manager | kubectl apply -f -

# Installation Notebooks

kustomize build apps/jupyter/notebook-controller/upstream/overlays/kubeflow | kubectl apply -f -

kustomize build apps/jupyter/jupyter-web-app/upstream/overlays/istio | kubectl apply -f -

# Installation Profiles + KFAM

kustomize build apps/profiles/upstream/overlays/kubeflow | kubectl apply -f -

# Installation Volumes Web App

kustomize build apps/volumes-web-app/upstream/overlays/istio | kubectl apply -f -

# Installation Tensorboard

kustomize build apps/tensorboard/tensorboards-web-app/upstream/overlays/istio | kubectl apply -f -

kustomize build apps/tensorboard/tensorboard-controller/upstream/overlays/kubeflow | kubectl apply -f -

# Installation Training Operator

kustomize build apps/training-operator/upstream/overlays/kubeflow | kubectl apply -f -

# Installation User Namespace

kustomize build common/user-namespx²ace/base | kubectl apply -f -

# Expose port LoadBalancer

kubectl patch service -n istio-system istio-ingressgateway -p '{"spec": {"type": "LoadBalancer"}}'

# Affiche l'IP du dashboard

kubectl get svc -n istio-system istio-ingressgateway -o jsonpath='{.status.loadBalancer.ingress[0]}'
