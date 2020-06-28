# Getting Started

## Hetzner Cloud

Create a project in Hetzner Cloud environment. 

Create a local file with the name <PROJECT_ID>.tfvars and fill in the following parameter:

```
provider_token =
```


| Name  | Description  | 
|---|---|
| provider_token  | Cloud access token (https://console.hetzner.cloud/projects/<PROJECT_ID>/access/tokens)  | 

## Azure

Create a subcription in Azure Cloud. 

Create a Service Principal (https://www.terraform.io/docs/providers/azurerm/guides/service_principal_client_secret.html) - requires Azure CLI

```
az login

az account list

az account set --subscription="<SUBSCRIPTION_ID>"

az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/<SUBSCRIPTION_ID>"
```

Create a local file with the name <PROJECT_ID>.tfvars and fill in the following parameter:

```
provider_token =
```


| Name  | Description  | 
|---|---|
| provider_token  | Cloud access token (https://console.hetzner.cloud/projects/<PROJECT_ID>/access/tokens)  | 

## Wasabi S3 Storage for Terraform state

* Create Bucket with name *terraform-state* in *eu-central-1* region, [see](https://wasabi.com/wp-content/themes/wasabi/docs/User_Guide/topics/Creating_a_Bucket.htm)
* Asign access key, [see](https://wasabi.com/wp-content/themes/wasabi/docs/Getting_Started/topics/Assigning_an_Access_Key.htm)

## Cloudflare

* Create free plan

* Change your nameservers
> Log in to your registrar account -  Replace with Cloudflare's nameservers:
> Registrars typically process nameserver updates within 24 hours. Once this process > completes, Cloudflare confirms your site activation via email.



Add the following parameters to the file <PROJECT_ID>.tfvars.
```
domain =
email = 
dns_admin_api_token =
```
| Name  | Description  | 
|---|---|
| domain  | Domain  | 
| email  | Cloudflare login email  | 
| dns_admin_api_token  | Cloudflare Global API Key | 

## Kubernetes ArgoCD
Add the following parameter to the file <PROJECT_ID>.tfvars.
```
argocd_admin_password =
```
| Name  | Description  | 
|---|---|
| argocd_admin_password  | ArgoCD password for admin user | 


## Concourse CI

Add the following parameters to the file *credentials.yaml* in *ci* folder.

```
terraform-backend-bucket:
terraform-backend-access-key:
terraform-backend-secret-key:
terraform-environments-git-private-key:
terraform-environments-git-crypt-key: 
```

| Name  | Description  | 
|---|---|
| terraform-backend-bucket  | Wasabi S3 bucket name  | 
| terraform-backend-access-key  | Wasabi S3 access key  | 
| terraform-backend-secret-key  | Wasabi S3 secret key  | 
| terraform-environments-git-private-key  | Git repo private key | 
| terraform-environments-git-crypt-key  | git-crypt export-key -- - `|` base64 | 

Start CI server 

```bash
./ci.sh up <environment_name>
```

Stop CI server 

```bash
./ci.sh down
```

