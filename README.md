# Terraform Kube

Kubernetes cluster provisioning using Terraform and Kubespray.

- [Terraform Kube](#Terraform-Kube)
	- [Prerequisites](#Prerequisites)
	- [Setup](#Setup)
	- [Install](#Install)
		- [Provision servers](#Provision-servers)
		- [Provision Kubernetes](#Provision-Kubernetes)
			- [Download Kuberspray](#Download-Kuberspray)
			- [Run ansible-playbook](#Run-ansible-playbook)

## Prerequisites
* Terraform version >= 0.12.5
* Ansible version >= 2.8.2
* [Kubespray requirements](https://github.com/kubernetes-sigs/kubespray#requirements)
* HetznerCloud Servers (3x CX21, [see](https://www.hetzner.com/cloud#))

## Setup

Setup Terraform environment (sudo settings is only necessary on MacOS, due to [TLS handshake timeout](https://github.com/hashicorp/terraform/issues/15817))
```bash
sudo terraform init 
```

Create a local file with the name *development.tfvars* and fill in the following parameters:

```
provider_token=
provider_ssh_key_names = [
	
]
ssh_private_key_path = 
```


| Name  | Description  | 
|---|---|
| provider_token  | Cloud access token (https://console.hetzner.cloud/projects/<PROJECT_ID>/access/tokens)  | 
| provider_ssh_key_names  | Access SSH keys (https://console.hetzner.cloud/projects/<PROJECT_ID>/access/sshkeys)  | 
| ssh_private_key_path  | Local path to private ssh key to connect to created servers (must be one of the stored in provider_ssh_key_names)  | 

## Install

### Provision servers

```bash
sudo terraform apply -var-file="development.tfvars"  -auto-approve
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

Set *ANSIBLE_INVALID_TASK_ATTRIBUTE_FAILED* to *false* because of Ansible 2.8.x ( [see]( https://github.com/kubernetes-sigs/kubespray/issues/3985), [and]( https://github.com/ansible/ansible/issues/56072))
```bash
export ANSIBLE_INVALID_TASK_ATTRIBUTE_FAILED=False
```
```bash
ansible-playbook -i ../ansible-hosts.ini cluster.yml
```