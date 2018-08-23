# -----------------------------------
# Author: Nicola Biancolini
#         nicola.biancolini@reactconsulting.it
#
# Company: React Consulting S.r.l.
#          http://reactconsulting.it
#
# Summary: Docker base image for windows platform company implementations.
#
# Container informations
#   - Name: reactconsulting/windowsservercore-ltsc2016-git
#   - Tag: 
#
# Example build: docker build -t "reactconsulting/windowsservercore-ltsc2016-git" ./
# -----------------------------------

# Set start image
FROM reactconsulting/windowsservercore:ltsc2016

# Set image labes
LABEL mantainer="Nicola Biancolini <nicola.biancolini@reactconsulting.it>"

# Set default shell for run command
SHELL ["powershell", "-NoProfile", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue'; "]

# Download Git latest version for Windows
# https://github.com/git-for-windows/git/releases
ENV GIT_HOME=C:\\MinGit
RUN \
    $newPath = ('{0}\cmd;{1}' -f $env:GIT_HOME, $env:PATH); \
    Write-Host ('Updating PATH: {0}' -f $newPath); \
    setx /M PATH $newPath

ENV GIT_VERSION=v2.18.0.windows.1
ENV GIT_GITFORWINDOWS_ZIP=MinGit-2.18.0-64-bit.zip
ENV GIT_GITFORWINDOWS_SHA256=1dfd05de1320d57f448ed08a07c0b9de2de8976c83840f553440689b5db6a1cf
RUN \
    $uri = ('https://github.com/git-for-windows/git/releases/download/{0}/{1}' -f $env:GIT_VERSION, $env:GIT_GITFORWINDOWS_ZIP); \
	Write-Host ('Downloading {0} ...' -f $uri); \
	[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; \
	Invoke-WebRequest \
        -Uri $uri \
        -OutFile mingit.zip; \
	Write-Host ('Verifying sha256 ({0}) ...' -f $env:GIT_GITFORWINDOWS_SHA256); \
	if ((Get-FileHash mingit.zip -Algorithm sha256).Hash -ne $env:GIT_GITFORWINDOWS_SHA256) { \
		Write-Host 'FAILED!'; \
		exit 1; \
	}; \
	Write-Host 'Expanding ...'; \
    Expand-Archive \
        -Path mingit.zip \
        -DestinationPath $env:GIT_HOME ; \
	Write-Host 'Verifying install ...'; \
	Write-Host '  git --version'; git --version; \
	Write-Host 'Removing ...'; \
	Remove-Item mingit.zip -Force; \
	Write-Host 'Complete.';