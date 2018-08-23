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
#   - Name: reactconsulting/windowsservercore-ltsc2016-nuget
#   - Tag:
#
# Example build: docker build -t "reactconsulting/windowsservercore-ltsc2016-nuget" ./
# -----------------------------------

# Set start image
FROM reactconsulting/windowsservercore:ltsc2016

# Set image labes
LABEL mantainer="Nicola Biancolini <nicola.biancolini@reactconsulting.it>"

# Set default shell for run command
SHELL ["powershell", "-NoProfile", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue'; "]

# Download Nuget latest version for Windows
# https://www.nuget.org/downloads
ARG nuget_version=v4.7.1
ENV NUGET_VERSION=$nuget_version
ENV NUGET_HOME=C:\\Nuget
RUN \
    $newPath = ('{0};{1}' -f $env:NUGET_HOME, $env:PATH); \
    Write-Host ('Updating PATH: {0}' -f $newPath); \
    setx /M PATH $newPath

RUN \
	mkdir $env:NUGET_HOME; \
	cd $env:NUGET_HOME; \
	$uri = ('https://dist.nuget.org/win-x86-commandline/{0}/nuget.exe' -f $env:NUGET_VERSION); \
	Write-Host ('Downloading {0} ...' -f $uri); \
	[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; \
	Invoke-WebRequest \
        -Uri $uri \
		-UseBasicParsing \
        -OutFile nuget.exe; \
	Write-Host 'Verifying install ...'; \
	Write-Host '  nuget help'; nuget help; \
	Write-Host 'Complete.';