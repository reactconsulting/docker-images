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
#   - Name: reactconsulting/windowsservercore-ltsc2016-msbuild
#   - Tag: 14.x
#
# Example build: docker build -t "reactconsulting/windowsservercore-ltsc2016-msbuild:14.x" ./
# -----------------------------------

# Reference staged image for Nuget
FROM reactconsulting/windowsservercore-ltsc2016-nuget as nuget

# Set start image
FROM reactconsulting/windowsservercore:ltsc2016

# Set image labes
LABEL mantainer="Nicola Biancolini <nicola.biancolini@reactconsulting.it>"

# Set default shell for run command
SHELL ["powershell", "-NoProfile", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue'; "]

# Download MSBuild 14 latest version
# https://www.microsoft.com/en-us/download
ENV MSBUILD_HOME='C:\Program Files (x86)\MSBuild\14.0\Bin'
RUN \
    $newPath = ('{0};{1}' -f $env:MSBUILD_HOME, $env:PATH); \
    Write-Host ('Updating PATH: {0}' -f $newPath); \
    setx /M PATH $newPath

RUN \
    $uri = 'https://download.microsoft.com/download/E/E/D/EEDF18A8-4AED-4CE0-BEBE-70A83094FC5A/BuildTools_Full.exe'; \
	Write-Host ('Downloading {0} ...' -f $uri); \
	[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; \
	Invoke-WebRequest \
        -Uri $uri \
        -OutFile BuildTools_Full.exe; \
	Write-Host 'Installing ...'; \
    Start-Process \
		-FilePath BuildTools_Full.exe \
		-ArgumentList '/Passive', '/NoRestart' \
		-PassThru | Wait-Process; \
	Write-Host 'Verifying install ...'; \
	Write-Host '  msbuild.exe /version'; msbuild.exe /version; \
	Write-Host 'Removing ...'; \
	Remove-Item BuildTools_Full.exe -Force; \
	Write-Host 'Complete.';

COPY --from=nuget C:\\Nuget C:\\Nuget

# Download MSBuild targets for Web and WebApplications
# https://www.nuget.org/packages/MSBuild.Microsoft.VisualStudio.Web.targets
RUN \
    mkdir 'C:\\Program Files (x86)\\MSBuild\\Microsoft\\VisualStudio\\v14.0'; \
    cd 'C:\\Program Files (x86)\\MSBuild\\Microsoft\\VisualStudio\\v14.0'; & \
    'C:\\Nuget\\nuget.exe' Install MSBuild.Microsoft.VisualStudio.Web.targets -Version 14.0.0.3

# Download MSBuild targets for OfficeTools
# https://www.nuget.org/packages/MSBuild.Microsoft.VisualStudio.Tools.Office.targets
RUN \
	cd 'C:\\Program Files (x86)\\MSBuild\\Microsoft\\VisualStudio\\v14.0'; & \
    'C:\\Nuget\\nuget.exe' Install MSBuild.Microsoft.VisualStudio.Tools.Office.targets -Version 15.0.1

RUN \
	rm -r C:\\Nuget