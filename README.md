# Terraform Kube

**Kubernetes cluster provisioning using Terraform and Kubespray in Concourse CI environment.**

![alt](docs/pipeline.png)

- [Terraform Kube](#terraform-kube)
	- [Prerequisites](#prerequisites)
	- [Getting started](#getting-started)
		- [Hetzner Cloud](#hetzner-cloud)
		- [Wasabi S3 Storage for Terraform state](#wasabi-s3-storage-for-terraform-state)
		- [Cloudflare](#cloudflare)
		- [Concourse CI](#concourse-ci)
		- [Kubernetes ArgoCD](#kubernetes-argocd)
	- [Roadmap](#roadmap)

## Prerequisites
* Docker Compose >= 1.24.0
* HetznerCloud Servers ([3x CX21](https://www.hetzner.com/cloud#))
* [Wasabi](https://wasabi.com) S3 Storage
* [Cloudflare](https://www.cloudflare.com) free plan 
* [Git-crypt](https://github.com/AGWA/git-crypt)

## Getting started

### Hetzner Cloud

Create a project in Hetzner Cloud environment. 

Create a local file with the name <PROJECT_ID>.tfvars in *environments* folder and fill in the following parameter:

```
provider_token =
```


| Name  | Description  | 
|---|---|
| provider_token  | Cloud access token (https://console.hetzner.cloud/projects/<PROJECT_ID>/access/tokens)  | 

### Wasabi S3 Storage for Terraform state

* Create Bucket with name *terraform-state* in *eu-central-1* region, [see](https://wasabi.com/wp-content/themes/wasabi/docs/User_Guide/topics/Creating_a_Bucket.htm)
* Asign access key, [see](https://wasabi.com/wp-content/themes/wasabi/docs/Getting_Started/topics/Assigning_an_Access_Key.htm)

### Cloudflare

* Create free plan

* Change your nameservers
> Log in to your registrar account -  Replace with Cloudflare's nameservers:
> Registrars typically process nameserver updates within 24 hours. Once this process > completes, Cloudflare confirms your site activation via email.



Add the following parameters to the file <PROJECT_ID>.tfvars in *environments* folder.
```
domain =
email = 
dns_api_token =
```
| Name  | Description  | 
|---|---|
| domain  | Domain  | 
| email  | Cloudflare login email  | 
| dns_api_token  | Cloudflare Global API Key | 

### Kubernetes ArgoCD
Add the following parameter to the file <PROJECT_ID>.tfvars in *environments* folder.
```
k8s_argocd_admin_pass =
```
| Name  | Description  | 
|---|---|
| k8s_argocd_admin_pass  | ArgoCD password for admin user | 


### Concourse CI

Add the following parameters to the file *credentials.yaml* in *ci* folder.

```
terraform-backend-access-key:
terraform-backend-secret-key:
git-crypt-key: 
```

| Name  | Description  | 
|---|---|
| terraform-backend-access-key  | Wasabi S3 access key  | 
| terraform-backend-secret-key  | Wasabi S3 secret key  | 
| git-crypt-key  | git-crypt export-key -- - `|` base64 | 

Start CI server 

```bash
./ci.sh up
```

Stop CI server 

```bash
./ci.sh down
```

## Roadmap
* Floating IP reassigner - https://github.com/cbeneke/hcloud-fip-controller
* SSL Cert Management
* K8s storage
* Better documentation (Mkdoc - https://github.com/kubernetes/ingress-nginx/blob/master/mkdocs.yml)