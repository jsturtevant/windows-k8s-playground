Param(
  [string]$win_user,
  [string]$win_pass,
  [string]$package
)

# Constants
$packageLocation = "C:\temp\$package"


# Handle credentials as parameters, else prompt for them
if (($PSBoundParameters.ContainsKey("win_user")) -and ($PSBoundParameters.ContainsKey("win_pass")))
{ 
   $passwd = ConvertTo-SecureString $win_pass -AsPlainText -Force
   $cred = New-Object System.Management.Automation.PSCredential ($win_user, $passwd) 
}
else {
   $cred = Get-Credential -Message "Please enter an admin username & password to connect to the Windows nodes"
}

$nodes = ./kubectl get node -o json | ConvertFrom-Json
$nodes.items | Where-Object { $_.metadata.labels.'beta.kubernetes.io/os' -eq 'windows' } | foreach-object {
  ./kubectl drain $_.status.nodeInfo.machineID
  
  #connect to machine
  $session = New-PSSession -ComputerName $_.status.nodeInfo.machineID -Credential $cred -UseSSL -Authentication basic
  Add-Member -InputObject $_ -MemberType NoteProperty -Name "pssession" -Value $session
  Write-Host Connected to $_.status.nodeInfo.machineID

  #copy up our new binaries
  Copy-Item /app/package/$package -Destination $packageLocation -ToSession $session

  # Write-Host Logs:
  $timeStamp = get-date -format 'yyyyMMdd-hhmmss'
  $zipName = "$($_.status.nodeInfo.machineID)-$($timeStamp)_logs.zip"
  $remoteZipPath = Invoke-Command -Session $_.pssession {
    Stop-Service kubelet -Force
    Stop-Service containerd -Force

    Expand-Archive -Path $packageLocation -DestinationPath "c:\temp\extracted\"

    Write-Host "update azure cni" 
    mv "c:\temp\extracted\azurecni\azure-vnet-ipam.exe" "c:\k\azurecni\bin\" -Force
    mv "c:\temp\extracted\azurecni\azure-vnet.exe" "c:\k\azurecni\bin\" -Force
    mv "c:\temp\extracted\azurecni\10-azure.conflist" "c:\k\azurecni\conflist" -Force

    Write-Host "update containerd" 
    mv "c:\temp\extracted\containerd\" "c:\containerd" -Force -Recurse

    Write-Host "update kube binaries and files" 
    mv "c:\temp\extracted\kube\" "C:\k\" -Force -Recurse

    start-service containerd
    Start-Service kubelet
  }
  
  ./kubectl uncordon $_.status.nodeInfo.machineID
  Write-Host "Done with $($_.status.nodeInfo.machineID)" #, closing session"
  # Remove-PSSession $_.pssession # BUG - seems to hang in a container
}
