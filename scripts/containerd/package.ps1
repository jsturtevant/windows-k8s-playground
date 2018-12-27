Param(
  [string]$binaryPath = "c:\kubebinaries\containerd",
  [string]$packagePath = "c:\kubepackages",
  [string]$blobContainer = "containerd-win",
  [string]$blobaccount = "containerdbinaries"
)

$date = (Get-Date).ToFileTimeUtc()
$binaryPackageName = "kubebinaries_$date.tar.gz"
tar -cvzf "$packagePath\$binaryPackageName " $binaryPath

#must set: $env:AZURE_STORAGE_CONNECTION_STRING=""
az storage container create -n $blobContainer
az storage blob upload -c $blobContainer -f "$packagePath\$binaryPackageName" -n "$binaryPackageName"

echo https://$blobaccount.blob.core.windows.net/$blobContainer/$binaryPackageName