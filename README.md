# Azure DevOps Agent Pool on VM Scale Set

This repository contains infrastructure deployment scripts that can be used to create a Virtual Machine Scale Set (VMSS) running a set of DevOps build agents. Each node in the scale set is based on a VM image that can be customized to add any necessary pre-requisites. On node start, the DevOps agent is installed and registered in a Build Pool.

## Creating the VM image

The Packer configuration can be used to build a new Azure VM Image. The image is based on Ubuntu 18.04 LTS and installs some basic build tools (`build-essential`, Docker, ...) The installation script used is `install-build-agent.sh`.

The managed image created is called `build-agent-image`.

```
packer build -force agent-image.json
```

## Starting a VM Scale Set

`azuredeploy.json` is an ARM Template that will spin up a VM Scale Set based on the image created in the previous step.

To deploy it:

```
az group deployment create -g vmss-build-pool --template-file azuredeploy.json --parameters @deploy-parameters.json
```

Upon deployment, every node of the scale set will run `start-agent.sh` to configure the Azure DevOps agent. It can also perform some other initialization tasks, like pre-pulling some Docker images or pre-populating other caches.

You will need to edit `deploy-parameters.json` to change the deployment parameters:

- `adminUsername`: the name for the administrative user account created on the VM.
- `adminPassword`: the password for the administrative user account.
- `subnetId`: the resource ID of the Virtual Network subnet where the nodes will be created.
- `managedImageResourceUri`: the resource ID of the custom VM image to use for the nodes.
- `agentOrgUrl`: the URL of the Azure DevOps organization.
- `agentPat`: the Personal Access Token (PAT) used to configure the agent.
- `agentPool`: the name of the Agent Pool where the agent should register.
