# k8 1.9 with Windows Containers
Playground for playing with Windows on Kubernetes.

## Create Resource Group and Service Principle
```
az login
az group create -n acsengine-win -l eastus
az account set --subscription="${SUBSCRIPTION_ID}"
az ad sp create-for-rbac --role="Owner" --scopes="/subscriptions/${SUBSCRIPTION_ID}/resourceGroups/acsengine-win"
```
Copy output for updating `kubernetes.json` in next step.

## Create the cluster
- Update fields in `kubernetes.json` (service principle/password/public key)
- Run ACS Engine to generate output: `acs-engine.exe generate kubernetes.json`
- Deploy cluster: `az group deployment create --name acsenginedeploy -g acsengine-win --template-file "_output/acsengine-win/azuredeploy.json" --parameters "./_output/acsengine-win/azuredeploy.parameters.json"`
- Set your context: `export  KUBECONFIG=_output/acsengine-win/kubeconfig/kubeconfig.eastus.json`
- Double check your config: `k config current-context`
- see your window nodes and linux nodes: `k get nodes -o wide`

## Deploy Service
- [Deploy your first service](https://github.com/Azure/acs-engine/blob/master/docs/kubernetes/windows.md#create-your-first-kubernetes-service): `k apply -f winservice.yaml`

## Scale

```bash
/mnt/c/tools/acs-engine.exe scale --subscription-id b9d9436a-0c07-4fe8-b779-2c1030bd7997 \
    --resource-group acsengine-win-193  --location eastus \
    --deployment-dir _output/acsengine-win-193 --new-node-count 3 \
    --node-pool windowspool2 --master-FQDN acsengine-win-193.eastus.cloudapp.azure.com
```