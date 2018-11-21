This section includes scripts for deploying customized clusters with acs-engine.  This is most useful for testing early releases of kubernetes binaries or azure cni.

```
export pass=<your-windows-pass>

# Update values in user.env
source user.env
./deploy-acs-engine.sh
```