Function Set-GroqApiKey {
    <#
    .SYNOPSIS
        Set the Groq Api Key in a profile folder and file
     
     
    .NOTES
        Name: Set-GroqApiKey
        Author: Alex Ries
        Version: 1.0
        DateCreated: 2024-May 6
     
     
    .EXAMPLE
        Set-GroqApiKey "my_apikeyhere"
     
     
    .LINK
        https://midnightsushi.net/
    #>
    
    [CmdletBinding()]
    param(
        [Parameter(
            Position = 0,
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            ValueFromRemainingArguments = $true
            )]
        [string]  $ApiKey
    )

    $directorySeparator = [System.IO.Path]::DirectorySeparatorChar
    $appFolderName = ".groqpshelp"
    $apiKeyFilname = ".apikey"
    $appFolderPath = "$($env:USERPROFILE + $directorySeparator + $appFolderName)"
    
    if (!(Test-Path -Path $appFolderPath -PathType Container)) {
        New-Item -Path $env:USERPROFILE -Name $appFolderName -ItemType "directory"
    }
    
    New-Item -Path $appFolderPath -Name $apiKeyFilname -ItemType "file" -Value $ApiKey -Force | Out-Null

}