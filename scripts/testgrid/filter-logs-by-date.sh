TIME_STAMP="20:06"
LOGS_FOLDER="$HOME/k8s-logs/ci-kubernetes-e2e-aks-engine-azure-1-18-windows-serial-slow/1315329169306947584"

mkdir -p $LOGS_FOLDER/filtered/

# build logs: https://unix.stackexchange.com/a/24151
sed -n -e "s/^.*\($TIME_STAMP\)/\1/p" $LOGS_FOLDER/build-log.txt | sed 's/: / build /' - > $LOGS_FOLDER/filtered/build.log

# controller manager logs
find $LOGS_FOLDER -name "*controller-manager*" | xargs sed -n -e "s/^.*\($TIME_STAMP\)/\1/p" | sed 's/ / cm /' > $LOGS_FOLDER/filtered/controller-manager.log

# kubelet windows
find $LOGS_FOLDER -name "*kubelet.err.log*" | xargs sed -n -e "s/^.*\($TIME_STAMP\)/\1/p" | sed 's/ / kw /' > $LOGS_FOLDER/filtered/kubelet-windows.log

sort $LOGS_FOLDER/filtered/* > $LOGS_FOLDER/filtered/joined.log



