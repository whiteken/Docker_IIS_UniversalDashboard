$dataFolderPath = "C:\UniversalDashboard\udrestapi\datacache"

$jsonCache = Get-ChildItem -Path $dataFolderPath -Filter '*.json'
foreach ($file in $jsonCache) {
    New-Variable -Name $([System.IO.Path]::GetFileNameWithoutExtension($file)) -Value (Get-Content $file.FullName | ConvertFrom-Json)
}

if ($car) {
    $Cache:car = $car
}
else {
    $Cache:car = [PSCustomObject]@{Car = "No car yet!" }
}

#Get: Invoke-WebRequest http://localhost:8080/api/car
$endPoints += New-UDEndpoint  -Url '/car' -EndPoint {
    $Cache:car | ConvertTo-Json
}

#Post: Invoke-WebRequest http://localhost:8080/api/car
$endPoints += New-UDEndpoint  -Url '/car' -Method Post -EndPoint {
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