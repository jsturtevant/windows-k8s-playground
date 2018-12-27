FROM mcr.microsoft.com/powershell
RUN mkdir /opt/k
WORKDIR /opt/k
RUN ["pwsh", "-Command", "$ver = (Invoke-WebRequest -UseBasicParsing https://storage.googleapis.com/kubernetes-release/release/stable.txt).Content ; \
    Invoke-WebRequest -UseBasicParsing -OutFile ./kubectl -Uri \
    \"https://storage.googleapis.com/kubernetes-release/release/$($ver.TrimEnd())/bin/linux/amd64/kubectl\"" ]
RUN chmod +x kubectl
SHELL [ "pwsh" ]
ADD win-updater.ps1 /opt/k
ENTRYPOINT win-updater.ps1 
