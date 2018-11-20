This requires [win-rm enabled](https://docs.microsoft.com/en-us/windows/desktop/WinRM/installation-and-configuration-for-windows-remote-management) on the vms.  This is easy to do in [azure](https://github.com/PatrickLang/kubernetes-windows-dev#if-winrm-isnt-enabled) if your [acs-engine deployment](https://github.com/Azure/acs-engine/tree/d6e7cf5364e7f7e01b84f3b1ad11422fc2cbac82/extensions/winrm) didn't already have this enabled.  

This currently only dumps the windows logs and should only be used in dev/test scenarios.

```
export WIN_PASS=<your-pass>
./dump-logs.ssh 12.34.45.6   
```

This will be cleaner when [OpenSSH is enabled in Server 2019](https://docs.microsoft.com/en-us/windows-server/administration/openssh/openssh_install_firstuse).

## Common use case
Once you have the logs you can search for a container id of a failed conformance test and find all the logs relevant to that container.