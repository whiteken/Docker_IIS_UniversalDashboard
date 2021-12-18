#take care that port here matches IIS
Start-UDRestApi -Port 8080 -Wait -Endpoint @(
    Get-ChildItem ([IO.Path]::Combine($PSScriptRoot, 'endpoints')) -Filter '*.ps1' | ForEach-Object {
        Write-Debug "Loading endpoint file: $($_.Name)"
        $ExecutionContext.InvokeCommand.InvokeScript(
            $false,
            (
                [scriptblock]::Create(
                    [io.file]::ReadAllText(
                        $_.FullName
                    )
                )
            ),
            $null,
            $null
        )
    }
)