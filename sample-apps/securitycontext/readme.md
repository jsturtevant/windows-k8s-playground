prototype deployments for https://github.com/kubernetes/kubernetes/pull/73609

> note setting different user for iis images does not work as need permissions to reset w3svc service.

Run each deployment then exec in to each pod and view user name:

```
kubectl exec -it sc-default-84d76c754c-g2gxl cmd
Microsoft Windows [Version 10.0.17763.253]
(c) 2018 Microsoft Corporation. All rights reserved.

C:\>echo %username%
ContainerAdministrator
```

```
kubectl exec -it sc-customuser-6799b77b6d-sfckq cmd
Microsoft Windows [Version 10.0.17763.253]
(c) 2018 Microsoft Corporation. All rights reserved.

C:\>echo %username%
ContainerUser
```