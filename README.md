# Docker_IIS_UniversalDashboard
It's been a long term goal to get Universal Dashboard running on IIS inside a docker image.
I also wanted to run an API as a separate website inside IIS.

I finally had some free time..

Longer term would like to get the API into another container and put MySQL behind it so this is just a proof of concept at this stage.

This repo contains the base files for docker universal dashboard project.  Containerized PowerShell Universal Dashboard and API running inside IIS on ASP.NET Core.
Published image is available on dockerhub [here](https://hub.docker.com/r/bayranshade/universaldashboard).

For more detailed notes see.. /notes/dockernotes.ipynb for more details.
Requires .Net SDK 6.0 + [VSCode extension](https://marketplace.visualstudio.com/items?itemName=ms-dotnettools.dotnet-interactive-vscode)