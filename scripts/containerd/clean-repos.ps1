$choices = [Management.Automation.Host.ChoiceDescription[]] @(
  New-Object Management.Automation.Host.ChoiceDescription("&Yes","Remove repos")
  New-Object Management.Automation.Host.ChoiceDescription("&No","Do remove repos.")
)
$choice = $Host.UI.PromptForChoice("Are you sure?","This will remove all the repos.",$choices,1)

if ($choice  -eq  0){
  rm -Force -ErrorAction SilentlyContinue -Recurse $env:GOPATH/src/github.com/containerd/cri
  rm -Force -ErrorAction SilentlyContinue -Recurse $env:GOPATH/src/github.com/containerd/containerd
  rm -Force -ErrorAction SilentlyContinue -Recurse $env:GOPATH/src/github.com/kubernetes-sigs/cri-tools
  rm -Force -ErrorAction SilentlyContinue -Recurse $env:GOPATH/src/github.com/Microsoft/hcsshim
}


