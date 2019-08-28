# Terraform Kube

Kubernetes cluster provisioning using Terraform and Kubespray.

- [Terraform Kube](#terraform-kube)
	- [Prerequisites](#prerequisites)
	- [Setup](#setup)
	- [Wasabi](#wasabi)
	- [Install](#install)
		- [Provision servers](#provision-servers)
		- [Provision Kubernetes](#provision-kubernetes)
			- [Download Kuberspray](#download-kuberspray)
			- [Run ansible-playbook](#run-ansible-playbook)
	- [CI](#ci)
	- [Roadmap](#roadmap)

## Prerequisites
* Terraform version >= 0.12.5
* Ansible version >= 2.8.2
* [Kubespray requirements](https://github.com/kubernetes-sigs/kubespray#requirements)
* HetznerCloud Servers (3x CX21, [see](https://www.hetzner.com/cloud#))
* [Git-crypt](https://github.com/AGWA/git-crypt)

## Setup

Setup Terraform environment (sudo settings is only necessary on MacOS, due to [TLS handshake timeout](https://github.com/hashicorp/terraform/issues/15817))
```bash
sudo terraform init 
```

Create a local file with the name *development.tfvars* in *environments* folder and fill in the following parameters:

```
provider_token=
```


| Name  | Description  | 
|---|---|
| provider_token  | Cloud access token (https://console.hetzner.cloud/projects/<PROJECT_ID>/access/tokens)  | 

## Wasabi

 https://wasabi.com/wp-content/themes/wasabi/docs/Getting_Started/topics/Assigning_an_Access_Key.htm
https://wasabi.com/wp-content/themes/wasabi/docs/User_Guide/topics/Creating_a_Bucket.htm
credetials.yaml


## Install

### Provision servers

```bash
sudo terraform apply -var-file="environments/hc-dev.tfvars"  -auto-approve
```

### Provision Kubernetes

#### Download Kuberspray
```bash
git clone git@github.com:kubernetes-sigs/kubespray.git

cd kubespray

# RELEASE_TAG = Kubespray version (for example v2.10.4)
git checkout <RELEASE_TAG>
```

#### Run ansible-playbook

Set *ANSIBLE_INVALID_TASK_ATTRIBUTE_FAILED* to *false* because of Ansible 2.8.x ( [see kubespray issue]( https://github.com/kubernetes-sigs/kubespray/issues/3985), and [ansible issue]( https://github.com/ansible/ansible/issues/56072))
```bash
export ANSIBLE_INVALID_TASK_ATTRIBUTE_FAILED=False
```
```bash
# run inside kubespray directory
ansible-playbook -i ../inventories/default/hosts.ini cluster.yml --extra-vars "@../inventories/default/variables.json"
```

## CI

git-crypt export-key -- - | base64

## Roadmap
* Floating IP - https://www.terraform.io/docs/providers/hcloud/r/floating_ip.html
* DNS Management
* SSL Cert Management
* Metallb Deployment