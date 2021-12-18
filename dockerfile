FROM mcr.microsoft.com/windows/servercore/iis

RUN powershell -NoProfile -Command Remove-Item -Recurse C:\inetpub\wwwroot\*

WORKDIR /
RUN mkdir UniversalDashboard
RUN mkdir Log
RUN mkdir Temp

WORKDIR /UniversalDashboard
RUN mkdir UDDashboard
RUN mkdir UDRestAPI

WORKDIR /UniversalDashboard/UDDashboard
COPY /module/UniversalDashboard.Community/2.9.0/ .
COPY /webconfigs/uddashboard/web.config .

WORKDIR /UniversalDashboard/UDRestAPI
COPY /module/UniversalDashboard.Community/2.9.0/ .
COPY /webconfigs/udrestapi/web.config .

WORKDIR /Temp
COPY /tools/ .

SHELL ["powershell", "-command"]
RUN Install-WindowsFeature -name Web-WebSockets
RUN Install-WindowsFeature -Name NET-WCF-HTTP-Activation45
RUN Start-Process -FilePath "./dotnet-hosting-3.1.15-win.exe" -Wait -ArgumentList "/Quiet"
RUN New-WebAppPool -Name UDRestAPI
RUN New-WebAppPool -Name UDDashboard
RUN Get-Website -Name 'Default Web Site' | Remove-Website
RUN New-Website -Name UDDashboard -Port 80 -ApplicationPool UDDashboard -PhysicalPath C:\UniversalDashboard\UDDashboard\ -Force
RUN New-Website -Name UDRestAPI -Port 8080 -ApplicationPool UDRestAPI -PhysicalPath C:\UniversalDashboard\UDRestAPI\ -Force
#Install ASP.NET Core hosting bundle - see https://docs.universaldashboard.io/webserver/running-dashboards/iis
RUN Start-Process -FilePath "./dotnet-hosting-2.2.8-win.exe" -Wait -ArgumentList "/Quiet"
RUN .\finalsteps.ps1

#Website port
EXPOSE 80/tcp

#API port
EXPOSE 8080/tcp