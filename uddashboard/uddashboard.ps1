if (-not (Get-Module UniversalDashboard.Community)) {
    Import-Module UniversalDashboard.Community -RequiredVersion '2.9.0'
}

Start-UDDashboard -Port 80 -Wait -Dashboard (
    New-UDDashboard -Title "Powershell UniversalDashboard + API running on IIS inside Docker" -Content {
        New-UDCard -Endpoint {
            $tileData = Invoke-RestMethod -UseBasicParsing -Uri "http://localhost:8080/api/car"
            New-UDButton -Id "car" -Text $tileData.Car -BackgroundColor "#6f42c1" -onClick {}
        }
    }
)