from urllib.request import urlretrieve

from diagrams import Cluster, Diagram
from diagrams.custom import Custom
from diagrams.k8s.infra import Master
from diagrams.k8s.infra import Node
from diagrams.onprem.gitops import Argocd
from diagrams.onprem.network import Istio
from diagrams.k8s.storage import StorageClass

terraform_url = "https://www.terraform.io/assets/images/og-image-8b3e4f7d.png"
terraform_icon = "terraform.png"
urlretrieve(terraform_url, terraform_icon)

kubespray_url = "https://kubespray.io/logo/logo-clear.png"
kubespray_icon = "kubespray.png"
urlretrieve(kubespray_url, kubespray_icon)

kubernetes_url = "https://upload.wikimedia.org/wikipedia/commons/thumb/3/39/Kubernetes_logo_without_workmark.svg/1200px-Kubernetes_logo_without_workmark.svg.png"
kubernetes_icon = "kubernetes.png"
urlretrieve(kubernetes_url, kubernetes_icon)

cloudflare_url = "https://s3.us-east-2.amazonaws.com/upload-icon/uploads/icons/png/17745148381536207307-256.png"
cloudflare_icon = "cloudflare.png"
urlretrieve(cloudflare_url, cloudflare_icon)

wasabi_url = "https://assets.wasabi.com/wp-content/uploads/2017/05/fav_250.png"
wasabi_icon = "wasabi.png"
urlretrieve(wasabi_url, wasabi_icon)

cert_manager_url = "https://github.com/jetstack/cert-manager/raw/master/logo/logo.png"
cert_manager_icon = "cert_manager.png"
urlretrieve(cert_manager_url, cert_manager_icon)

loki_url = "https://img.stackshare.io/service/10079/loki.png"
loki_icon = "loki.png"
urlretrieve(loki_url, loki_icon)

bitnami_url = "https://avatars1.githubusercontent.com/u/34656521?s=280&v=4"
bitnami_icon = "bitnami.png"
urlretrieve(bitnami_url, bitnami_icon)

concourse_url = "https://git.rrerr.net/uploads/-/system/project/avatar/434/concourse-black.png"
concourse_icon = "concourse.png"
urlretrieve(concourse_url, concourse_icon)

metallb_url = "https://v0-3-0--metallb.netlify.com/images/logo.png"
metallb_icon = "metallb.png"
urlretrieve(metallb_url, metallb_icon)

with Diagram("Terraform Kube"):

    cloudFlare = Custom("Cloudflare DNS", cloudflare_icon)
    wasabi = Custom("Wasabi S3 Storage", wasabi_icon)

    with Cluster("Concourse CI"):
        Custom("Concourse CI", concourse_icon)
        with Cluster("K8s Provisioning Pipeline"):
            createServersStage=Custom("Create Servers", terraform_icon)
            deployClusterStage=Custom("Deploy K8s Cluster", kubespray_icon)
            deployComponentsStage=Custom("Deploy K8s Components", kubernetes_icon)
        with Cluster("K8s Destroying Pipeline"):
            destroyServersStage=Custom("Destroy Servers", terraform_icon)

    with Cluster("Hetzner Cloud"):
        with Cluster("WireGuard VPN"):
            with Cluster("Kubernetes Cluster"):
                masterNodes = Master("N masters")
                workerNodes = Node("N workers")
                with Cluster("System Application"):
                    argoCd = Argocd("Argo CD")
                    sealedSecrets = Custom("Sealed Secrets", bitnami_icon)
                    metallb = Custom("Metal LB", metallb_icon)
                    certManager = Custom("Cert Manager", cert_manager_icon)
                    istio = Istio("Istio")
                    storage = StorageClass("HCloud CSI")
                    loki = Custom("Loki", loki_icon)

    createServersStage >> deployClusterStage >> deployComponentsStage
    createServersStage >> masterNodes
    deployClusterStage >> masterNodes
    deployComponentsStage >> argoCd
    deployComponentsStage >> sealedSecrets
    deployClusterStage >> metallb
    masterNodes - workerNodes
    createServersStage >> cloudFlare
    createServersStage >> wasabi
    destroyServersStage >> cloudFlare
    destroyServersStage >> wasabi
    destroyServersStage >> masterNodes
    
    argoCd >> certManager >> cloudFlare
    argoCd >> istio
    argoCd >> loki
    argoCd >> storage
    certManager >> istio