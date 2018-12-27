choco install mingw -y
choco install make -y

echo "clone containderd-cri"
go get github.com/containerd/cri
Push-Location $env:GOPATH/src/github.com/containerd/cri
git remote add jterry75 https://github.com/jterry75/cri.git
git fetch jterry75
git checkout windows_port
Pop-Location

echo "clone containderd"
go get github.com/containerd/containerd

echo "clone cri-tools"
go get github.com/kubernetes-sigs/cri-tools

echo "clone hcsshim (runhcs)"
go get github.com/Microsoft/opengcs
go get github.com/linuxkit/virtsock
go get github.com/opencontainers/runtime-spec
go get github.com/microsoft/hcsshim


