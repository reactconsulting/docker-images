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
#   - Name: reactconsulting/windowsservercore-ltsc2016-nodejs
#   - Tag: v8.x
#
# Example build: docker build -t "reactconsulting/windowsservercore-ltsc2016-nodejs:v8.x" ./
# -----------------------------------

# Set start image
FROM reactconsulting/windowsservercore:ltsc2016

# Set image labes
LABEL mantainer="Nicola Biancolini <nicola.biancolini@reactconsulting.it>"

# Set default shell for run command
SHELL ["powershell", "-NoProfile", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue'; "]

# Download NodeJS latest LTS version for Windows
# https://nodejs.org/download
ENV NODEJS_HOME='C:\Program Files\nodejs'
RUN \
    $newPath = ('{0};{1}' -f $env:NODEJS_HOME, $env:PATH); \
    Write-Host ('Updating PATH: {0}' -f $newPath); \
    setx /M PATH $newPath

ENV NODEJS_VERSION=v8.11.4
ENV NODEJS_MAIN_FOLDER=node-v8.11.4-win-x64
ENV NODEJS_MSI=node-v8.11.4-x64.msi
ENV NODEJS_SHA256=452a0fa9cbac277558808ff888e0c924deb5b51945fad67e83fad6c7391c1203
RUN \
    $uri = ('https://nodejs.org/download/release/latest-v8.x/{0}' -f $env:NODEJS_MSI); \
	Write-Host ('Downloading {0} ...' -f $uri); \
	[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; \
	Invoke-WebRequest \
        -Uri $uri \
        -OutFile $env:NODEJS_MSI; \
	Write-Host ('Verifying sha256 ({0}) ...' -f $env:NODEJS_SHA256); \
	if ((Get-FileHash $env:NODEJS_MSI -Algorithm sha256).Hash -ine $env:NODEJS_SHA256) { \
		Write-Host 'FAILED!'; \
		exit 1; \
	}; \
	Write-Host 'Installing ...'; \
    Start-Process 'msiexec' \
        -ArgumentList '/qn', '/norestart', '/package', $env:NODEJS_MSI \
		-Wait; \
	Write-Host 'Verifying install ...'; \
	Write-Host '  node --version'; node --version; \
	Write-Host 'Removing ...'; \
	Remove-Item $env:NODEJS_MSI -Force; \
	Write-Host 'Complete.';

# Download Yarn latest Stable version for Windows
# https://yarnpkg.com/en/docs/install#windows-stable
ENV YARN_HOME='C:\Program Files (x86)\Yarn\bin'
RUN \
    $newPath = ('{0};{1}' -f $env:YARN_HOME, $env:PATH); \
    Write-Host ('Updating PATH: {0}' -f $newPath); \
    setx /M PATH $newPath

ENV YARN_VERSION=1.9.4
ENV YARN_MSI=latest.msi
RUN \
    $uri = ('https://yarnpkg.com/{0}' -f $env:YARN_MSI); \
	Write-Host ('Downloading {0} ...' -f $uri); \
	[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; \
	Invoke-WebRequest \
        -Uri $uri \
        -OutFile $env:YARN_MSI; \
	Write-Host 'Installing ...'; \
    Start-Process 'msiexec' \
        -ArgumentList '/qn', '/norestart', '/package', $env:YARN_MSI \
		-Wait; \
	$version = yarn --version; \
	Write-Host 'Verifying install ...'; \
	Write-Host '  yarn --version'; yarn --version; \
	Write-Host 'Removing ...'; \
	Remove-Item $env:YARN_MSI -Force; \
	Write-Host 'Complete.';