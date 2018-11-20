This script adds a public ip address to a vm. Only use in dev/test scenarios.  After run you can RDP to the vm. 

```
./add-public-ip.sh azwink8s-rg 35681k8s900nic-0
```

Other (better) options are is [port-fowarding or win-rm](https://github.com/PatrickLang/kubernetes-windows-dev#connecting-to-a-windows-node). 