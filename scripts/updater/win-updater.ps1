Param(
  [string]$package,
  [boolean]$cleanlogs=$True
)

# Constants
$packageDestination = "c:\temp\dev"

Write-Host "Stop-services"
Stop-Service kubelet -Force
Stop-Service kubeproxy -Force
Stop-Service docker -Force

if ($cleanlogs){
  rm c:\k\*.log
}

if(!(Test-path "c:\temp\extracted\$package")) {
  mkdir "c:\temp\extracted\$package"
}   
tar -xzf "$packageDestination\$package" -C c:\temp\extracted\$package

#Write-Host "update azure cni" 
# cp "c:\temp\extracted\$package\azurecni\azure-vnet-ipam.exe" "c:\k\azurecni\bin\" -Force
# cp "c:\temp\extracted\$package\azurecni\azure-vnet.exe" "c:\k\azurecni\bin\" -Force
# cp "c:\temp\extracted\$package\azurecni\10-azure.conflist" "c:\k\azurecni\conflist" -Force

#Write-Host "update containerd" 
#cp "c:\temp\extracted\$package\containerd\*" "c:\containerd" -Force -Recurse

Write-Host "update kube binaries and files" 
cp "c:\temp\extracted\$package\*" "C:\k\" -Force -Recurse

Write-Host "start-services"
start-service docker
Start-Service kubelet
Start-Service kubeproxy
