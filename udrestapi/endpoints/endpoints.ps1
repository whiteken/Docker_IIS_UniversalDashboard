New-UDEndpoint -Url "user" -Method "GET" -Endpoint {
    @("Adam", "Sarah", "Bill") | ConvertTo-Json
}

$dataFolderPath = "C:\UniversalDashboard\udrestapi\datacache"

$jsonCache = Get-ChildItem -Path $dataFolderPath -Filter '*.json'
foreach ($file in $jsonCache) {
    New-Variable -Name $([System.IO.Path]::GetFileNameWithoutExtension($file)) -Value (Get-Content $file.FullName | ConvertFrom-Json)
}

if ($car) {
    $Cache:car = $car
}
else {
    $Cache:car = ([PSCustomObject]@{Car = "No car yet!" } | ConvertTo-Json)
}

#Get: Invoke-WebRequest http://localhost:8080/api/car
$endPointsDashing += New-UDEndpoint  -Url '/car' -EndPoint {
    $Cache:car | ConvertTo-Json
}

#Post: Invoke-WebRequest http://localhost:8080/api/car
$endPoints += New-UDEndpoint  -Url '/car' -Method POST -EndPoint {
    param($Body)

    $raw = $Body | ConvertFrom-Json

    $allowedCars = @('BMW','Ferarri','Mercedes')

    #Set up some kind of check on incoming data...
    if ($allowedCars -contains $raw.Car){
        $Cache:car = $raw
        $Cache:car | ConvertTo-Json | Out-File -FilePath "$dataFolderPath\car.json" -Force
    }
    else{
        Write-Error "$($raw.Car) is not an accepted type of car!"
    }
}

#Change the dashboard tile by sending diffent types of car...
#$body = [PSCustomObject]@{"Car" = "BMW" } | ConvertTo-Json
#Invoke-RestMethod -Uri 'http://localhost:9000/api/car' -Method Post -Body $body