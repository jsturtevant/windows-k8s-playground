Since acs-engine 1.10 the dashboard has been locked down.  You will need to create users with specific permissions.  This is an example how to create a admin user that has access to everything and should only used in development scenarios.

To get a key for the dashbaord: 

`kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep admin-user | awk '{print $1}')`

To learn more checkout https://github.com/kubernetes/dashboard/wiki/Accessing-dashboard
